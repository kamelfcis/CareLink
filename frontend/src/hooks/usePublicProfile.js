import { useState, useEffect, useCallback } from 'react';
import { fetchPublicProfile } from '../lib/publicProfile';

export function usePublicProfile(publicUuid) {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const load = useCallback(async () => {
    if (!publicUuid) {
      setError('Invalid profile ID');
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);

    const { profile: data, error: fetchError } = await fetchPublicProfile(publicUuid);

    if (fetchError === 'PROFILE_NOT_FOUND') {
      setProfile(null);
      setError('PROFILE_NOT_FOUND');
    } else if (fetchError) {
      setProfile(null);
      setError(fetchError);
    } else {
      setProfile(data);
      setError(null);
    }

    setLoading(false);
  }, [publicUuid]);

  useEffect(() => {
    load();
  }, [load]);

  return { profile, loading, error, refetch: load };
}
