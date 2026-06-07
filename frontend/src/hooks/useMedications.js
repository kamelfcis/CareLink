import { useCallback, useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { getPatientRecordId } from '../lib/chronicConditionsCache';
import {
  getCachedMedications,
  prefetchMedications,
  setCachedMedications,
} from '../lib/medicationsCache';

export function useMedications() {
  const { patient, patientLoading } = useAuth();
  const patientId = getPatientRecordId(patient);
  const cached = patientId ? getCachedMedications(patientId) : null;

  const [medications, setMedications] = useState(cached ?? []);
  const [loading, setLoading] = useState(Boolean(patientLoading || (patientId && !cached)));
  const [error, setError] = useState(null);

  useEffect(() => {
    if (patientLoading) {
      return;
    }

    if (!patientId) {
      setMedications([]);
      setLoading(false);
      return;
    }

    const existing = getCachedMedications(patientId);
    if (existing) {
      setMedications(existing);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);
    setError(null);

    prefetchMedications(patientId)
      .then((data) => {
        if (!cancelled) {
          setMedications(data);
        }
      })
      .catch((fetchError) => {
        if (!cancelled) {
          console.error('Error fetching medications:', fetchError);
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
    (nextMedications) => {
      if (!patientId) return;
      setCachedMedications(patientId, nextMedications);
      setMedications(nextMedications);
    },
    [patientId]
  );

  return {
    patientId,
    medications,
    loading,
    error,
    syncCache,
  };
}
