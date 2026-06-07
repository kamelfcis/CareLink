import { prefetchChronicConditions } from './chronicConditionsCache';
import { prefetchSurgeries } from './surgeriesCache';
import { prefetchLabTests } from './labTestsCache';
import { prefetchMedications } from './medicationsCache';
import { prefetchStatistics } from './statisticsCache';
import { prefetchVaccinations } from './vaccinationsCache';

const PREFETCH_BY_ROUTE = {
  chronic: prefetchChronicConditions,
  surgeries: prefetchSurgeries,
  'lab-tests': prefetchLabTests,
  medications: prefetchMedications,
  statistics: prefetchStatistics,
  vaccinations: prefetchVaccinations,
};

/** Prefetch data for a single dashboard route segment (e.g. "chronic"). */
export function prefetchDashboardRoute(routeSegment, patientId) {
  if (!patientId || !routeSegment) return;
  const prefetch = PREFETCH_BY_ROUTE[routeSegment];
  if (prefetch) {
    prefetch(patientId);
  }
}

/** Current route segment from a dashboard pathname. */
export function getDashboardRouteSegment(pathname) {
  const parts = pathname.split('/').filter(Boolean);
  if (parts[0] !== 'dashboard' || parts.length < 2) return null;
  return parts[1];
}
