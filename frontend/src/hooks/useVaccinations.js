import { useCallback, useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { getPatientRecordId } from '../lib/chronicConditionsCache';
import {
  getCachedVaccinations,
  prefetchVaccinations,
  setCachedVaccinations,
} from '../lib/vaccinationsCache';

export function useVaccinations() {
  const { patient, patientLoading } = useAuth();
  const patientId = getPatientRecordId(patient);
  const cached = patientId ? getCachedVaccinations(patientId) : null;

  const [vaccinations, setVaccinations] = useState(cached ?? []);
  const [loading, setLoading] = useState(Boolean(patientLoading || (patientId && !cached)));
  const [error, setError] = useState(null);

  useEffect(() => {
    if (patientLoading) {
      return;
    }

    if (!patientId) {
      setVaccinations([]);
      setLoading(false);
      return;
    }

    const existing = getCachedVaccinations(patientId);
    if (existing) {
      setVaccinations(existing);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);
    setError(null);

    prefetchVaccinations(patientId)
      .then((data) => {
        if (!cancelled) {
          setVaccinations(data);
        }
      })
      .catch((fetchError) => {
        if (!cancelled) {
          console.error('Error fetching vaccinations:', fetchError);
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
    (nextVaccinations) => {
      if (!patientId) return;
      setCachedVaccinations(patientId, nextVaccinations);
      setVaccinations(nextVaccinations);
    },
    [patientId]
  );

  return {
    patientId,
    vaccinations,
    loading,
    error,
    syncCache,
  };
}
