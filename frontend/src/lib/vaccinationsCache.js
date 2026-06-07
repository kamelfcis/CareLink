import { supabase } from './supabase';

const VACCINATION_COLUMNS =
  'id, vaccine_name, dose_number, vaccination_date, notes';

const cache = {
  patientId: null,
  data: null,
  promise: null,
};

export function getCachedVaccinations(patientId) {
  if (!patientId || cache.patientId !== patientId || !cache.data) {
    return null;
  }
  return cache.data;
}

export function clearVaccinationsCache() {
  cache.patientId = null;
  cache.data = null;
  cache.promise = null;
}

export function setCachedVaccinations(patientId, data) {
  cache.patientId = patientId;
  cache.data = data;
  cache.promise = null;
}

async function fetchFromSupabase(patientId) {
  const { data, error } = await supabase
    .from('vaccinations')
    .select(VACCINATION_COLUMNS)
    .eq('patient_id', patientId)
    .order('vaccination_date', { ascending: false, nullsFirst: false });

  if (error) throw error;
  return data || [];
}

export function prefetchVaccinations(patientId) {
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

export { VACCINATION_COLUMNS };
