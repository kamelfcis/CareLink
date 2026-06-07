import React, { useState, useEffect, useRef, useMemo } from 'react';
import { useParams } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { useTranslation } from 'react-i18next';
import QRCode from 'qrcode';
import { usePublicProfile } from '../hooks/usePublicProfile';
import { MEDICAL_SECTIONS } from '../lib/publicProfile';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Badge } from '../components/ui/badge';
import SplashScreen from '../components/SplashScreen';
import LanguageToggle from '../components/LanguageToggle';
import PublicProfileSkeleton from '../components/public-profile/PublicProfileSkeleton';
import {
  EmptySectionState,
  SectionHeader,
  SECTION_META,
} from '../components/public-profile/MedicalSectionParts';
import {
  User,
  Heart,
  Scissors,
  FileText,
  Pill,
  AlertTriangle,
  Syringe,
  Calendar,
  Phone,
  Users,
  Ruler,
  Scale,
  Droplets,
  Stethoscope,
  Activity,
  FileCheck,
  ExternalLink,
  QrCode,
  Download,
  LayoutGrid,
} from 'lucide-react';

const TAB_ICONS = {
  overview: LayoutGrid,
  chronic_conditions: Heart,
  surgeries: Scissors,
  lab_tests: FileText,
  medications: Pill,
  allergies: AlertTriangle,
  vaccinations: Syringe,
};

const formatDate = (dateStr, locale) => {
  if (!dateStr) return null;
  try {
    return new Date(dateStr).toLocaleDateString(locale, {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  } catch {
    return dateStr;
  }
};

const formatShortDate = (dateStr, locale) => {
  if (!dateStr) return null;
  try {
    return new Date(dateStr).toLocaleDateString(locale, {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  } catch {
    return dateStr;
  }
};

const getInitials = (name) => {
  if (!name?.trim()) return '?';
  return name
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((w) => w[0]?.toUpperCase() ?? '')
    .join('');
};

function ChronicConditionsList({ items, locale, t }) {
  if (!items?.length) return <EmptySectionState sectionId="chronic_conditions" />;
  return (
    <div className="grid sm:grid-cols-1 md:grid-cols-2 gap-4 p-6">
      {items.map((condition, index) => (
        <motion.div
          key={condition.id}
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: index * 0.05 }}
          className={`border rounded-xl p-4 bg-gradient-to-br ${SECTION_META.chronic_conditions.cardClass} hover:shadow-md transition-shadow`}
        >
          <div className="flex items-start gap-3">
            <div className={`p-2 rounded-lg shrink-0 ${SECTION_META.chronic_conditions.iconClass}`}>
              <Heart className="h-4 w-4" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="font-semibold text-gray-900">{condition.name}</h3>
              {condition.notes && (
                <p className="text-sm text-gray-600 mt-2 leading-relaxed">{condition.notes}</p>
              )}
            </div>
          </div>
        </motion.div>
      ))}
    </div>
  );
}

function SurgeriesList({ items, locale, t }) {
  if (!items?.length) return <EmptySectionState sectionId="surgeries" />;
  return (
    <div className="grid sm:grid-cols-1 md:grid-cols-2 gap-4 p-6">
      {items.map((surgery, index) => (
        <motion.div
          key={surgery.id}
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: index * 0.05 }}
          className={`border rounded-xl p-4 bg-gradient-to-br ${SECTION_META.surgeries.cardClass} hover:shadow-md transition-shadow`}
        >
          <div className="flex items-start gap-3">
            <div className={`p-2 rounded-lg shrink-0 ${SECTION_META.surgeries.iconClass}`}>
              <Scissors className="h-4 w-4" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="font-semibold text-gray-900 mb-1">{surgery.operation_name}</h3>
              {surgery.operation_date && (
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <Calendar className="h-3.5 w-3.5 shrink-0" />
                  <span>{formatDate(surgery.operation_date, locale)}</span>
                </div>
              )}
              {surgery.notes && (
                <p className="text-sm text-gray-600 mt-2 leading-relaxed">{surgery.notes}</p>
              )}
            </div>
          </div>
        </motion.div>
      ))}
    </div>
  );
}

function LabTestsList({ items, locale, t }) {
  if (!items?.length) return <EmptySectionState sectionId="lab_tests" />;
  return (
    <div className="grid sm:grid-cols-1 md:grid-cols-2 gap-4 p-6">
      {items.map((test, index) => (
        <motion.div
          key={test.id}
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: index * 0.05 }}
          className={`border rounded-xl p-4 bg-gradient-to-br ${SECTION_META.lab_tests.cardClass} hover:shadow-md transition-shadow`}
        >
          <div className="flex items-start gap-3">
            <div className={`p-2 rounded-lg shrink-0 ${SECTION_META.lab_tests.iconClass}`}>
              <FileCheck className="h-4 w-4" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="font-semibold text-gray-900 mb-1">{test.test_name || t('publicProfile.unnamedTest')}</h3>
              <div className="flex flex-wrap gap-2 text-sm text-gray-600 mb-2">
                {test.test_date && (
                  <span className="inline-flex items-center gap-1">
                    <Calendar className="h-3 w-3" />
                    {formatShortDate(test.test_date, locale)}
                  </span>
                )}
                {test.test_number && (
                  <Badge variant="outline" className="text-xs">
                    {t('publicProfile.ref')}: {test.test_number}
                  </Badge>
                )}
              </div>
              {test.file_path && (
                <a
                  href={test.file_path}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-1.5 text-sm text-[#0d797e] hover:text-[#0a6268] font-medium"
                >
                  <ExternalLink className="h-3.5 w-3.5" />
                  {t('publicProfile.viewTestResult')}
                </a>
              )}
              {test.notes && (
                <p className="text-sm text-gray-600 mt-2 leading-relaxed">{test.notes}</p>
              )}
            </div>
          </div>
        </motion.div>
      ))}
    </div>
  );
}

function MedicationsList({ items, locale, t }) {
  if (!items?.length) return <EmptySectionState sectionId="medications" />;
  return (
    <div className="grid sm:grid-cols-1 md:grid-cols-2 gap-4 p-6">
      {items.map((medication, index) => (
        <motion.div
          key={medication.id}
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: index * 0.05 }}
          className={`border rounded-xl p-4 bg-gradient-to-br ${SECTION_META.medications.cardClass} hover:shadow-md transition-shadow`}
        >
          <div className="flex items-start gap-3">
            <div className={`p-2 rounded-lg shrink-0 ${SECTION_META.medications.iconClass}`}>
              <Pill className="h-4 w-4" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="font-semibold text-gray-900 mb-1">{medication.medication_name}</h3>
              <div className="flex flex-wrap gap-2 mb-2">
                {medication.dosage && (
                  <Badge variant="secondary" className="text-xs">
                    {t('publicProfile.dosage')}: {medication.dosage}
                  </Badge>
                )}
                {medication.frequency && (
                  <Badge variant="secondary" className="text-xs">
                    {t('publicProfile.frequency')}: {medication.frequency}
                  </Badge>
                )}
              </div>
              {medication.start_date && (
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <Calendar className="h-3 w-3 shrink-0" />
                  <span>
                    {medication.end_date
                      ? `${formatShortDate(medication.start_date, locale)} – ${formatShortDate(medication.end_date, locale)}`
                      : `${t('publicProfile.started')}: ${formatDate(medication.start_date, locale)}`}
                  </span>
                </div>
              )}
              {medication.notes && (
                <p className="text-sm text-gray-600 mt-2 leading-relaxed">{medication.notes}</p>
              )}
            </div>
          </div>
        </motion.div>
      ))}
    </div>
  );
}

function AllergiesList({ items, locale, t }) {
  if (!items?.length) return <EmptySectionState sectionId="allergies" />;
  return (
    <div className="grid sm:grid-cols-1 md:grid-cols-2 gap-4 p-6">
      {items.map((allergy, index) => (
        <motion.div
          key={allergy.id}
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: index * 0.05 }}
          className={`border-2 rounded-xl p-4 bg-gradient-to-br ${SECTION_META.allergies.cardClass} hover:shadow-md transition-shadow`}
        >
          <div className="flex items-start gap-3">
            <div className={`p-2 rounded-lg shrink-0 ${SECTION_META.allergies.iconClass}`}>
              <AlertTriangle className="h-4 w-4" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="font-bold text-red-900 mb-1">{allergy.allergy_name}</h3>
              {allergy.severity && (
                <Badge
                  variant={allergy.severity.toLowerCase() === 'severe' ? 'destructive' : 'secondary'}
                  className="mb-2 capitalize"
                >
                  {t('publicProfile.severity')}: {allergy.severity}
                </Badge>
              )}
              {allergy.notes && (
                <p className="text-sm text-gray-700 mt-1 leading-relaxed">{allergy.notes}</p>
              )}
            </div>
          </div>
        </motion.div>
      ))}
    </div>
  );
}

function VaccinationsList({ items, locale, t }) {
  if (!items?.length) return <EmptySectionState sectionId="vaccinations" />;
  return (
    <div className="grid sm:grid-cols-1 md:grid-cols-2 gap-4 p-6">
      {items.map((vaccination, index) => (
        <motion.div
          key={vaccination.id}
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: index * 0.05 }}
          className={`border rounded-xl p-4 bg-gradient-to-br ${SECTION_META.vaccinations.cardClass} hover:shadow-md transition-shadow`}
        >
          <div className="flex items-start gap-3">
            <div className={`p-2 rounded-lg shrink-0 ${SECTION_META.vaccinations.iconClass}`}>
              <Syringe className="h-4 w-4" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="font-semibold text-gray-900 mb-1">{vaccination.vaccine_name}</h3>
              <div className="flex flex-wrap gap-2 text-sm text-gray-600">
                {vaccination.dose_number != null && vaccination.dose_number !== '' && (
                  <Badge variant="outline" className="text-xs">
                    {t('publicProfile.dose')}: {vaccination.dose_number}
                  </Badge>
                )}
                {vaccination.vaccination_date && (
                  <span className="inline-flex items-center gap-1">
                    <Calendar className="h-3 w-3" />
                    {formatDate(vaccination.vaccination_date, locale)}
                  </span>
                )}
              </div>
              {vaccination.notes && (
                <p className="text-sm text-gray-600 mt-2 leading-relaxed">{vaccination.notes}</p>
              )}
            </div>
          </div>
        </motion.div>
      ))}
    </div>
  );
}

const SECTION_RENDERERS = {
  chronic_conditions: ChronicConditionsList,
  surgeries: SurgeriesList,
  lab_tests: LabTestsList,
  medications: MedicationsList,
  allergies: AllergiesList,
  vaccinations: VaccinationsList,
};

function PatientInfoPanel({ patient, locale, t }) {
  return (
    <Card className="border-primary/15 shadow-md overflow-hidden">
      <CardHeader className="bg-gradient-to-r from-[#0d797e]/10 to-[#0d797e]/5 border-b border-primary/10">
        <div className="flex items-center gap-3">
          <div className="p-2 bg-[#0d797e]/10 rounded-lg">
            <Activity className="h-5 w-5 text-[#0d797e]" />
          </div>
          <CardTitle className="text-xl">{t('publicProfile.patientInformation')}</CardTitle>
        </div>
      </CardHeader>
      <CardContent className="p-6">
        <div className="grid sm:grid-cols-2 gap-4">
          {patient.dob && (
            <InfoTile icon={Calendar} label={t('publicProfile.dateOfBirth')} value={formatDate(patient.dob, locale)} />
          )}
          {patient.gender && (
            <InfoTile
              icon={User}
              label={t('publicProfile.gender')}
              value={<Badge variant="secondary" className="capitalize">{patient.gender}</Badge>}
            />
          )}
          {patient.blood_type && (
            <InfoTile
              icon={Droplets}
              iconClass="text-red-500"
              label={t('publicProfile.bloodType')}
              value={<Badge variant="destructive">{patient.blood_type}</Badge>}
            />
          )}
          {(patient.height_cm || patient.weight_kg) && (
            <InfoTile
              icon={Activity}
              label={t('publicProfile.physicalStats')}
              value={
                <div className="flex flex-wrap gap-3">
                  {patient.height_cm && (
                    <span className="inline-flex items-center gap-1 font-semibold">
                      <Ruler className="h-4 w-4 text-gray-500" />
                      {patient.height_cm} cm
                    </span>
                  )}
                  {patient.weight_kg && (
                    <span className="inline-flex items-center gap-1 font-semibold">
                      <Scale className="h-4 w-4 text-gray-500" />
                      {patient.weight_kg} kg
                    </span>
                  )}
                </div>
              }
            />
          )}
        </div>
        {patient.emergency_contact && (
          <div className="mt-6 pt-6 border-t border-gray-200">
            <div className="flex items-center gap-2 mb-3">
              <Users className="h-5 w-5 text-[#0d797e]" />
              <p className="text-sm font-semibold text-gray-700">{t('publicProfile.emergencyContact')}</p>
            </div>
            <div className="bg-gradient-to-r from-red-50 to-orange-50 rounded-xl p-4 border border-red-100">
              <p className="font-semibold text-gray-900">{patient.emergency_contact.name}</p>
              {patient.emergency_contact.phone && (
                <a
                  href={`tel:${patient.emergency_contact.phone}`}
                  className="inline-flex items-center gap-2 text-sm text-gray-600 hover:text-[#0d797e] mt-2"
                >
                  <Phone className="h-4 w-4" />
                  {patient.emergency_contact.phone}
                </a>
              )}
              {patient.emergency_contact.relation && (
                <Badge variant="outline" className="mt-2">
                  {t('publicProfile.relation')}: {patient.emergency_contact.relation}
                </Badge>
              )}
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function InfoTile({ icon: Icon, label, value, iconClass = 'text-[#0d797e]' }) {
  return (
    <div className="flex items-start gap-3 p-3 rounded-xl bg-gray-50/80 hover:bg-[#0d797e]/5 transition-colors">
      <Icon className={`h-5 w-5 mt-0.5 shrink-0 ${iconClass}`} />
      <div className="min-w-0">
        <p className="text-xs text-gray-500 font-medium mb-1">{label}</p>
        <div className="font-semibold text-gray-900">{value}</div>
      </div>
    </div>
  );
}

function MedicalSectionPanel({ sectionId, items, title, locale, t }) {
  const Renderer = SECTION_RENDERERS[sectionId];
  return (
    <div className="rounded-2xl border border-primary/15 bg-white/90 backdrop-blur shadow-lg overflow-hidden">
      <SectionHeader sectionId={sectionId} title={title} count={items?.length ?? 0} />
      <Renderer items={items} locale={locale} t={t} />
    </div>
  );
}

const PublicPatientPage = () => {
  const { uuid } = useParams();
  const { t, i18n } = useTranslation();
  const locale = i18n.language === 'ar' ? 'ar-SA' : 'en-US';
  const { profile, loading, error } = usePublicProfile(uuid);
  const [showSplash, setShowSplash] = useState(true);
  const [activeTab, setActiveTab] = useState('overview');
  const [qrCanvasReady, setQrCanvasReady] = useState(false);
  const qrCanvasRef = useRef(null);

  const canvasRefCallback = (node) => {
    qrCanvasRef.current = node;
    setQrCanvasReady(!!node);
  };

  useEffect(() => {
    if (!uuid || !qrCanvasRef.current || !qrCanvasReady || showSplash || loading || !profile) return;

    const timer = setTimeout(async () => {
      try {
        await QRCode.toCanvas(qrCanvasRef.current, `${window.location.origin}/patient/${uuid}`, {
          width: 180,
          margin: 2,
          color: { dark: '#0d797e', light: '#FFFFFF' },
          errorCorrectionLevel: 'H',
        });
      } catch (err) {
        console.error('QR generation failed:', err);
      }
    }, 100);

    return () => clearTimeout(timer);
  }, [uuid, showSplash, qrCanvasReady, loading, profile]);

  const counts = useMemo(() => {
    if (!profile) return {};
    return MEDICAL_SECTIONS.reduce((acc, { id }) => {
      acc[id] = profile[id]?.length ?? 0;
      return acc;
    }, {});
  }, [profile]);

  const totalRecords = useMemo(
    () => Object.values(counts).reduce((sum, n) => sum + n, 0),
    [counts]
  );

  const tabs = useMemo(
    () => [
      { id: 'overview', labelKey: 'publicProfile.overview' },
      ...MEDICAL_SECTIONS.map(({ id, labelKey }) => ({ id, labelKey })),
    ],
    []
  );

  if (showSplash) {
    return (
      <AnimatePresence>
        <SplashScreen onComplete={() => setShowSplash(false)} />
      </AnimatePresence>
    );
  }

  if (loading) {
    return (
      <>
        <div className="fixed top-4 end-4 z-50">
          <LanguageToggle />
        </div>
        <PublicProfileSkeleton />
      </>
    );
  }

  if (error || !profile?.patient) {
    const message =
      error === 'PROFILE_NOT_FOUND'
        ? t('publicProfile.noPublicProfileMatch')
        : error || t('publicProfile.profileNotFound');

    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-50 via-teal-50/30 to-slate-100 px-4">
        <div className="fixed top-4 end-4 z-50">
          <LanguageToggle />
        </div>
        <motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }}>
          <Card className="max-w-md border-red-200 bg-white/95 shadow-xl">
            <CardHeader>
              <div className="flex items-center gap-3">
                <div className="p-2 bg-red-100 rounded-full">
                  <AlertTriangle className="h-6 w-6 text-red-600" />
                </div>
                <div>
                  <CardTitle className="text-red-900">{t('publicProfile.error')}</CardTitle>
                  <CardDescription className="text-red-700 mt-1">{message}</CardDescription>
                </div>
              </div>
            </CardHeader>
          </Card>
        </motion.div>
      </div>
    );
  }

  const { patient, chronic_conditions, surgeries, lab_tests, medications, allergies, vaccinations } =
    profile;

  const sectionData = {
    chronic_conditions,
    surgeries,
    lab_tests,
    medications,
    allergies,
    vaccinations,
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-teal-50/40 to-slate-100 relative">
      <div className="fixed inset-0 pointer-events-none overflow-hidden">
        <div className="absolute -top-24 -end-24 w-96 h-96 rounded-full bg-[#0d797e]/10 blur-3xl" />
        <div className="absolute bottom-0 start-0 w-80 h-80 rounded-full bg-[#0d797e]/5 blur-3xl" />
      </div>

      <div className="fixed top-4 end-4 z-50">
        <LanguageToggle />
      </div>

      <div className="container mx-auto px-4 max-w-5xl py-6 md:py-10 relative z-10 space-y-6">
        {/* Hero */}
        <motion.header
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="rounded-2xl border border-[#0d797e]/15 bg-white/90 backdrop-blur-md shadow-xl overflow-hidden"
        >
          <div className="h-2 bg-gradient-to-r from-[#0d797e] via-teal-500 to-[#0d797e]" />
          <div className="p-6 md:p-8">
            <div className="flex flex-col lg:flex-row gap-6 lg:items-center">
              <div className="flex flex-col sm:flex-row items-start sm:items-center gap-5 flex-1 min-w-0">
                {patient.photo_url ? (
                  <img
                    src={patient.photo_url}
                    alt=""
                    className="h-20 w-20 md:h-24 md:w-24 rounded-2xl object-cover shadow-lg ring-4 ring-[#0d797e]/20"
                  />
                ) : (
                  <div className="h-20 w-20 md:h-24 md:w-24 rounded-2xl bg-gradient-to-br from-[#0d797e] to-teal-600 flex items-center justify-center shadow-lg ring-4 ring-[#0d797e]/20 shrink-0">
                    <span className="text-2xl md:text-3xl font-bold text-white">
                      {getInitials(patient.full_name)}
                    </span>
                  </div>
                )}
                <div className="min-w-0 flex-1">
                  <p className="text-xs font-semibold uppercase tracking-wider text-[#0d797e] mb-1">
                    {t('publicProfile.carelinkProfile')}
                  </p>
                  <h1 className="text-2xl md:text-3xl font-bold text-gray-900 truncate">
                    {patient.full_name || t('publicProfile.medicalProfile')}
                  </h1>
                  <div className="flex items-center gap-2 text-gray-600 mt-1">
                    <Stethoscope className="h-4 w-4 shrink-0" />
                    <span className="text-sm">{t('publicProfile.medicalProfile')}</span>
                  </div>
                  <div className="flex flex-wrap gap-2 mt-4">
                    {MEDICAL_SECTIONS.map(({ id, labelKey }) => (
                      <button
                        key={id}
                        type="button"
                        onClick={() => setActiveTab(id)}
                        className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium bg-[#0d797e]/10 text-[#0d797e] hover:bg-[#0d797e]/20 transition-colors"
                      >
                        {t(labelKey)}
                        <span className="bg-white/80 px-1.5 py-0.5 rounded-full min-w-[1.25rem] text-center">
                          {counts[id]}
                        </span>
                      </button>
                    ))}
                    <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-700">
                      {t('publicProfile.totalRecords')}: {totalRecords}
                    </span>
                  </div>
                </div>
              </div>

              {uuid && (
                <div className="flex flex-col items-center gap-2 shrink-0 w-full sm:w-auto">
                  <div className="bg-white p-3 rounded-xl shadow-md border border-[#0d797e]/15">
                    <div className="flex items-center justify-center gap-2 mb-2">
                      <QrCode className="h-4 w-4 text-[#0d797e]" />
                      <p className="text-xs font-semibold text-gray-700">{t('publicProfile.shareProfile')}</p>
                    </div>
                    <canvas
                      ref={canvasRefCallback}
                      className="rounded-lg"
                      width={180}
                      height={180}
                      style={{ maxWidth: 180, maxHeight: 180 }}
                    />
                  </div>
                  <button
                    type="button"
                    onClick={() => {
                      if (!qrCanvasRef.current) return;
                      const link = document.createElement('a');
                      link.download = 'carelink-qr-code.png';
                      link.href = qrCanvasRef.current.toDataURL('image/png');
                      link.click();
                    }}
                    className="inline-flex items-center gap-2 text-xs text-[#0d797e] hover:text-[#0a6268] font-medium bg-[#0d797e]/10 hover:bg-[#0d797e]/15 px-3 py-1.5 rounded-lg transition-colors"
                  >
                    <Download className="h-3 w-3" />
                    {t('publicProfile.downloadQR')}
                  </button>
                </div>
              )}
            </div>
          </div>
        </motion.header>

        {/* Tabs */}
        <nav
          className="flex gap-2 overflow-x-auto pb-1 scrollbar-thin"
          role="tablist"
          aria-label={t('publicProfile.medicalSections')}
        >
          {tabs.map(({ id, labelKey }) => {
            const Icon = TAB_ICONS[id] ?? FileText;
            const isActive = activeTab === id;
            const count = id === 'overview' ? totalRecords : counts[id] ?? 0;
            return (
              <button
                key={id}
                type="button"
                role="tab"
                aria-selected={isActive}
                onClick={() => setActiveTab(id)}
                className={`inline-flex items-center gap-2 px-4 py-2.5 rounded-full text-sm font-medium whitespace-nowrap shrink-0 transition-all ${
                  isActive
                    ? 'bg-[#0d797e] text-white shadow-md shadow-[#0d797e]/25'
                    : 'bg-white/80 text-gray-700 border border-gray-200/80 hover:border-[#0d797e]/30 hover:bg-white'
                }`}
              >
                <Icon className="h-4 w-4 shrink-0" />
                {t(labelKey)}
                <span
                  className={`text-xs px-1.5 py-0.5 rounded-full min-w-[1.25rem] text-center ${
                    isActive ? 'bg-white/20' : 'bg-gray-100'
                  }`}
                >
                  {count}
                </span>
              </button>
            );
          })}
        </nav>

        {/* Tab panels */}
        <AnimatePresence mode="wait">
          <motion.div
            key={activeTab}
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            transition={{ duration: 0.2 }}
            role="tabpanel"
          >
            {activeTab === 'overview' ? (
              <div className="space-y-6">
                <PatientInfoPanel patient={patient} locale={locale} t={t} />
                {MEDICAL_SECTIONS.map(({ id, labelKey }) => (
                  <MedicalSectionPanel
                    key={id}
                    sectionId={id}
                    items={sectionData[id]}
                    title={t(labelKey)}
                    locale={locale}
                    t={t}
                  />
                ))}
              </div>
            ) : (
              <MedicalSectionPanel
                sectionId={activeTab}
                items={sectionData[activeTab]}
                title={t(MEDICAL_SECTIONS.find((s) => s.id === activeTab)?.labelKey ?? activeTab)}
                locale={locale}
                t={t}
              />
            )}
          </motion.div>
        </AnimatePresence>

        <footer className="text-center text-xs text-gray-500 pb-4 pt-2">
          {t('publicProfile.poweredBy')}
        </footer>
      </div>
    </div>
  );
};

export default PublicPatientPage;
