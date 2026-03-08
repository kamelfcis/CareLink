// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CareLink';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get notes => 'Notes';

  @override
  String get viewMore => 'View more...';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get added => 'Added:';

  @override
  String get selectDate => 'Select date';

  @override
  String get deleteConfirmation => 'Delete Confirmation';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone';

  @override
  String get adding => 'Adding...';

  @override
  String get loading => 'Loading...';

  @override
  String get notesMinLength => 'Notes should be at least 5 characters';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get orSignInWith => 'or sign in with';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinAsPatient => 'Join CareLink as a Patient';

  @override
  String get joinAsDoctor => 'Join CareLink as a Doctor';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get selectYourGender => 'Select Your Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get selectDateOfBirth => 'Select Date of Birth';

  @override
  String get specialization => 'Specialization';

  @override
  String get enterYourSpecialization => 'Enter your specialization';

  @override
  String get chooseYourRole => 'Choose Your Role';

  @override
  String get selectHowToUse => 'Select how you\'d like to use CareLink';

  @override
  String get imAPatient => 'I\'m a Patient';

  @override
  String get trackHealthRecords =>
      'Track health records and connect with doctors';

  @override
  String get imADoctor => 'I\'m a Doctor';

  @override
  String get managePatients => 'Manage patients and their records';

  @override
  String helloDr(String name) {
    return 'Hello, Dr. $name';
  }

  @override
  String helloUser(String name) {
    return 'Hello, $name';
  }

  @override
  String get managePatientsToday => 'Manage your patients today';

  @override
  String get manageYour => 'Manage Your';

  @override
  String get patients => 'Patients';

  @override
  String get searchPatients => 'Search patients...';

  @override
  String get noPatientsYet => 'No patients assigned yet';

  @override
  String get noPatientsDesc =>
      'Your patients will appear here once they connect with you.';

  @override
  String get account => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get app => 'App';

  @override
  String get language => 'Language';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get notifications => 'Notifications';

  @override
  String get theme => 'Theme';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get about => 'About';

  @override
  String get logOut => 'Log Out';

  @override
  String get general => 'General';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get careLinkAI => 'CareLink AI';

  @override
  String get online => 'Online';

  @override
  String get askMeAnything => 'Ask me anything about health...';

  @override
  String get typeYourMessage => 'Type your message...';

  @override
  String get analyzeAnImage => 'Analyze an image';

  @override
  String get sendAVoiceNote => 'Send a voice note';

  @override
  String get commonFluSymptoms => 'What are common symptoms of flu?';

  @override
  String get healthyDiet => 'How to maintain a healthy diet?';

  @override
  String speechRecognitionError(String error) {
    return 'Speech recognition error: $error';
  }

  @override
  String get speechNotAvailable =>
      'Speech recognition not available on this device.';

  @override
  String failedSpeechRecognition(String error) {
    return 'Failed to start speech recognition: $error';
  }

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get aiChat => 'AI Chat';

  @override
  String get sorryNoResponse => 'Sorry, I could not generate a response.';

  @override
  String get failedToAnalyzeImage =>
      'Failed to analyze image. Please try again.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Your Health, Our Priority';

  @override
  String get onboardingDesc1 =>
      'Track your health records and stay connected with your healthcare providers.';

  @override
  String get onboardingTitle2 => 'Connect with Doctors';

  @override
  String get onboardingDesc2 =>
      'Find and connect with qualified doctors for personalized care.';

  @override
  String get onboardingTitle3 => 'Track Your Records';

  @override
  String get onboardingDesc3 =>
      'Keep all your medical records organized and accessible anytime.';

  @override
  String get chronicConditions => 'Chronic Conditions';

  @override
  String get manageChronicConditions => 'Manage your chronic conditions';

  @override
  String get addCondition => 'Add Condition';

  @override
  String get conditionAddedSuccess => 'Condition added successfully';

  @override
  String get conditionDeletedSuccess => 'Condition deleted successfully';

  @override
  String get addNewCondition => 'Add New Condition';

  @override
  String get fillConditionDetails => 'Fill in the condition details below';

  @override
  String get conditionName => 'Condition Name *';

  @override
  String get pleaseEnterConditionName => 'Please enter a condition name';

  @override
  String get noConditionsYet => 'No conditions yet';

  @override
  String get addFirstCondition =>
      'Tap the + button below to add your first condition.';

  @override
  String get conditionOptions => 'Condition Options';

  @override
  String get deleteCondition => 'Delete Condition';

  @override
  String get editCondition => 'Edit Condition';

  @override
  String get confirmDeleteCondition =>
      'Are you sure you want to delete this condition? This action cannot be undone.';

  @override
  String get allergies => 'Allergies';

  @override
  String get manageAllergies => 'Manage your known allergies';

  @override
  String get addAllergy => 'Add Allergy';

  @override
  String get allergyAddedSuccess => 'Allergy added successfully';

  @override
  String get allergyDeletedSuccess => 'Allergy deleted successfully';

  @override
  String get addNewAllergy => 'Add New Allergy';

  @override
  String get fillAllergyDetails => 'Fill in the allergy details below';

  @override
  String get allergyName => 'Allergy Name *';

  @override
  String get pleaseEnterAllergyName => 'Please enter an allergy name';

  @override
  String get severity => 'Severity';

  @override
  String get selectSeverityOptional => 'Select severity (Optional)';

  @override
  String get mild => 'Mild';

  @override
  String get moderate => 'Moderate';

  @override
  String get severe => 'Severe';

  @override
  String get unknown => 'Unknown';

  @override
  String get noAllergiesYet => 'No allergies yet';

  @override
  String get addFirstAllergy =>
      'Tap the + button below to add your first allergy.';

  @override
  String get allergyOptions => 'Allergy Options';

  @override
  String get deleteAllergy => 'Delete Allergy';

  @override
  String get editAllergy => 'Edit Allergy';

  @override
  String get confirmDeleteAllergy =>
      'Are you sure you want to delete this allergy? This action cannot be undone.';

  @override
  String severityLabel(String severity) {
    return 'Severity: $severity';
  }

  @override
  String get medications => 'Medications';

  @override
  String get manageCurrentMedications => 'Manage your current medications';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get medicationAddedSuccess => 'Medication added successfully';

  @override
  String get medicationDeletedSuccess => 'Medication deleted successfully';

  @override
  String get addNewMedication => 'Add New Medication';

  @override
  String get fillMedicationDetails => 'Fill in the medication details below';

  @override
  String get medicationName => 'Medication Name *';

  @override
  String get pleaseEnterMedicationName => 'Please enter a medication name';

  @override
  String get dosage => 'Dosage (e.g., 1 tablet)';

  @override
  String get dosageLabel => 'Dosage';

  @override
  String get dosageMinLength => 'Dosage should be at least 2 characters';

  @override
  String get frequency => 'Frequency (e.g., daily)';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get frequencyMinLength => 'Frequency should be at least 2 characters';

  @override
  String get startDate => 'Start Date *';

  @override
  String get startDateLabel => 'Start Date';

  @override
  String get endDateOptional => 'End Date (Optional)';

  @override
  String get endDateLabel => 'End Date';

  @override
  String get noMedicationsYet => 'No medications yet';

  @override
  String get addFirstMedication =>
      'Tap the + button below to add your first medication.';

  @override
  String get medicationOptions => 'Medication Options';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get confirmDeleteMedication =>
      'Are you sure you want to delete this medication? This action cannot be undone.';

  @override
  String get startDateRequired => 'Start date is required';

  @override
  String get endDateAfterStart => 'End date must be after start date';

  @override
  String dosageValue(String value) {
    return 'Dosage: $value';
  }

  @override
  String frequencyValue(String value) {
    return 'Freq: $value';
  }

  @override
  String startValue(String date) {
    return 'Start: $date';
  }

  @override
  String endValue(String date) {
    return 'End: $date';
  }

  @override
  String get vaccinations => 'Vaccinations';

  @override
  String get trackVaccinationHistory => 'Track your vaccination history';

  @override
  String get addVaccination => 'Add Vaccination';

  @override
  String get vaccinationAddedSuccess => 'Vaccination added successfully';

  @override
  String get vaccinationDeletedSuccess => 'Vaccination deleted successfully';

  @override
  String get addNewVaccination => 'Add New Vaccination';

  @override
  String get fillVaccinationDetails => 'Fill in the vaccination details below';

  @override
  String get vaccineName => 'Vaccine Name *';

  @override
  String get pleaseEnterVaccineName => 'Please enter a vaccine name';

  @override
  String get doseNumberOptional => 'Dose Number (Optional)';

  @override
  String get enterDoseNumber => 'Enter dose number';

  @override
  String get doseNumberPositive => 'Dose number must be a positive integer';

  @override
  String get vaccinationDate => 'Vaccination Date *';

  @override
  String get vaccinationDateRequired => 'Vaccination date is required';

  @override
  String get noVaccinationsYet => 'No vaccinations yet';

  @override
  String get addFirstVaccination =>
      'Tap the + button below to add your first vaccination.';

  @override
  String get vaccinationOptions => 'Vaccination Options';

  @override
  String get deleteVaccination => 'Delete Vaccination';

  @override
  String get editVaccination => 'Edit Vaccination';

  @override
  String get confirmDeleteVaccination =>
      'Are you sure you want to delete this vaccination? This action cannot be undone.';

  @override
  String doseLabel(int number) {
    return 'Dose $number';
  }

  @override
  String get dateLabel => 'Date';

  @override
  String get surgeries => 'Surgeries';

  @override
  String get trackSurgicalHistory => 'Track your surgical history';

  @override
  String get addSurgery => 'Add Surgery';

  @override
  String get surgeryAddedSuccess => 'Surgery added successfully';

  @override
  String get surgeryDeletedSuccess => 'Surgery deleted successfully';

  @override
  String get addNewSurgery => 'Add New Surgery';

  @override
  String get fillSurgeryDetails => 'Fill in the surgery details below';

  @override
  String get operationName => 'Operation Name *';

  @override
  String get pleaseEnterOperationName => 'Please enter an operation name';

  @override
  String get operationDateOptional => 'Operation Date (Optional)';

  @override
  String get operationDate => 'Operation Date';

  @override
  String get noSurgeriesYet => 'No surgeries yet';

  @override
  String get addFirstSurgery =>
      'Tap the + button below to add your first surgery.';

  @override
  String get surgeryOptions => 'Surgery Options';

  @override
  String get deleteSurgery => 'Delete Surgery';

  @override
  String get editSurgery => 'Edit Surgery';

  @override
  String get confirmDeleteSurgery =>
      'Are you sure you want to delete this surgery? This action cannot be undone.';

  @override
  String get labTests => 'Lab Tests';

  @override
  String get trackLabTestResults => 'Track your lab test results';

  @override
  String get addLabTest => 'Add Lab Test';

  @override
  String get labTestAddedSuccess => 'Lab test added successfully';

  @override
  String get labTestDeletedSuccess => 'Lab test deleted successfully';

  @override
  String get addNewLabTest => 'Add New Lab Test';

  @override
  String get fillLabTestDetails => 'Fill in the lab test details below';

  @override
  String get testName => 'Test Name *';

  @override
  String get pleaseEnterTestName => 'Please enter a test name';

  @override
  String get testNumberOptional => 'Test Number (Optional)';

  @override
  String get testNumberMinLength =>
      'Test number should be at least 2 characters';

  @override
  String get testDateOptional => 'Test Date (Optional)';

  @override
  String get testResultImage => 'Test Result Image (Optional)';

  @override
  String get tapToSelectImage => 'Tap to select image';

  @override
  String get removeImage => 'Remove Image';

  @override
  String get noLabTestsYet => 'No lab tests yet';

  @override
  String get addFirstLabTest =>
      'Tap the + button below to add your first lab test.';

  @override
  String get labTestOptions => 'Lab Test Options';

  @override
  String get deleteLabTest => 'Delete Lab Test';

  @override
  String get editLabTest => 'Edit Lab Test';

  @override
  String get confirmDeleteLabTest =>
      'Are you sure you want to delete this lab test? This action cannot be undone.';

  @override
  String get testNumber => 'Test Number';

  @override
  String get testDate => 'Test Date';

  @override
  String get resultImage => 'Result Image:';

  @override
  String get unnamedTest => 'Unnamed Test';

  @override
  String testNumberValue(String number) {
    return 'Test #: $number';
  }

  @override
  String testDateValue(String date) {
    return 'Test Date: $date';
  }

  @override
  String get failedToUploadImage => 'Failed to upload image';

  @override
  String get gender => 'Gender';

  @override
  String get bloodType => 'Blood Type';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get name => 'Name';

  @override
  String get relationship => 'Relationship';

  @override
  String get phone => 'Phone';

  @override
  String get medicalRecords => 'Medical Records';

  @override
  String get chronicDiseases => 'Chronic Diseases';

  @override
  String get mobile => 'Mobile';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get qrCode => 'QR Code';

  @override
  String get connect => 'Connect';

  @override
  String weightKg(String weight) {
    return '$weight kg';
  }

  @override
  String heightCm(String height) {
    return '$height cm';
  }

  @override
  String get yourHealthDashboard => 'Your Health Dashboard';

  @override
  String get searchDoctors => 'Search doctors...';

  @override
  String get topDoctors => 'Top Doctors';

  @override
  String get seeAll => 'See All';

  @override
  String get myProfile => 'My Profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String addedDate(String date) {
    return 'Added: $date';
  }

  @override
  String get myDoctors => 'My Doctors';

  @override
  String get doctorsConnectedWith => 'Doctors you connected with';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get support => 'Support';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get loggedOutSuccess => 'Logged out successfully';

  @override
  String errorLoggingOut(String error) {
    return 'Error logging out: $error';
  }

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterFullName => 'Please enter your full name';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get age => 'Age';

  @override
  String yearsOld(String age) {
    return '$age years old';
  }

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get noData => 'N/A';

  @override
  String get fillDetailsToGetStarted => 'Fill your details to get started';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get signedInSuccess => 'Signed in successfully';

  @override
  String get warning => 'Warning';

  @override
  String get pleaseSelectWeight => 'Please select your weight to continue.';

  @override
  String get pleaseSelectHeight => 'Please select your height to continue.';

  @override
  String get pleaseSelectDateOfBirth =>
      'Please select your date of birth to continue.';

  @override
  String get pleaseSelectGender => 'Please select your gender to continue.';

  @override
  String get pleaseSelectBloodType =>
      'Please select your blood type to continue.';

  @override
  String get pleaseSelectImage => 'Please select an image to continue.';

  @override
  String get userName => 'User Name';

  @override
  String get enterYourUserName => 'enter your user name';

  @override
  String get email => 'Email';

  @override
  String get enterBloodType => 'enter your blood type';

  @override
  String get enterHeightCm => 'enter your height in cm';

  @override
  String get enterWeightKg => 'enter your weight in kg';

  @override
  String get contactName => 'Contact Name';

  @override
  String get enterContactName => 'enter contact name';

  @override
  String get contactRelationship => 'Contact Relationship';

  @override
  String get enterContactRelationship => 'enter contact relationship';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get enterContactNumber => 'enter contact number';

  @override
  String get setYourBirthday => 'Set your Birthday';

  @override
  String get selectYourDateOfBirth => 'select your date of birth';

  @override
  String get asAPatient => 'As a Patient';

  @override
  String get findDesiredDoctor => 'Find your desired doctor';

  @override
  String get asADoctor => 'As a Doctor';

  @override
  String get joinAsHealthcareProvider => 'Join as a healthcare provider';

  @override
  String get continueBtn => 'Continue';

  @override
  String get bio => 'Bio';

  @override
  String get enterYourBio => 'enter your bio';

  @override
  String get hospitalName => 'Hospital Name';

  @override
  String get enterHospitalName => 'enter your hospital name';

  @override
  String get bookDoctorToday => 'Book your doctor today';

  @override
  String get findYourDesired => 'Find Your Desired';

  @override
  String get doctorsNearYou => 'Doctors near you';

  @override
  String get searchForDoctor => 'Search for a doctor';

  @override
  String get searchForPatient => 'Search for a patient';

  @override
  String get connectedWithDoctorSuccess => 'Connected with doctor successfully';

  @override
  String get specialty => 'Specialty';

  @override
  String get aboutDoctor => 'About Doctor';

  @override
  String get call => 'Call';

  @override
  String get helloCareLink => 'Hello! I\'m CareLink AI';

  @override
  String get personalAssistantDesc =>
      'Your personal medical assistant.\nAsk me anything about health & wellness!';

  @override
  String get explainMedications => '💊 Explain my medications';

  @override
  String get commonColdSymptoms => '🩺 Common cold symptoms';

  @override
  String get understandLabResults => '🧪 Understand lab results';

  @override
  String get heartHealthTips => '🫀 Heart health tips';

  @override
  String get uploadLabTestImage => '📷 Upload lab test image';

  @override
  String get useVoiceToAsk => '🎤 Use voice to ask';

  @override
  String get uploadMedicalImage => 'Upload Medical Image';

  @override
  String get medicalImageTypes => 'Lab tests, MRI scans, X-rays, prescriptions';

  @override
  String get addMessageOptional => 'Add a message (optional)...';

  @override
  String get askAboutHealth => 'Ask about health & wellness...';

  @override
  String get imageAttached => 'Image attached';

  @override
  String get readyToAnalyze => 'Ready to analyze';

  @override
  String voiceError(String error) {
    return 'Voice error: $error';
  }

  @override
  String get speechNotAvailablePermission =>
      'Speech recognition not available. Please check microphone permissions.';

  @override
  String get voiceInputFailed =>
      'Could not start voice input. Please restart the app and try again.';

  @override
  String get onboardingNewTitle1 => 'All Your Medical Data in One Place';

  @override
  String get onboardingNewDesc1 =>
      'Keep your health info organized — medications, allergies, surgeries, chronic conditions, and lab results, all safely stored.';

  @override
  String get onboardingNewTitle2 => 'Share Your Medical Info Instantly';

  @override
  String get onboardingNewDesc2 =>
      'Your personal QR Code lets doctors and visitors access your essential health details quickly and securely.';

  @override
  String get onboardingNewTitle3 => 'Ask Anything. Get Instant Answers.';

  @override
  String get onboardingNewDesc3 =>
      'Get clear explanations about medications, lab tests, symptoms, or chronic conditions from your AI assistant anytime.';

  @override
  String get onboardingNewTitle4 => 'Your Data. Fully Protected.';

  @override
  String get onboardingNewDesc4 =>
      'Your medical information is securely stored and only you can access and control it.';

  @override
  String get manageYourOngoingHealthConditions =>
      'Manage your ongoing health conditions';

  @override
  String get filterBySpecialty => 'Filter by Specialty';

  @override
  String get allSpecialties => 'All Specialties';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get apply => 'Apply';

  @override
  String get noResultsFound => 'No doctors found';

  @override
  String get tryDifferentSearch => 'Try a different search or filter';

  @override
  String nDoctorsFound(int count) {
    return '$count doctors found';
  }

  @override
  String get noConnectedDoctors => 'No connected doctors';

  @override
  String get noConnectedDoctorsDesc =>
      'Connect with doctors from the home page and they will appear here.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Password reset link sent! Check your email.';

  @override
  String get resetLinkSentDesc =>
      'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions.';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordDesc => 'Reset your account password';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get checkYourEmail => 'Check Your Email';

  @override
  String get sending => 'Sending...';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyLastUpdated => 'Last updated: February 2026';

  @override
  String get privacyPolicyIntro =>
      'CareLink (\"we\", \"our\", or \"us\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.';

  @override
  String get privacyInfoCollectTitle => 'Information We Collect';

  @override
  String get privacyInfoCollectDesc =>
      'We collect personal information that you voluntarily provide to us when you register for the app, including your name, email address, phone number, date of birth, blood type, weight, height, and medical information such as chronic conditions, surgeries, vaccinations, and medications.';

  @override
  String get privacyHowWeUseTitle => 'How We Use Your Information';

  @override
  String get privacyHowWeUseDesc =>
      'We use the information we collect to provide and maintain the CareLink service, connect you with healthcare professionals, manage your health records, send you appointment reminders and health updates, and improve our application.';

  @override
  String get privacyDataSecurityTitle => 'Data Security';

  @override
  String get privacyDataSecurityDesc =>
      'We implement appropriate technical and organizational security measures to protect your personal and medical information. Your data is encrypted in transit and at rest using industry-standard protocols.';

  @override
  String get privacySharingTitle => 'Information Sharing';

  @override
  String get privacySharingDesc =>
      'We do not sell, trade, or rent your personal information to third parties. Your medical data is only shared with healthcare providers you explicitly connect with through the application.';

  @override
  String get privacyRightsTitle => 'Your Rights';

  @override
  String get privacyRightsDesc =>
      'You have the right to access, update, or delete your personal information at any time through the app settings. You may also request a complete copy of your data or ask us to erase all your information.';

  @override
  String get privacyContactTitle => 'Contact Us';

  @override
  String get privacyContactDesc =>
      'If you have questions about this Privacy Policy, please contact us through the app\'s support section.';

  @override
  String get aboutTitle => 'About CareLink';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDesc =>
      'CareLink is a comprehensive healthcare management platform that connects patients with doctors, manages medical records, and provides AI-powered health assistance.';

  @override
  String get aboutMission => 'Our Mission';

  @override
  String get aboutMissionDesc =>
      'To make healthcare accessible, organized, and seamless for everyone. We believe that technology can bridge the gap between patients and healthcare providers.';

  @override
  String get aboutFeatures => 'Key Features';

  @override
  String get aboutFeature1 => 'Connect with qualified doctors';

  @override
  String get aboutFeature2 => 'Manage your complete medical history';

  @override
  String get aboutFeature3 => 'AI-powered health chatbot';

  @override
  String get aboutFeature4 => 'Track chronic conditions & medications';

  @override
  String get aboutFeature5 => 'Secure and private health data';

  @override
  String get aboutTeam => 'Development Team';

  @override
  String get aboutTeamDesc => 'Built with ❤️ as a Graduation Project 2025';

  @override
  String get aboutPoweredBy => 'Powered by Flutter & Supabase';

  @override
  String get rateUsTitle => 'Enjoying CareLink?';

  @override
  String get rateUsDesc =>
      'Your feedback helps us improve! Please rate your experience with our app.';

  @override
  String get rateUsSubmit => 'Submit Rating';

  @override
  String get rateUsThankYou => 'Thank you for your feedback!';

  @override
  String get rateUsThankYouDesc =>
      'We appreciate your rating. Your feedback helps us make CareLink better for everyone.';

  @override
  String get rateUsTapStar => 'Tap a star to rate';

  @override
  String get contactUsDesc =>
      'Need help? Chat with our AI assistant for instant support.';

  @override
  String get openChatbot => 'Open AI Assistant';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get analyzeThisImage => 'Analyze this image';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get arabicShort => 'عربي';

  @override
  String get englishShort => 'EN';

  @override
  String get onboardingStepsCount => '4';
}
