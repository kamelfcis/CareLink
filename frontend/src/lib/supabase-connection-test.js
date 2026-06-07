/**
 * Utility to test Supabase connection
 * This helps diagnose network and connectivity issues
 */

export const testSupabaseConnection = async () => {
  const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
  const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

  console.log('🔍 Testing Supabase Connection...');
  console.log('URL:', supabaseUrl);
  console.log('Anon Key:', supabaseAnonKey ? '***' + supabaseAnonKey.slice(-10) : 'MISSING');

  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('❌ Missing Supabase credentials in .env file');
    return { success: false, error: 'Missing credentials' };
  }

  try {
    // Test 1: Auth health (anon-friendly). Do NOT use GET /rest/v1/ — Supabase often
    // returns 401 for the OpenAPI root with anon keys ("Only service_role...").
    console.log('Test 1: Checking if Supabase URL is reachable (auth health)...');
    const urlTest = await fetch(`${supabaseUrl}/auth/v1/health`, {
      method: 'GET',
      headers: {
        apikey: supabaseAnonKey,
        Authorization: `Bearer ${supabaseAnonKey}`,
      },
      signal: AbortSignal.timeout(10000), // 10 second timeout
    });

    if (!urlTest.ok) {
      const body = await urlTest.text().catch(() => '');
      console.warn('⚠️ Auth health responded with status:', urlTest.status, body?.slice(0, 200));
    } else {
      console.log('✅ Supabase URL is reachable');
    }

    // Test 2: Try a simple query
    console.log('Test 2: Testing database connection...');
    const queryTest = await fetch(`${supabaseUrl}/rest/v1/patients?select=id&limit=1`, {
      method: 'GET',
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'Content-Type': 'application/json',
      },
      signal: AbortSignal.timeout(10000),
    });

    if (queryTest.ok) {
      console.log('✅ Database connection successful');
      return { success: true };
    } else {
      const errorText = await queryTest.text();
      console.warn('⚠️ Database query returned status:', queryTest.status);
      console.warn('Response:', errorText);
      return { success: false, error: `Query failed with status ${queryTest.status}` };
    }
  } catch (error) {
    console.error('❌ Connection test failed:', error);
    
    if (error.name === 'AbortError' || error.message?.includes('timeout')) {
      console.error('⏱️ Request timed out - Supabase may be unreachable or very slow');
      return { success: false, error: 'Connection timeout' };
    } else if (error.message?.includes('Failed to fetch') || error.message?.includes('ERR_NAME_NOT_RESOLVED')) {
      console.error('🌐 Network error - Check:');
      console.error('  1. Your internet connection');
      console.error('  2. Supabase project status (may be paused)');
      console.error('  3. Firewall or proxy settings');
      return { success: false, error: 'Network error' };
    } else {
      return { success: false, error: error.message };
    }
  }
};

// Auto-run connection test in development
if (import.meta.env.DEV && typeof window !== 'undefined') {
  // Run test after a short delay to not block initial load
  setTimeout(() => {
    testSupabaseConnection().then((result) => {
      if (!result.success) {
        console.warn('⚠️ Supabase connection test failed. The app may have limited functionality.');
        console.warn('Please check:');
        console.warn('1. Your internet connection');
        console.warn('2. Supabase project status in dashboard');
        console.warn('3. .env file has correct credentials');
      }
    });
  }, 2000);
}


