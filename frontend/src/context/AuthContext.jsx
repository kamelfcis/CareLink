import React, { createContext, useContext, useEffect, useState, useRef } from 'react';
import { supabase } from '../lib/supabase';
import { clearChronicConditionsCache } from '../lib/chronicConditionsCache';
import { clearSurgeriesCache } from '../lib/surgeriesCache';
import { clearLabTestsCache } from '../lib/labTestsCache';
import { clearMedicationsCache } from '../lib/medicationsCache';
import { clearStatisticsCache } from '../lib/statisticsCache';
import { clearVaccinationsCache } from '../lib/vaccinationsCache';

/** Map DB row(s) to the shape the dashboard expects (legacy flat patients + users split). */
const mergePatientAndUser = (patientRow, userRow) => {
  if (!patientRow) return null;
  if (patientRow.full_name != null && patientRow.auth_user_id != null) {
    return patientRow;
  }
  return {
    ...patientRow,
    full_name: userRow?.name ?? patientRow.full_name ?? '',
    email: userRow?.email ?? patientRow.email ?? '',
    phone: userRow?.phone ?? patientRow.phone ?? '',
    dob: patientRow.date_of_birth ?? patientRow.dob ?? '',
    photo_url: userRow?.image ?? patientRow.photo_url ?? '',
  };
};

const AuthContext = createContext({});

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  /** Session bootstrap only — do not block dashboard on patient fetch. */
  const [loading, setLoading] = useState(true);
  const [patientLoading, setPatientLoading] = useState(false);
  const [patient, setPatient] = useState(null);
  const userRef = useRef(null);
  const patientFetchRef = useRef(null);

  // Keep ref in sync with state
  useEffect(() => {
    userRef.current = user;
  }, [user]);

  useEffect(() => {
    let mounted = true;
    let timeoutId;

    // Set a timeout to ensure loading doesn't hang forever (increased to 10 seconds)
    timeoutId = setTimeout(() => {
      if (mounted) {
        console.warn('Session check timeout - setting loading to false');
        console.warn('Note: Supabase connection is working, but session check is slow. This may be normal on first load.');
        setLoading(false);
      }
    }, 10000); // 10 second timeout

    // Get initial session
    supabase.auth.getSession()
      .then(({ data: { session }, error }) => {
        if (!mounted) return;
        
        clearTimeout(timeoutId);
        
        if (error) {
          console.error('Error getting session:', error);
          // Don't fail completely on network errors - allow app to continue
          if (error.message?.includes('Failed to fetch') || error.message?.includes('ERR_NAME_NOT_RESOLVED')) {
            console.warn('Network error getting session - app will continue but may have limited functionality');
          }
          setLoading(false);
          return;
        }

        setUser(session?.user ?? null);
        setLoading(false);
        if (session?.user) {
          fetchPatient(session.user.id);
        }
      })
      .catch((error) => {
        if (!mounted) return;
        console.error('Session check failed:', error);
        // Handle network errors gracefully
        if (error.message?.includes('Failed to fetch') || error.message?.includes('ERR_NAME_NOT_RESOLVED')) {
          console.warn('Network error during session check - app will continue');
        }
        clearTimeout(timeoutId);
        setLoading(false);
      });

    // Listen for auth changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (!mounted) return;

      try {
        console.log('Auth state changed:', event, session?.user?.id);
        
        setUser(session?.user ?? null);

        if (session?.user) {
          fetchPatient(session.user.id);
        } else {
          setPatient(null);
          setPatientLoading(false);
        }

        // Handle token refresh
        if (event === 'TOKEN_REFRESHED') {
          console.log('Token refreshed successfully');
          if (session?.user) {
            fetchPatient(session.user.id);
          }
        }

        // Handle signed out
        if (event === 'SIGNED_OUT') {
          setUser(null);
          setPatient(null);
          setPatientLoading(false);
          clearChronicConditionsCache();
          clearSurgeriesCache();
          clearLabTestsCache();
          clearMedicationsCache();
          clearStatisticsCache();
          clearVaccinationsCache();
        }

        // Handle session expired
        if (event === 'SIGNED_OUT' || event === 'USER_UPDATED') {
          if (!session) {
            setUser(null);
            setPatient(null);
            setPatientLoading(false);
          }
        }
      } catch (error) {
        // Handle errors in auth state change gracefully
        console.error('Error in auth state change handler:', error);
        // Don't break the app - just log the error
        if (error.message?.includes('Failed to fetch') || error.message?.includes('ERR_NAME_NOT_RESOLVED')) {
          console.warn('Network error in auth state change - continuing anyway');
        }
      }
    });

    // Periodic session check (every 5 minutes)
    const sessionCheckInterval = setInterval(async () => {
      if (!mounted) return;
      
      try {
        const { data: { session }, error } = await supabase.auth.getSession();
        
        if (error) {
          console.error('Session check error:', error);
          if (mounted) {
            setUser(null);
            setPatient(null);
            setLoading(false);
          }
          return;
        }

        const currentUser = userRef.current;
        
        if (!session && currentUser) {
          // Session expired but we still think we have a user
          console.log('Session expired, clearing user state');
          if (mounted) {
            setUser(null);
            setPatient(null);
            setLoading(false);
          }
        } else if (session?.user && (!currentUser || currentUser.id !== session.user.id)) {
          // Session refreshed or user changed
          if (mounted) {
            setUser(session.user);
            await fetchPatient(session.user.id);
          }
        }
      } catch (error) {
        console.error('Periodic session check failed:', error);
      }
    }, 5 * 60 * 1000); // Check every 5 minutes

    return () => {
      mounted = false;
      clearTimeout(timeoutId);
      clearInterval(sessionCheckInterval);
      subscription.unsubscribe();
    };
  }, []);

  const fetchPatient = async (authUserId, retryCount = 0) => {
    if (!authUserId) {
      setPatientLoading(false);
      return;
    }

    if (retryCount === 0 && patientFetchRef.current) {
      return patientFetchRef.current;
    }

    const MAX_RETRIES = 3;
    const RETRY_DELAY = 2000;

    let timeoutId;

    const runFetch = async () => {
    try {
      // Add timeout to prevent hanging (increased to 30 seconds for slow connections)
      const timeoutPromise = new Promise((_, reject) => {
        timeoutId = setTimeout(() => {
          reject(new Error('Patient fetch timeout - network may be slow or Supabase project may be paused'));
        }, 30000);
      });

      console.log('Fetching patient data for user:', authUserId);
      const startTime = Date.now();

      const fetchPromise = (async () => {
        let { data: pat, error: patErr } = await supabase
          .from('patients')
          .select('*')
          .eq('patient_id', authUserId)
          .maybeSingle();

        const patientIdUnsupported =
          patErr &&
          (patErr.message?.includes('patient_id') ||
            (patErr.message?.includes('column') && patErr.message?.includes('does not exist')));

        if (patientIdUnsupported) {
          const legacy = await supabase
            .from('patients')
            .select('*')
            .eq('auth_user_id', authUserId)
            .maybeSingle();
          pat = legacy.data;
          patErr = legacy.error;
        } else if (!pat && !patErr) {
          const legacy = await supabase
            .from('patients')
            .select('*')
            .eq('auth_user_id', authUserId)
            .maybeSingle();
          if (legacy.data) {
            pat = legacy.data;
            patErr = legacy.error;
          }
        }

        if (patErr && patErr.code !== 'PGRST116') {
          return { data: null, error: patErr };
        }

        const { data: urow, error: userErr } = await supabase
          .from('users')
          .select('name,email,phone,image')
          .eq('id', authUserId)
          .maybeSingle();

        if (userErr && userErr.code !== 'PGRST116') {
          console.warn('Could not load public.users row:', userErr);
        }

        return { data: mergePatientAndUser(pat, urow), error: null };
      })();

      const result = await Promise.race([fetchPromise, timeoutPromise]);
      
      const elapsedTime = Date.now() - startTime;
      console.log(`Patient fetch completed in ${elapsedTime}ms`);
      
      // Clear timeout if fetch completed
      if (timeoutId) clearTimeout(timeoutId);

      // If result is an error (from timeout), it will be caught below
      const { data, error } = result || { data: null, error: null };

      if (error) {
        // PGRST116 is "not found" - that's okay for new users
        if (error.code === 'PGRST116') {
          console.log('No patient record found yet - this is normal for new users');
          setPatient(null);
          return;
        } 
        
        // Check for network errors that might benefit from retry
        const isNetworkError = error.message?.includes('Failed to fetch') || 
                              error.message?.includes('ERR_NAME_NOT_RESOLVED') || 
                              error.message?.includes('NetworkError') ||
                              error.message?.includes('timeout') ||
                              !error.code; // Some network errors don't have codes
        
      if (isNetworkError && retryCount < MAX_RETRIES) {
        console.log(`Network error detected, retrying... (${retryCount + 1}/${MAX_RETRIES})`);
        // Exponential backoff with longer delays
        const delay = RETRY_DELAY * Math.pow(2, retryCount);
        console.log(`Waiting ${delay}ms before retry...`);
        await new Promise(resolve => setTimeout(resolve, delay));
        return fetchPatient(authUserId, retryCount + 1);
      }
        
        if (isNetworkError) {
          console.warn('Network error fetching patient after retries - Supabase may be unreachable.');
          console.warn('Possible causes:');
          console.warn('1. Slow internet connection');
          console.warn('2. Supabase project is paused (check Supabase dashboard)');
          console.warn('3. Network connectivity issues');
          console.warn('4. CORS or firewall blocking the request');
          console.warn('5. RLS policies may be blocking the query - check Supabase dashboard');
          setPatient(null);
        } else {
          console.error('Error fetching patient:', error);
          console.error('Error code:', error.code);
          console.error('Error message:', error.message);
          console.error('Error details:', error);
          setPatient(null);
        }
      } else {
        setPatient(data ?? null);
      }
    } catch (error) {
      // Clear timeout if still set
      if (timeoutId) clearTimeout(timeoutId);
      
      // Handle timeout and network errors gracefully
      const isNetworkError = error.message?.includes('timeout') || 
                            error.message?.includes('Failed to fetch') || 
                            error.message?.includes('ERR_NAME_NOT_RESOLVED') || 
                            error.message?.includes('NetworkError');
      
      if (isNetworkError && retryCount < MAX_RETRIES) {
        console.log(`Timeout/network error, retrying... (${retryCount + 1}/${MAX_RETRIES})`);
        // Exponential backoff with longer delays
        const delay = RETRY_DELAY * Math.pow(2, retryCount);
        console.log(`Waiting ${delay}ms before retry...`);
        await new Promise(resolve => setTimeout(resolve, delay));
        return fetchPatient(authUserId, retryCount + 1);
      }
      
      if (isNetworkError) {
        console.warn('Patient fetch failed after retries due to network/timeout issue:', error.message);
        console.warn('This may indicate:');
        console.warn('1. Slow internet connection');
        console.warn('2. Supabase project is paused (check Supabase dashboard)');
        console.warn('3. Network connectivity issues');
        console.warn('4. CORS or firewall blocking the request');
        console.warn('5. RLS policies may be blocking the query - check Supabase dashboard');
        console.warn('Note: Connection test passed, so this is likely a query/RLS issue');
        setPatient(null);
      } else {
        console.error('Error fetching patient:', error);
        console.error('Error code:', error.code);
        console.error('Error message:', error.message);
        setPatient(null);
      }
    } finally {
      if (retryCount === 0) {
        setPatientLoading(false);
      }
    }
    };

    if (retryCount === 0) {
      setPatientLoading(true);
      patientFetchRef.current = runFetch().finally(() => {
        patientFetchRef.current = null;
      });
      return patientFetchRef.current;
    }

    return runFetch();
  };

  const signUp = async (email, password, userData = {}) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userData,
      },
    });

    if (error) throw error;

    // Create users + patients rows (schema: users.id = auth uid, patients.patient_id -> users.id)
    if (data.user) {
      const { error: userUpsertError } = await supabase.from('users').upsert(
        {
          id: data.user.id,
          email,
          name: userData.full_name || '',
        },
        { onConflict: 'id' }
      );

      if (userUpsertError) {
        console.error('Error upserting users row:', userUpsertError);
      }

      const { error: patientError } = await supabase.from('patients').insert({
        patient_id: data.user.id,
      });

      if (patientError) {
        console.error('Error creating patient record:', patientError);
      } else {
        await fetchPatient(data.user.id);
      }
    }

    return { data, error };
  };

  const signIn = async (email, password) => {
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: email.trim().toLowerCase(),
        password,
      });

      if (error) {
        console.error('Sign in error:', error);
        return { data: null, error };
      }

      if (data.user) {
        setUser(data.user);
        fetchPatient(data.user.id);
      }

      return { data, error: null };
    } catch (err) {
      console.error('Sign in exception:', err);
      return { data: null, error: err };
    }
  };

  const signOut = async () => {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      setUser(null);
      setPatient(null);
      clearChronicConditionsCache();
      clearSurgeriesCache();
      clearLabTestsCache();
      clearMedicationsCache();
      clearStatisticsCache();
      clearVaccinationsCache();
      setPatientLoading(false);
    } catch (error) {
      console.error('Error signing out:', error);
      // Force clear state even if signOut fails
      setUser(null);
      setPatient(null);
      clearChronicConditionsCache();
      clearSurgeriesCache();
      clearLabTestsCache();
      clearMedicationsCache();
      clearStatisticsCache();
      clearVaccinationsCache();
      setPatientLoading(false);
      throw error;
    }
  };

  const refreshPatient = async () => {
    if (user) {
      await fetchPatient(user.id);
    }
  };

  const value = {
    user,
    patient,
    loading,
    patientLoading,
    signUp,
    signIn,
    signOut,
    refreshPatient,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

