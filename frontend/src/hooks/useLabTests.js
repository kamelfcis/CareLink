import { useCallback, useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { getPatientRecordId } from '../lib/chronicConditionsCache';
import {
  getCachedLabTests,
  prefetchLabTests,
  setCachedLabTests,
} from '../lib/labTestsCache';

export function useLabTests() {
  const { patient, patientLoading } = useAuth();
  const patientId = getPatientRecordId(patient);
  const cached = patientId ? getCachedLabTests(patientId) : null;

  const [labTests, setLabTests] = useState(cached ?? []);
  const [loading, setLoading] = useState(Boolean(patientLoading || (patientId && !cached)));
  const [error, setError] = useState(null);

  useEffect(() => {
    if (patientLoading) {
      return;
    }

    if (!patientId) {
      setLabTests([]);
      setLoading(false);
      return;
    }

    const existing = getCachedLabTests(patientId);
    if (existing) {
      setLabTests(existing);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);
    setError(null);

    prefetchLabTests(patientId)
      .then((data) => {
        if (!cancelled) {
          setLabTests(data);
        }
      })
      .catch((fetchError) => {
        if (!cancelled) {
          console.error('Error fetching lab tests:', fetchError);
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

  const syncCache = useCallback(
    (nextLabTests) => {
      if (!patientId) return;
      setCachedLabTests(patientId, nextLabTests);
      setLabTests(nextLabTests);
    },
    [patientId]
  );

  return {
    patientId,
    labTests,
    loading,
    error,
    syncCache,
  };
}
