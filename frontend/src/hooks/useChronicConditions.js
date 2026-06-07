import { useCallback, useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import {
  getCachedChronicConditions,
  getPatientRecordId,
  prefetchChronicConditions,
  setCachedChronicConditions,
} from '../lib/chronicConditionsCache';

export function useChronicConditions() {
  const { patient, patientLoading } = useAuth();
  const patientId = getPatientRecordId(patient);
  const cached = patientId ? getCachedChronicConditions(patientId) : null;

  const [conditions, setConditions] = useState(cached ?? []);
  const [loading, setLoading] = useState(Boolean(patientLoading || (patientId && cached == null)));
  const [error, setError] = useState(null);

  useEffect(() => {
    if (patientLoading) {
      return;
    }

    if (!patientId) {
      setConditions([]);
      setLoading(false);
      return;
    }

    const existing = getCachedChronicConditions(patientId);
    if (existing) {
      setConditions(existing);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);
    setError(null);

    prefetchChronicConditions(patientId)
      .then((data) => {
        if (!cancelled) {
          setConditions(data);
        }
      })
      .catch((fetchError) => {
        if (!cancelled) {
          console.error('Error fetching conditions:', fetchError);
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
    (nextConditions) => {
      if (!patientId) return;
      setCachedChronicConditions(patientId, nextConditions);
      setConditions(nextConditions);
    },
    [patientId]
  );

  return {
    patientId,
    conditions,
    loading,
    error,
    syncCache,
    profileReady: !patientLoading && Boolean(patientId),
  };
}
