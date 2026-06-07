import { supabase } from './supabase';

const MAX_RETRIES = 2;
const RETRY_DELAY = 1000;
const REQUEST_TIMEOUT_MS = 20000;

const EMPTY_PROFILE = {
  patient: null,
  chronic_conditions: [],
  surgeries: [],
  lab_tests: [],
  medications: [],
  allergies: [],
  vaccinations: [],
};

function normalizeRpcData(data) {
  if (Array.isArray(data)) {
    return data.length ? data[0] : null;
  }
  return data ?? null;
}

function normalizeProfile(raw) {
  if (!raw?.patient) return null;

  return {
    patient: raw.patient,
    chronic_conditions: raw.chronic_conditions ?? [],
    surgeries: raw.surgeries ?? [],
    lab_tests: raw.lab_tests ?? [],
    medications: raw.medications ?? [],
    allergies: raw.allergies ?? [],
    vaccinations: raw.vaccinations ?? [],
  };
}

function isNetworkError(error) {
  const message = error?.message ?? '';
  return (
    message.includes('Failed to fetch') ||
    message.includes('ERR_NAME_NOT_RESOLVED') ||
    message.includes('NetworkError') ||
    message.includes('timeout') ||
    !error?.code
  );
}

/**
 * Resolve public profile by URL uuid.
 * The uuid may be patients.id (dashboard QR) OR patients.patient_id (auth user id).
 * Handled server-side by get_public_profile(p_public_uuid).
 */
export async function fetchPublicProfile(publicUuid, retryCount = 0) {
  if (!publicUuid) {
    return { profile: null, error: 'Invalid profile ID' };
  }

  try {
    const timeoutPromise = new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Request timeout. Please try again.')), REQUEST_TIMEOUT_MS)
    );

    const rpcPromise = supabase.rpc('get_public_profile', {
      p_public_uuid: publicUuid,
    });

    const result = await Promise.race([rpcPromise, timeoutPromise]);
    const { data, error: rpcError } = result ?? { data: null, error: null };

    if (rpcError) {
      if (isNetworkError(rpcError) && retryCount < MAX_RETRIES) {
        await new Promise((resolve) =>
          setTimeout(resolve, RETRY_DELAY * Math.pow(2, retryCount))
        );
        return fetchPublicProfile(publicUuid, retryCount + 1);
      }

      if (rpcError.code === 'PGRST301' || rpcError.message?.includes('permission denied')) {
        return {
          profile: null,
          error: 'Access denied. The function may not be accessible to anonymous users.',
        };
      }

      return { profile: null, error: rpcError.message || 'Failed to load profile.' };
    }

    const normalized = normalizeProfile(normalizeRpcData(data));
    if (!normalized) {
      return { profile: EMPTY_PROFILE, error: 'PROFILE_NOT_FOUND' };
    }

    return { profile: normalized, error: null };
  } catch (err) {
    if (isNetworkError(err) && retryCount < MAX_RETRIES) {
      await new Promise((resolve) =>
        setTimeout(resolve, RETRY_DELAY * Math.pow(2, retryCount))
      );
      return fetchPublicProfile(publicUuid, retryCount + 1);
    }

    if (err.message === 'Request timeout. Please try again.' || isNetworkError(err)) {
      return {
        profile: null,
        error: 'The request took too long or failed. Please check your connection and try again.',
      };
    }

    return { profile: null, error: err.message || 'Failed to load profile.' };
  }
}

export const MEDICAL_SECTIONS = [
  { id: 'chronic_conditions', labelKey: 'publicProfile.chronicConditions', icon: 'heart', color: 'red' },
  { id: 'surgeries', labelKey: 'publicProfile.surgeries', icon: 'scissors', color: 'purple' },
  { id: 'lab_tests', labelKey: 'publicProfile.labTests', icon: 'file', color: 'blue' },
  { id: 'medications', labelKey: 'publicProfile.medications', icon: 'pill', color: 'green' },
  { id: 'allergies', labelKey: 'publicProfile.allergies', icon: 'alert', color: 'orange' },
  { id: 'vaccinations', labelKey: 'publicProfile.vaccinations', icon: 'syringe', color: 'cyan' },
];
