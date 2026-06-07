import { supabase } from './supabase';

const SURGERY_COLUMNS = 'id, operation_name, operation_date, notes';

const cache = {
  patientId: null,
  data: null,
  promise: null,
};

export function getCachedSurgeries(patientId) {
  if (!patientId || cache.patientId !== patientId || !cache.data) {
    return null;
  }
  return cache.data;
}

export function clearSurgeriesCache() {
  cache.patientId = null;
  cache.data = null;
  cache.promise = null;
}

export function setCachedSurgeries(patientId, data) {
  cache.patientId = patientId;
  cache.data = data;
  cache.promise = null;
}

async function fetchFromSupabase(patientId) {
  const { data, error } = await supabase
    .from('surgeries')
    .select(SURGERY_COLUMNS)
    .eq('patient_id', patientId)
    .order('operation_date', { ascending: false, nullsFirst: false });

  if (error) throw error;
  return data || [];
}

export function prefetchSurgeries(patientId) {
  if (!patientId) {
    return Promise.resolve([]);
  }

  if (cache.patientId === patientId && cache.data) {
    return Promise.resolve(cache.data);
  }

  if (cache.patientId === patientId && cache.promise) {
    return cache.promise;
  }

  cache.patientId = patientId;
  cache.promise = fetchFromSupabase(patientId)
    .then((data) => {
      cache.data = data;
      cache.promise = null;
      return data;
    })
    .catch((error) => {
      cache.promise = null;
      throw error;
    });

  return cache.promise;
}
