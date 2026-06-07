import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import { LanguageProvider } from './context/LanguageContext';
import { ThemeProvider } from './context/ThemeContext';
import LandingPage from './pages/LandingPage';
import Login from './pages/Login';
import Signup from './pages/Signup';
import Dashboard from './pages/dashboard/Dashboard';
import ChronicConditionsSkeleton from './pages/dashboard/ChronicConditionsSkeleton';
import SurgeriesSkeleton from './pages/dashboard/SurgeriesSkeleton';
import StatisticsSkeleton from './pages/dashboard/StatisticsSkeleton';
import MedicationsSkeleton from './pages/dashboard/MedicationsSkeleton';
import LabTestsSkeleton from './pages/dashboard/LabTestsSkeleton';
import VaccinationsSkeleton from './pages/dashboard/VaccinationsSkeleton';
import DashboardPageFallback from './components/DashboardPageFallback';
import PublicPatientPage from './pages/PublicPatientPage';

const ProfileForm = lazy(() => import('./pages/dashboard/ProfileForm'));
const DashboardQR = lazy(() => import('./pages/dashboard/DashboardQR'));
const Allergies = lazy(() => import('./pages/dashboard/Allergies'));
const ChronicConditions = lazy(() => import('./pages/dashboard/ChronicConditions'));
const Surgeries = lazy(() => import('./pages/dashboard/Surgeries'));
const LabTests = lazy(() => import('./pages/dashboard/LabTests'));
const Medications = lazy(() => import('./pages/dashboard/Medications'));
const Statistics = lazy(() => import('./pages/dashboard/Statistics'));
const Vaccinations = lazy(() => import('./pages/dashboard/Vaccinations'));

const ProtectedRoute = ({ children }) => {
  const { user, loading } = useAuth();
  const location = useLocation();

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  return user ? children : <Navigate to="/login" state={{ from: location }} replace />;
};

const AppRoutes = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        >
          <Route index element={<Navigate to="profile" replace />} />
          <Route
            path="statistics"
            element={
              <Suspense fallback={<StatisticsSkeleton />}>
                <Statistics />
              </Suspense>
            }
          />
          <Route
            path="profile"
            element={
              <Suspense fallback={<DashboardPageFallback />}>
                <ProfileForm />
              </Suspense>
            }
          />
          <Route
            path="qr"
            element={
              <Suspense fallback={<DashboardPageFallback />}>
                <DashboardQR />
              </Suspense>
            }
          />
          <Route
            path="chronic"
            element={
              <Suspense fallback={<ChronicConditionsSkeleton />}>
                <ChronicConditions />
              </Suspense>
            }
          />
          <Route
            path="surgeries"
            element={
              <Suspense fallback={<SurgeriesSkeleton />}>
                <Surgeries />
              </Suspense>
            }
          />
          <Route
            path="lab-tests"
            element={
              <Suspense fallback={<LabTestsSkeleton />}>
                <LabTests />
              </Suspense>
            }
          />
          <Route
            path="medications"
            element={
              <Suspense fallback={<MedicationsSkeleton />}>
                <Medications />
              </Suspense>
            }
          />
          <Route
            path="allergies"
            element={
              <Suspense fallback={<DashboardPageFallback />}>
                <Allergies />
              </Suspense>
            }
          />
          <Route
            path="vaccinations"
            element={
              <Suspense fallback={<VaccinationsSkeleton />}>
                <Vaccinations />
              </Suspense>
            }
          />
        </Route>
        <Route path="/patient/:uuid" element={<PublicPatientPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
};

function App() {
  return (
    <ThemeProvider>
      <LanguageProvider>
        <AuthProvider>
          <AppRoutes />
        </AuthProvider>
      </LanguageProvider>
    </ThemeProvider>
  );
}

export default App;
