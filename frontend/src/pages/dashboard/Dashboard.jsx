import React, { useState, useEffect } from 'react';
import { Outlet, NavLink, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { getPatientRecordId } from '../../lib/chronicConditionsCache';
import {
  getDashboardRouteSegment,
  prefetchDashboardRoute,
} from '../../lib/dashboardPrefetch';
import { useTranslation } from 'react-i18next';
import { Button } from '../../components/ui/button';
import LanguageToggle from '../../components/LanguageToggle';
import ThemeToggle from '../../components/ThemeToggle';
import Logo from '../../components/Logo';
import {
  User,
  Heart,
  Scissors,
  FileText,
  Pill,
  AlertTriangle,
  Syringe,
  QrCode,
  LogOut,
  Menu,
  X,
  BarChart3,
} from 'lucide-react';

const Dashboard = () => {
  const { user, patient, signOut, loading } = useAuth();
  const { t } = useTranslation();
  const navigate = useNavigate();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const patientId = getPatientRecordId(patient);

  useEffect(() => {
    if (!loading && !user) {
      navigate('/login', { replace: true });
    }
  }, [user, loading, navigate]);

  useEffect(() => {
    if (!patientId) return;
    const routeSegment = getDashboardRouteSegment(location.pathname);
    prefetchDashboardRoute(routeSegment, patientId);
  }, [patientId, location.pathname]);

  const handleSignOut = async () => {
    try {
      await signOut();
      navigate('/');
    } catch (error) {
      console.error('Sign out error:', error);
      navigate('/');
    }
  };

  const menuItems = [
    { id: 'statistics', path: 'statistics', label: t('dashboard.statistics'), icon: BarChart3 },
    { id: 'profile', path: 'profile', label: t('dashboard.profile'), icon: User },
    { id: 'qr', path: 'qr', label: t('dashboard.qrCode'), icon: QrCode },
    { id: 'chronic', path: 'chronic', label: t('dashboard.chronicConditions'), icon: Heart },
    { id: 'surgeries', path: 'surgeries', label: t('dashboard.surgeries'), icon: Scissors },
    { id: 'lab-tests', path: 'lab-tests', label: t('dashboard.labTests'), icon: FileText },
    { id: 'medications', path: 'medications', label: t('dashboard.medications'), icon: Pill },
    { id: 'allergies', path: 'allergies', label: t('dashboard.allergies'), icon: AlertTriangle },
    { id: 'vaccinations', path: 'vaccinations', label: t('dashboard.vaccinations'), icon: Syringe },
  ];

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      {/* Mobile Header */}
      <div className="lg:hidden bg-white dark:bg-gray-900 border-b dark:border-gray-800 p-4 flex justify-between items-center">
        <Logo className="h-10 w-10" showText textSize="text-xl" />
        <div className="flex gap-2">
          <ThemeToggle />
          <LanguageToggle />
        </div>
        <Button
          variant="ghost"
          size="icon"
          onClick={() => setSidebarOpen(!sidebarOpen)}
        >
          {sidebarOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
        </Button>
      </div>

      <div className="flex">
        {/* Sidebar */}
        <aside
          className={`fixed lg:static inset-y-0 left-0 z-30 w-64 bg-white dark:bg-gray-900 border-r dark:border-gray-800 transition-transform duration-200 ease-in-out ${
            sidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
          }`}
        >
          <div className="h-full flex flex-col">
            <div className="p-6 border-b dark:border-gray-800">
              <Logo className="h-14 w-14" showText textSize="text-2xl" />
              <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">{user?.email}</p>
            </div>

            <nav className="flex-1 p-4 space-y-1 overflow-y-auto">
              {menuItems.map((item) => {
                const Icon = item.icon;
                return (
                  <NavLink
                    key={item.id}
                    to={item.path}
                    onMouseEnter={() => prefetchDashboardRoute(item.path, patientId)}
                    onFocus={() => prefetchDashboardRoute(item.path, patientId)}
                    onClick={() => {
                      if (window.innerWidth < 1024) {
                        setSidebarOpen(false);
                      }
                    }}
                    className={({ isActive }) =>
                      `w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                        isActive
                          ? 'bg-primary !text-white shadow-md [&_svg]:!text-white'
                          : 'hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-700 dark:text-gray-300'
                      }`
                    }
                  >
                    <Icon className="h-5 w-5" />
                    <span>{item.label}</span>
                  </NavLink>
                );
              })}
            </nav>

            <div className="p-4 border-t dark:border-gray-800 space-y-2">
              <div className="flex gap-2">
                <ThemeToggle />
                <LanguageToggle />
              </div>
              <Button
                variant="outline"
                className="w-full"
                onClick={handleSignOut}
              >
                <LogOut className="h-4 w-4 mr-2" />
                {t('auth.logout')}
              </Button>
            </div>
          </div>
        </aside>

        {/* Overlay for mobile */}
        {sidebarOpen && (
          <div
            className="lg:hidden fixed inset-0 bg-black/50 z-20"
            onClick={() => setSidebarOpen(false)}
          />
        )}

        {/* Main Content */}
        <main className="flex-1 p-4 lg:p-8 bg-gray-50 dark:bg-gray-950">
          <div className="max-w-6xl mx-auto">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
};

export default Dashboard;
