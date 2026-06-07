import { createClient } from '@supabase/supabase-js';

// Get Supabase credentials from environment variables
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

// Debug: Check if environment variables are loaded
if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Missing Supabase environment variables!');
  console.error('VITE_SUPABASE_URL:', supabaseUrl);
  console.error('VITE_SUPABASE_ANON_KEY:', supabaseAnonKey ? '***' : 'missing');
  throw new Error('Supabase configuration is missing. Please check your .env file.');
}

if (supabaseUrl.includes('your-project') || supabaseAnonKey.includes('your-anon-key')) {
  console.error('⚠️ Using placeholder Supabase credentials! Please update your .env file.');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
    storage: window.localStorage,
    storageKey: 'supabase.auth.token',
  },
  global: {
    headers: {
      'x-client-info': 'carelink-web',
    },
  },
  db: {
    schema: 'public',
  },
});

// Test connection on load (non-blocking)
if (typeof window !== 'undefined') {
  // Check if Supabase URL is reachable
  console.log('Supabase URL:', supabaseUrl);
  console.log('Supabase configured. If you see network errors, check:');
  console.log('1. Your internet connection');
  console.log('2. Supabase project status (may be paused)');
  console.log('3. CORS settings in Supabase dashboard');
}

