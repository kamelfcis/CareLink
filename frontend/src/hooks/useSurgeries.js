import { useCallback, useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { getPatientRecordId } from '../lib/chronicConditionsCache';
import {
  getCachedSurgeries,
  prefetchSurgeries,
  setCachedSurgeries,
} from '../lib/surgeriesCache';

export function useSurgeries() {
  const { patient, patientLoading } = useAuth();
  const patientId = getPatientRecordId(patient);
  const cached = patientId ? getCachedSurgeries(patientId) : null;

  const [surgeries, setSurgeries] = useState(cached ?? []);
  const [loading, setLoading] = useState(Boolean(patientLoading || (patientId && !cached)));
  const [error, setError] = useState(null);

  useEffect(() => {
    if (patientLoading) {
      return;
    }

    if (!patientId) {
      setSurgeries([]);
      setLoading(false);
      return;
    }

    const existing = getCachedSurgeries(patientId);
    if (existing) {
      setSurgeries(existing);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);
    setError(null);

    prefetchSurgeries(patientId)
      .then((data) => {
        if (!cancelled) {
          setSurgeries(data);
        }
      })
      .catch((fetchError) => {
        if (!cancelled) {
          console.error('Error fetching surgeries:', fetchError);
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
    (nextSurgeries) => {
      if (!patientId) return;
      setCachedSurgeries(patientId, nextSurgeries);
      setSurgeries(nextSurgeries);
    },
    [patientId]
  );

  return {
    patientId,
    surgeries,
    loading,
    error,
    syncCache,
  };
}
