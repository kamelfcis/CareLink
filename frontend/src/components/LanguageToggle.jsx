import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import { Button } from './ui/button';
import { Languages } from 'lucide-react';

const LanguageToggle = () => {
  const { language, toggleLanguage } = useLanguage();

  return (
    <Button
      variant="outline"
      onClick={toggleLanguage}
      className="flex items-center gap-2"
      title={language === 'en' ? 'Switch to Arabic' : 'التبديل إلى الإنجليزية'}
    >
      <Languages className="h-4 w-4" />
      <span className="text-sm font-medium">{language === 'en' ? 'AR' : 'EN'}</span>
    </Button>
  );
};

export default LanguageToggle;

