import { supabase } from './supabase';

const CHRONIC_COLUMNS = 'id, name, notes, created_at';

const cache = {
  patientId: null,
  data: null,
  promise: null,
};

/** patients.id — used as FK on chronic_conditions.patient_id (not auth user id). */
export function getPatientRecordId(patient) {
  return patient?.id ?? null;
}

export function getCachedChronicConditions(patientId) {
  if (!patientId || cache.patientId !== patientId || cache.data == null) {
    return null;
  }
  return cache.data;
}

export function clearChronicConditionsCache() {
  cache.patientId = null;
  cache.data = null;
  cache.promise = null;
}

export function setCachedChronicConditions(patientId, data) {
  cache.patientId = patientId;
  cache.data = data;
  cache.promise = null;
}

async function fetchFromSupabase(patientId) {
  const { data, error } = await supabase
    .from('chronic_conditions')
    .select(CHRONIC_COLUMNS)
    .eq('patient_id', patientId)
    .order('created_at', { ascending: false });

  if (error) throw error;
  return data || [];
}

export function prefetchChronicConditions(patientId) {
  if (!patientId) {
    return Promise.resolve([]);
  }

  if (cache.patientId === patientId && cache.data != null) {
    return Promise.resolve(cache.data);
  }

  if (cache.patientId === patientId && cache.promise) {
    return cache.promise;
  }

  cache.patientId = patientId;
  cache.promise = fetchFromSupabase(patientId)
    .then((data) => {
      cache.promise = null;
      if (cache.patientId !== patientId) {
        return data;
      }
      if (cache.data == null) {
        cache.data = data;
      }
      return cache.data ?? data;
    })
    .catch((error) => {
      cache.promise = null;
      throw error;
    });

  return cache.promise;
}
