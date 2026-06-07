import React from 'react';
import { useTranslation } from 'react-i18next';
import { Badge } from '../ui/badge';
import {
  Heart,
  Scissors,
  FileText,
  Pill,
  AlertTriangle,
  Syringe,
  Inbox,
} from 'lucide-react';

const SECTION_META = {
  chronic_conditions: {
    icon: Heart,
    headerClass: 'from-red-50 to-orange-50',
    iconClass: 'bg-red-100 text-red-600',
    cardClass: 'border-red-100 from-white to-red-50/30',
    emptyKey: 'chronicConditions.noConditions',
  },
  surgeries: {
    icon: Scissors,
    headerClass: 'from-purple-50 to-indigo-50',
    iconClass: 'bg-purple-100 text-purple-600',
    cardClass: 'border-purple-100 from-white to-purple-50/30',
    emptyKey: 'surgeries.noSurgeries',
  },
  lab_tests: {
    icon: FileText,
    headerClass: 'from-blue-50 to-cyan-50',
    iconClass: 'bg-blue-100 text-blue-600',
    cardClass: 'border-blue-100 from-white to-blue-50/30',
    emptyKey: 'labTests.noLabTests',
  },
  medications: {
    icon: Pill,
    headerClass: 'from-green-50 to-emerald-50',
    iconClass: 'bg-green-100 text-green-600',
    cardClass: 'border-green-100 from-white to-green-50/30',
    emptyKey: 'medications.noMedications',
  },
  allergies: {
    icon: AlertTriangle,
    headerClass: 'from-red-100 to-orange-100',
    iconClass: 'bg-red-200 text-red-700',
    cardClass: 'border-red-200 from-red-50 to-orange-50/50',
    emptyKey: 'allergies.noAllergies',
    alert: true,
  },
  vaccinations: {
    icon: Syringe,
    headerClass: 'from-cyan-50 to-teal-50',
    iconClass: 'bg-cyan-100 text-cyan-600',
    cardClass: 'border-cyan-100 from-white to-cyan-50/30',
    emptyKey: 'vaccinations.noVaccinations',
  },
};

export function EmptySectionState({ sectionId }) {
  const { t } = useTranslation();
  const meta = SECTION_META[sectionId];
  const Icon = meta?.icon ?? Inbox;

  return (
    <div className="flex flex-col items-center justify-center py-12 px-4 text-center">
      <div className={`p-4 rounded-2xl mb-4 ${meta?.iconClass ?? 'bg-gray-100 text-gray-500'}`}>
        <Icon className="h-8 w-8 opacity-60" />
      </div>
      <p className="text-sm text-muted-foreground max-w-xs">
        {t(meta?.emptyKey ?? 'publicProfile.noRecords')}
      </p>
    </div>
  );
}

export function SectionHeader({ sectionId, title, count, badgeVariant = 'secondary' }) {
  const meta = SECTION_META[sectionId];
  const Icon = meta?.icon ?? Inbox;

  return (
    <div
      className={`flex items-center gap-3 px-6 py-4 bg-gradient-to-r ${meta?.headerClass ?? 'from-gray-50 to-gray-100'} border-b border-primary/10 rounded-t-2xl`}
    >
      <div className={`p-2 rounded-lg shrink-0 ${meta?.iconClass ?? 'bg-gray-100'}`}>
        <Icon className="h-5 w-5" />
      </div>
      <h2 className={`text-lg md:text-xl font-semibold flex-1 ${meta?.alert ? 'text-red-900' : 'text-gray-900'}`}>
        {title}
      </h2>
      <Badge variant={meta?.alert ? 'destructive' : badgeVariant}>{count}</Badge>
    </div>
  );
}

export { SECTION_META };
