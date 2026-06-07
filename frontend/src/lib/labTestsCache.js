import { supabase } from './supabase';

const LAB_TEST_COLUMNS = 'id, test_name, test_date, test_number, notes, file_path';

const cache = {
  patientId: null,
  data: null,
  promise: null,
};

export function getCachedLabTests(patientId) {
  if (!patientId || cache.patientId !== patientId || !cache.data) {
    return null;
  }
  return cache.data;
}

export function clearLabTestsCache() {
  cache.patientId = null;
  cache.data = null;
  cache.promise = null;
}

export function setCachedLabTests(patientId, data) {
  cache.patientId = patientId;
  cache.data = data;
  cache.promise = null;
}

async function fetchFromSupabase(patientId) {
  const { data, error } = await supabase
    .from('lab_tests')
    .select(LAB_TEST_COLUMNS)
    .eq('patient_id', patientId)
    .order('test_date', { ascending: false, nullsFirst: false });

  if (error) throw error;
  return data || [];
}

export function prefetchLabTests(patientId) {
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

export { LAB_TEST_COLUMNS };
