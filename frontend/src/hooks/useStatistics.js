import { useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { getPatientRecordId } from '../lib/chronicConditionsCache';
import { getCachedStatistics, prefetchStatistics } from '../lib/statisticsCache';

const EMPTY_STATS = {
  chronic: 0,
  surgeries: 0,
  medications: 0,
  labTests: 0,
  allergies: 0,
  vaccinations: 0,
};

export function useStatistics() {
  const { patient, patientLoading } = useAuth();
  const patientId = getPatientRecordId(patient);
  const cached = patientId ? getCachedStatistics(patientId) : null;

  const [stats, setStats] = useState(cached?.stats ?? EMPTY_STATS);
  const [recentActivity, setRecentActivity] = useState(cached?.recentActivity ?? []);
  const [loading, setLoading] = useState(Boolean(patientLoading || (patientId && !cached)));
  const [error, setError] = useState(null);

  useEffect(() => {
    if (patientLoading) {
      return;
    }

    if (!patientId) {
      setStats(EMPTY_STATS);
      setRecentActivity([]);
      setLoading(false);
      return;
    }

    const existing = getCachedStatistics(patientId);
    if (existing) {
      setStats(existing.stats);
      setRecentActivity(existing.recentActivity);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);
    setError(null);

    prefetchStatistics(patientId)
      .then((data) => {
        if (!cancelled) {
          setStats(data.stats);
          setRecentActivity(data.recentActivity);
        }
      })
      .catch((fetchError) => {
        if (!cancelled) {
          console.error('Error fetching statistics:', fetchError);
          setError(fetchError);
        }
      })
      .finally(() => {
        if (!cancelled) {
          setLoading(false);
        }
      });

    return () => {
      cancelled = true;
    };
  }, [patientLoading, patientId]);

  return {
    patientId,
    stats,
    recentActivity,
    loading,
    error,
  };
}
