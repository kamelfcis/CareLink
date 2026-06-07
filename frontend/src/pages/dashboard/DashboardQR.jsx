import React from 'react';
import { useAuth } from '../../context/AuthContext';
import QRCodeViewer from '../../components/QRCodeViewer';

const DashboardQR = () => {
  const { patient } = useAuth();

  return (
    <QRCodeViewer
      publicProfileUuid={patient?.public_profile_uuid ?? patient?.id}
    />
  );
};

export default DashboardQR;
