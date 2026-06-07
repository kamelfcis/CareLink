import { supabase } from './supabase';

const cache = {
  patientId: null,
  data: null,
  promise: null,
};

export function getCachedStatistics(patientId) {
  if (!patientId || cache.patientId !== patientId || !cache.data) {
    return null;
  }
  return cache.data;
}

export function clearStatisticsCache() {
  cache.patientId = null;
  cache.data = null;
  cache.promise = null;
}

export function setCachedStatistics(patientId, data) {
  cache.patientId = patientId;
  cache.data = data;
  cache.promise = null;
}

async function countForTable(table, patientId) {
  const { count, error } = await supabase
    .from(table)
    .select('id', { count: 'exact', head: true })
    .eq('patient_id', patientId);

  if (error) throw error;
  return count || 0;
}

async function fetchFromSupabase(patientId) {
  const [
    chronic,
    surgeries,
    medications,
    labTests,
    allergies,
    vaccinations,
    chronicData,
    surgeriesData,
    medicationsData,
  ] = await Promise.all([
    countForTable('chronic_conditions', patientId),
    countForTable('surgeries', patientId),
    countForTable('medications', patientId),
    countForTable('lab_tests', patientId),
    countForTable('allergies', patientId),
    countForTable('vaccinations', patientId),
    supabase
      .from('chronic_conditions')
      .select('name, created_at')
      .eq('patient_id', patientId)
      .order('created_at', { ascending: false })
      .limit(5),
    supabase
      .from('surgeries')
      .select('operation_name, created_at')
      .eq('patient_id', patientId)
      .order('created_at', { ascending: false })
      .limit(5),
    supabase
      .from('medications')
      .select('medication_name, created_at')
      .eq('patient_id', patientId)
      .order('created_at', { ascending: false })
      .limit(5),
  ]);

  const allActivities = [];

  chronicData.data?.forEach((item) => {
    allActivities.push({ type: 'Chronic Condition', name: item.name, date: item.created_at });
  });
  surgeriesData.data?.forEach((item) => {
    allActivities.push({ type: 'Surgery', name: item.operation_name, date: item.created_at });
  });
  medicationsData.data?.forEach((item) => {
    allActivities.push({ type: 'Medication', name: item.medication_name, date: item.created_at });
  });

  allActivities.sort((a, b) => new Date(b.date) - new Date(a.date));

  return {
    stats: {
      chronic,
      surgeries,
      medications,
      labTests,
      allergies,
      vaccinations,
    },
    recentActivity: allActivities.slice(0, 10),
  };
}

export function prefetchStatistics(patientId) {
  if (!patientId) {
    return Promise.resolve({ stats: {}, recentActivity: [] });
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
