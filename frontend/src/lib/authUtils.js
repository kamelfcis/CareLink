/** Trim and lowercase email for consistent Supabase auth lookups. */
export const normalizeEmail = (email) => email.trim().toLowerCase();

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/** Client-side validation before hitting Supabase. */
export const validateLoginForm = (email, password) => {
  const normalized = normalizeEmail(email);

  if (!normalized) {
    return { valid: false, error: 'Please enter your email address.' };
  }
  if (!EMAIL_PATTERN.test(normalized)) {
    return { valid: false, error: 'Please enter a valid email address.' };
  }
  if (!password) {
    return { valid: false, error: 'Please enter your password.' };
  }
  if (password.length < 8) {
    return { valid: false, error: 'Password must be at least 8 characters.' };
  }

  return { valid: true, email: normalized };
};

/** Map Supabase / network errors to user-friendly copy. */
export const getAuthErrorMessage = (error) => {
  if (!error) return 'Something went wrong. Please try again.';

  const message = error.message || String(error);
  const lower = message.toLowerCase();

  if (lower.includes('invalid login credentials') || lower.includes('invalid email or password')) {
    return 'Invalid email or password. Please check your credentials and try again.';
  }
  if (lower.includes('email not confirmed')) {
    return 'Please verify your email address before signing in. Check your inbox for a confirmation email.';
  }
  if (
    lower.includes('failed to fetch') ||
    lower.includes('networkerror') ||
    lower.includes('network request failed') ||
    lower.includes('err_name_not_resolved')
  ) {
    return 'Unable to reach the server. Check your internet connection and try again.';
  }
  if (lower.includes('too many requests') || lower.includes('rate limit')) {
    return 'Too many sign-in attempts. Please wait a moment and try again.';
  }
  if (lower.includes('user is banned') || lower.includes('banned')) {
    return 'This account has been disabled. Please contact support.';
  }
  if (lower.includes('timeout')) {
    return 'The request timed out. Please try again.';
  }

  return message;
};

/**
 * Safe post-login destination: honor protected-route redirect, default to dashboard.
 * Only allows in-app paths (blocks open redirects).
 */
export const getPostLoginPath = (locationState) => {
  const from = locationState?.from;
  const pathname = from?.pathname;

  if (pathname && pathname.startsWith('/') && !pathname.startsWith('//')) {
    if (pathname === '/login' || pathname === '/signup') {
      return '/dashboard';
    }
    return `${pathname}${from.search || ''}${from.hash || ''}`;
  }

  return '/dashboard';
};
