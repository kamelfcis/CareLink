import React, { useEffect, useRef } from 'react';
import QRCode from 'qrcode';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './ui/card';
import { Download } from 'lucide-react';
import { Button } from './ui/button';

const QRCodeViewer = ({ publicProfileUuid }) => {
  const canvasRef = useRef(null);
  const [qrUrl, setQrUrl] = React.useState('');

  useEffect(() => {
    if (publicProfileUuid && canvasRef.current) {
      const url = `${window.location.origin}/patient/${publicProfileUuid}`;
      setQrUrl(url);

      QRCode.toCanvas(canvasRef.current, url, {
        width: 300,
        margin: 2,
        color: {
          dark: '#000000',
          light: '#FFFFFF',
        },
      }, (error) => {
        if (error) {
          console.error('Error generating QR code:', error);
        }
      });
    }
  }, [publicProfileUuid]);

  const handleDownload = async () => {
    if (canvasRef.current) {
      const url = canvasRef.current.toDataURL();
      const link = document.createElement('a');
      link.download = 'carelink-qr-code.png';
      link.href = url;
      link.click();
    }
  };

  if (!publicProfileUuid) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>QR Code</CardTitle>
          <CardDescription>Complete your profile to generate a QR code</CardDescription>
        </CardHeader>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Your QR Code</CardTitle>
        <CardDescription>
          Share this QR code with healthcare providers to access your medical profile
        </CardDescription>
      </CardHeader>
      <CardContent className="flex flex-col items-center gap-4">
        <canvas ref={canvasRef} className="border rounded-lg p-4 bg-white" />
        <p className="text-sm text-muted-foreground text-center max-w-xs break-all">
          {qrUrl}
        </p>
        <Button onClick={handleDownload} variant="outline" className="w-full">
          <Download className="h-4 w-4 mr-2" />
          Download QR Code
        </Button>
      </CardContent>
    </Card>
  );
};

export default QRCodeViewer;


