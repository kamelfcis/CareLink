import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';
import './i18n/config';
// Import connection test (runs automatically in dev mode)
import './lib/supabase-connection-test.js';
// Import patient query test (available in console)
import './lib/test-patient-query.js';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

