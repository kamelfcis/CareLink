/**
 * Test patient query to diagnose RLS issues
 * Run this in browser console if patient fetch is failing
 */

import { supabase } from './supabase';

export const testPatientQuery = async (authUserId) => {
  console.log('🔍 Testing Patient Query...');
  console.log('Auth User ID:', authUserId);
  
  if (!authUserId) {
    console.error('❌ No auth user ID provided');
    return;
  }

  try {
    // Test 1: Check if we can query patients table at all
    console.log('Test 1: Checking if patients table is accessible...');
    const { data: allPatients, error: allError } = await supabase
      .from('patients')
      .select('id, auth_user_id')
      .limit(1);
    
    if (allError) {
      console.error('❌ Cannot access patients table:', allError);
      console.error('This suggests RLS policies are blocking access');
      return;
    }
    console.log('✅ Patients table is accessible');

    // Test 2: Try to query with auth_user_id filter
    console.log('Test 2: Querying patient with auth_user_id filter...');
    const startTime = Date.now();
    
    const { data, error } = await supabase
      .from('patients')
      .select('*')
      .eq('auth_user_id', authUserId)
      .maybeSingle();
    
    const elapsedTime = Date.now() - startTime;
    console.log(`Query completed in ${elapsedTime}ms`);

    if (error) {
      console.error('❌ Query failed:', error);
      console.error('Error code:', error.code);
      console.error('Error message:', error.message);
      
      if (error.code === 'PGRST301' || error.message?.includes('permission denied')) {
        console.error('⚠️ RLS Policy Issue:');
        console.error('The query is being blocked by Row Level Security policies.');
        console.error('Check your Supabase dashboard:');
        console.error('1. Go to Authentication > Policies');
        console.error('2. Check patients table policies');
        console.error('3. Ensure authenticated users can SELECT their own records');
      }
      return;
    }

    if (data) {
      console.log('✅ Patient record found:', data);
    } else {
      console.log('ℹ️ No patient record found - this is normal for new users');
    }

    return { data, error };
  } catch (err) {
    console.error('❌ Test failed with exception:', err);
    return { data: null, error: err };
  }
};

// Make it available globally for console debugging
if (typeof window !== 'undefined') {
  window.testPatientQuery = testPatientQuery;
  console.log('💡 Run testPatientQuery(userId) in console to test patient query');
}


