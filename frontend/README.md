# CareLink Frontend

A comprehensive health platform frontend built with React, Vite, and Supabase. CareLink allows patients to manage their medical information and share it securely via QR codes.

## Features

- 🔐 **Authentication**: Secure signup and login using Supabase Auth
- 📋 **Patient Dashboard**: Complete medical profile management
- 📊 **Medical Data Management**:
  - Patient profile (personal info, emergency contacts)
  - Chronic conditions
  - Surgeries
  - Lab tests with file uploads
  - Medications
  - Allergies
  - Vaccinations
- 📱 **QR Code Generation**: Generate QR codes for easy sharing of medical profiles
- 🌐 **Public Profile Page**: View-only medical profile accessible via QR code
- 🎨 **Modern UI**: Built with TailwindCSS and shadcn UI components

## Tech Stack

- **React 18** - UI library
- **Vite** - Build tool and dev server
- **TailwindCSS** - Styling
- **shadcn UI** - Component library
- **React Router** - Routing
- **Supabase JS Client** - Backend integration (Auth, Database, Storage)
- **qrcode** - QR code generation

## Prerequisites

- Node.js 18+ and npm
- A Supabase project with the database schema set up

## Setup Instructions

### 1. Clone and Install

```bash
cd frontend
npm install
```

### 2. Configure Supabase

Create a `.env` file in the `frontend` directory:

```env
VITE_SUPABASE_URL=your-supabase-project-url
VITE_SUPABASE_ANON_KEY=your-supabase-anon-key
```

You can find these values in your Supabase project settings under API.

### 3. Set Up Database

1. Run the main SQL file (`supabase.sql`) in your Supabase SQL editor
2. Run the additional updates (`supabase-updates.sql`) to add RLS policies and update the public profile function

### 4. Configure Storage Buckets

The following storage buckets should be created in Supabase Storage:
- `lab-tests` (public)
- `patient-photos` (public)
- `medical-documents` (public)
- `carelink-files` (public)

These are created automatically by the SQL script, but verify they exist in your Supabase dashboard.

### 5. Run the Development Server

```bash
npm run dev
```

The app will be available at `http://localhost:3000`

## Project Structure

```
frontend/
├── src/
│   ├── components/
│   │   ├── ui/              # shadcn UI components
│   │   └── QRCodeViewer.jsx # QR code component
│   ├── context/
│   │   └── AuthContext.jsx  # Authentication context
│   ├── lib/
│   │   ├── supabase.js      # Supabase client
│   │   └── utils.js         # Utility functions
│   ├── pages/
│   │   ├── LandingPage.jsx  # Landing page
│   │   ├── Login.jsx        # Login page
│   │   ├── Signup.jsx       # Signup page
│   │   ├── PublicPatientPage.jsx # Public profile view
│   │   └── dashboard/
│   │       ├── Dashboard.jsx
│   │       ├── ProfileForm.jsx
│   │       ├── ChronicConditions.jsx
│   │       ├── Surgeries.jsx
│   │       ├── LabTests.jsx
│   │       ├── Medications.jsx
│   │       ├── Allergies.jsx
│   │       └── Vaccinations.jsx
│   ├── App.jsx              # Main app component
│   ├── main.jsx             # Entry point
│   └── index.css            # Global styles
├── package.json
├── vite.config.js
├── tailwind.config.js
└── README.md
```

## Key Features Explained

### Authentication

- Uses Supabase Auth for user management
- Automatically creates a patient record on signup
- Protected routes require authentication

### Dashboard

The dashboard provides a comprehensive interface for managing all medical data:
- **Profile**: Personal information and emergency contacts
- **QR Code**: Generate and download QR codes for sharing
- **Medical Sections**: CRUD operations for all medical data types

### Public Profile

The public profile page (`/patient/:uuid`) is accessible without authentication and displays:
- Patient information
- All medical records (conditions, surgeries, lab tests, medications, allergies, vaccinations)
- Emergency contact information

This page is designed to be accessed via QR code scanning by healthcare providers.

### File Uploads

Lab test files are uploaded to Supabase Storage in the `lab-tests` bucket. Files are organized by patient ID and are publicly accessible via the stored URL.

## Building for Production

```bash
npm run build
```

The production build will be in the `dist` directory.

## Environment Variables

Required environment variables:

- `VITE_SUPABASE_URL`: Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Your Supabase anonymous key

## Security Notes

- All database operations use Row Level Security (RLS) policies
- Users can only access their own data
- Public profiles are accessible via UUID only (no authentication required)
- File uploads are restricted to authenticated users

## Troubleshooting

### Authentication Issues

- Verify your Supabase URL and anon key in `.env`
- Check that email confirmation is disabled in Supabase Auth settings (for development)

### Database Errors

- Ensure all SQL scripts have been run
- Verify RLS policies are enabled
- Check that the `get_public_profile` function exists and is accessible to `anon` role

### File Upload Issues

- Verify storage buckets exist in Supabase
- Check bucket permissions (should be public for lab-tests)
- Ensure the bucket name matches exactly: `lab-tests`

## License

This project is part of the CareLink health platform.


