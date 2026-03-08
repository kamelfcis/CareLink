import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CareLink'**
  String get appName;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View more...'**
  String get viewMore;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added:'**
  String get added;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get actionCannotBeUndone;

  /// No description provided for @adding.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get adding;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @notesMinLength.
  ///
  /// In en, this message translates to:
  /// **'Notes should be at least 5 characters'**
  String get notesMinLength;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'or sign in with'**
  String get orSignInWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinAsPatient.
  ///
  /// In en, this message translates to:
  /// **'Join CareLink as a Patient'**
  String get joinAsPatient;

  /// No description provided for @joinAsDoctor.
  ///
  /// In en, this message translates to:
  /// **'Join CareLink as a Doctor'**
  String get joinAsDoctor;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @selectYourGender.
  ///
  /// In en, this message translates to:
  /// **'Select Your Gender'**
  String get selectYourGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select Date of Birth'**
  String get selectDateOfBirth;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @enterYourSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Enter your specialization'**
  String get enterYourSpecialization;

  /// No description provided for @chooseYourRole.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Role'**
  String get chooseYourRole;

  /// No description provided for @selectHowToUse.
  ///
  /// In en, this message translates to:
  /// **'Select how you\'d like to use CareLink'**
  String get selectHowToUse;

  /// No description provided for @imAPatient.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Patient'**
  String get imAPatient;

  /// No description provided for @trackHealthRecords.
  ///
  /// In en, this message translates to:
  /// **'Track health records and connect with doctors'**
  String get trackHealthRecords;

  /// No description provided for @imADoctor.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Doctor'**
  String get imADoctor;

  /// No description provided for @managePatients.
  ///
  /// In en, this message translates to:
  /// **'Manage patients and their records'**
  String get managePatients;

  /// No description provided for @helloDr.
  ///
  /// In en, this message translates to:
  /// **'Hello, Dr. {name}'**
  String helloDr(String name);

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(String name);

  /// No description provided for @managePatientsToday.
  ///
  /// In en, this message translates to:
  /// **'Manage your patients today'**
  String get managePatientsToday;

  /// No description provided for @manageYour.
  ///
  /// In en, this message translates to:
  /// **'Manage Your'**
  String get manageYour;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @searchPatients.
  ///
  /// In en, this message translates to:
  /// **'Search patients...'**
  String get searchPatients;

  /// No description provided for @noPatientsYet.
  ///
  /// In en, this message translates to:
  /// **'No patients assigned yet'**
  String get noPatientsYet;

  /// No description provided for @noPatientsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your patients will appear here once they connect with you.'**
  String get noPatientsDesc;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @careLinkAI.
  ///
  /// In en, this message translates to:
  /// **'CareLink AI'**
  String get careLinkAI;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @askMeAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about health...'**
  String get askMeAnything;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @analyzeAnImage.
  ///
  /// In en, this message translates to:
  /// **'Analyze an image'**
  String get analyzeAnImage;

  /// No description provided for @sendAVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Send a voice note'**
  String get sendAVoiceNote;

  /// No description provided for @commonFluSymptoms.
  ///
  /// In en, this message translates to:
  /// **'What are common symptoms of flu?'**
  String get commonFluSymptoms;

  /// No description provided for @healthyDiet.
  ///
  /// In en, this message translates to:
  /// **'How to maintain a healthy diet?'**
  String get healthyDiet;

  /// No description provided for @speechRecognitionError.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition error: {error}'**
  String speechRecognitionError(String error);

  /// No description provided for @speechNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition not available on this device.'**
  String get speechNotAvailable;

  /// No description provided for @failedSpeechRecognition.
  ///
  /// In en, this message translates to:
  /// **'Failed to start speech recognition: {error}'**
  String failedSpeechRecognition(String error);

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @sorryNoResponse.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I could not generate a response.'**
  String get sorryNoResponse;

  /// No description provided for @failedToAnalyzeImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to analyze image. Please try again.'**
  String get failedToAnalyzeImage;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Your Health, Our Priority'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Track your health records and stay connected with your healthcare providers.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Connect with Doctors'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Find and connect with qualified doctors for personalized care.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track Your Records'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Keep all your medical records organized and accessible anytime.'**
  String get onboardingDesc3;

  /// No description provided for @chronicConditions.
  ///
  /// In en, this message translates to:
  /// **'Chronic Conditions'**
  String get chronicConditions;

  /// No description provided for @manageChronicConditions.
  ///
  /// In en, this message translates to:
  /// **'Manage your chronic conditions'**
  String get manageChronicConditions;

  /// No description provided for @addCondition.
  ///
  /// In en, this message translates to:
  /// **'Add Condition'**
  String get addCondition;

  /// No description provided for @conditionAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Condition added successfully'**
  String get conditionAddedSuccess;

  /// No description provided for @conditionDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Condition deleted successfully'**
  String get conditionDeletedSuccess;

  /// No description provided for @addNewCondition.
  ///
  /// In en, this message translates to:
  /// **'Add New Condition'**
  String get addNewCondition;

  /// No description provided for @fillConditionDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the condition details below'**
  String get fillConditionDetails;

  /// No description provided for @conditionName.
  ///
  /// In en, this message translates to:
  /// **'Condition Name *'**
  String get conditionName;

  /// No description provided for @pleaseEnterConditionName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a condition name'**
  String get pleaseEnterConditionName;

  /// No description provided for @noConditionsYet.
  ///
  /// In en, this message translates to:
  /// **'No conditions yet'**
  String get noConditionsYet;

  /// No description provided for @addFirstCondition.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first condition.'**
  String get addFirstCondition;

  /// No description provided for @conditionOptions.
  ///
  /// In en, this message translates to:
  /// **'Condition Options'**
  String get conditionOptions;

  /// No description provided for @deleteCondition.
  ///
  /// In en, this message translates to:
  /// **'Delete Condition'**
  String get deleteCondition;

  /// No description provided for @editCondition.
  ///
  /// In en, this message translates to:
  /// **'Edit Condition'**
  String get editCondition;

  /// No description provided for @confirmDeleteCondition.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this condition? This action cannot be undone.'**
  String get confirmDeleteCondition;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @manageAllergies.
  ///
  /// In en, this message translates to:
  /// **'Manage your known allergies'**
  String get manageAllergies;

  /// No description provided for @addAllergy.
  ///
  /// In en, this message translates to:
  /// **'Add Allergy'**
  String get addAllergy;

  /// No description provided for @allergyAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Allergy added successfully'**
  String get allergyAddedSuccess;

  /// No description provided for @allergyDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Allergy deleted successfully'**
  String get allergyDeletedSuccess;

  /// No description provided for @addNewAllergy.
  ///
  /// In en, this message translates to:
  /// **'Add New Allergy'**
  String get addNewAllergy;

  /// No description provided for @fillAllergyDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the allergy details below'**
  String get fillAllergyDetails;

  /// No description provided for @allergyName.
  ///
  /// In en, this message translates to:
  /// **'Allergy Name *'**
  String get allergyName;

  /// No description provided for @pleaseEnterAllergyName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an allergy name'**
  String get pleaseEnterAllergyName;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @selectSeverityOptional.
  ///
  /// In en, this message translates to:
  /// **'Select severity (Optional)'**
  String get selectSeverityOptional;

  /// No description provided for @mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mild;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @severe.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severe;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @noAllergiesYet.
  ///
  /// In en, this message translates to:
  /// **'No allergies yet'**
  String get noAllergiesYet;

  /// No description provided for @addFirstAllergy.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first allergy.'**
  String get addFirstAllergy;

  /// No description provided for @allergyOptions.
  ///
  /// In en, this message translates to:
  /// **'Allergy Options'**
  String get allergyOptions;

  /// No description provided for @deleteAllergy.
  ///
  /// In en, this message translates to:
  /// **'Delete Allergy'**
  String get deleteAllergy;

  /// No description provided for @editAllergy.
  ///
  /// In en, this message translates to:
  /// **'Edit Allergy'**
  String get editAllergy;

  /// No description provided for @confirmDeleteAllergy.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this allergy? This action cannot be undone.'**
  String get confirmDeleteAllergy;

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity: {severity}'**
  String severityLabel(String severity);

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @manageCurrentMedications.
  ///
  /// In en, this message translates to:
  /// **'Manage your current medications'**
  String get manageCurrentMedications;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// No description provided for @medicationAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Medication added successfully'**
  String get medicationAddedSuccess;

  /// No description provided for @medicationDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Medication deleted successfully'**
  String get medicationDeletedSuccess;

  /// No description provided for @addNewMedication.
  ///
  /// In en, this message translates to:
  /// **'Add New Medication'**
  String get addNewMedication;

  /// No description provided for @fillMedicationDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the medication details below'**
  String get fillMedicationDetails;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name *'**
  String get medicationName;

  /// No description provided for @pleaseEnterMedicationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a medication name'**
  String get pleaseEnterMedicationName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage (e.g., 1 tablet)'**
  String get dosage;

  /// No description provided for @dosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosageLabel;

  /// No description provided for @dosageMinLength.
  ///
  /// In en, this message translates to:
  /// **'Dosage should be at least 2 characters'**
  String get dosageMinLength;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency (e.g., daily)'**
  String get frequency;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequencyLabel;

  /// No description provided for @frequencyMinLength.
  ///
  /// In en, this message translates to:
  /// **'Frequency should be at least 2 characters'**
  String get frequencyMinLength;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date *'**
  String get startDate;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateLabel;

  /// No description provided for @endDateOptional.
  ///
  /// In en, this message translates to:
  /// **'End Date (Optional)'**
  String get endDateOptional;

  /// No description provided for @endDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDateLabel;

  /// No description provided for @noMedicationsYet.
  ///
  /// In en, this message translates to:
  /// **'No medications yet'**
  String get noMedicationsYet;

  /// No description provided for @addFirstMedication.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first medication.'**
  String get addFirstMedication;

  /// No description provided for @medicationOptions.
  ///
  /// In en, this message translates to:
  /// **'Medication Options'**
  String get medicationOptions;

  /// No description provided for @deleteMedication.
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get deleteMedication;

  /// No description provided for @editMedication.
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get editMedication;

  /// No description provided for @confirmDeleteMedication.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medication? This action cannot be undone.'**
  String get confirmDeleteMedication;

  /// No description provided for @startDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Start date is required'**
  String get startDateRequired;

  /// No description provided for @endDateAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date'**
  String get endDateAfterStart;

  /// No description provided for @dosageValue.
  ///
  /// In en, this message translates to:
  /// **'Dosage: {value}'**
  String dosageValue(String value);

  /// No description provided for @frequencyValue.
  ///
  /// In en, this message translates to:
  /// **'Freq: {value}'**
  String frequencyValue(String value);

  /// No description provided for @startValue.
  ///
  /// In en, this message translates to:
  /// **'Start: {date}'**
  String startValue(String date);

  /// No description provided for @endValue.
  ///
  /// In en, this message translates to:
  /// **'End: {date}'**
  String endValue(String date);

  /// No description provided for @vaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinations;

  /// No description provided for @trackVaccinationHistory.
  ///
  /// In en, this message translates to:
  /// **'Track your vaccination history'**
  String get trackVaccinationHistory;

  /// No description provided for @addVaccination.
  ///
  /// In en, this message translates to:
  /// **'Add Vaccination'**
  String get addVaccination;

  /// No description provided for @vaccinationAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vaccination added successfully'**
  String get vaccinationAddedSuccess;

  /// No description provided for @vaccinationDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vaccination deleted successfully'**
  String get vaccinationDeletedSuccess;

  /// No description provided for @addNewVaccination.
  ///
  /// In en, this message translates to:
  /// **'Add New Vaccination'**
  String get addNewVaccination;

  /// No description provided for @fillVaccinationDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the vaccination details below'**
  String get fillVaccinationDetails;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Name *'**
  String get vaccineName;

  /// No description provided for @pleaseEnterVaccineName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a vaccine name'**
  String get pleaseEnterVaccineName;

  /// No description provided for @doseNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Dose Number (Optional)'**
  String get doseNumberOptional;

  /// No description provided for @enterDoseNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter dose number'**
  String get enterDoseNumber;

  /// No description provided for @doseNumberPositive.
  ///
  /// In en, this message translates to:
  /// **'Dose number must be a positive integer'**
  String get doseNumberPositive;

  /// No description provided for @vaccinationDate.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Date *'**
  String get vaccinationDate;

  /// No description provided for @vaccinationDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Vaccination date is required'**
  String get vaccinationDateRequired;

  /// No description provided for @noVaccinationsYet.
  ///
  /// In en, this message translates to:
  /// **'No vaccinations yet'**
  String get noVaccinationsYet;

  /// No description provided for @addFirstVaccination.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first vaccination.'**
  String get addFirstVaccination;

  /// No description provided for @vaccinationOptions.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Options'**
  String get vaccinationOptions;

  /// No description provided for @deleteVaccination.
  ///
  /// In en, this message translates to:
  /// **'Delete Vaccination'**
  String get deleteVaccination;

  /// No description provided for @editVaccination.
  ///
  /// In en, this message translates to:
  /// **'Edit Vaccination'**
  String get editVaccination;

  /// No description provided for @confirmDeleteVaccination.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vaccination? This action cannot be undone.'**
  String get confirmDeleteVaccination;

  /// No description provided for @doseLabel.
  ///
  /// In en, this message translates to:
  /// **'Dose {number}'**
  String doseLabel(int number);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @surgeries.
  ///
  /// In en, this message translates to:
  /// **'Surgeries'**
  String get surgeries;

  /// No description provided for @trackSurgicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Track your surgical history'**
  String get trackSurgicalHistory;

  /// No description provided for @addSurgery.
  ///
  /// In en, this message translates to:
  /// **'Add Surgery'**
  String get addSurgery;

  /// No description provided for @surgeryAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Surgery added successfully'**
  String get surgeryAddedSuccess;

  /// No description provided for @surgeryDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Surgery deleted successfully'**
  String get surgeryDeletedSuccess;

  /// No description provided for @addNewSurgery.
  ///
  /// In en, this message translates to:
  /// **'Add New Surgery'**
  String get addNewSurgery;

  /// No description provided for @fillSurgeryDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the surgery details below'**
  String get fillSurgeryDetails;

  /// No description provided for @operationName.
  ///
  /// In en, this message translates to:
  /// **'Operation Name *'**
  String get operationName;

  /// No description provided for @pleaseEnterOperationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an operation name'**
  String get pleaseEnterOperationName;

  /// No description provided for @operationDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Operation Date (Optional)'**
  String get operationDateOptional;

  /// No description provided for @operationDate.
  ///
  /// In en, this message translates to:
  /// **'Operation Date'**
  String get operationDate;

  /// No description provided for @noSurgeriesYet.
  ///
  /// In en, this message translates to:
  /// **'No surgeries yet'**
  String get noSurgeriesYet;

  /// No description provided for @addFirstSurgery.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first surgery.'**
  String get addFirstSurgery;

  /// No description provided for @surgeryOptions.
  ///
  /// In en, this message translates to:
  /// **'Surgery Options'**
  String get surgeryOptions;

  /// No description provided for @deleteSurgery.
  ///
  /// In en, this message translates to:
  /// **'Delete Surgery'**
  String get deleteSurgery;

  /// No description provided for @editSurgery.
  ///
  /// In en, this message translates to:
  /// **'Edit Surgery'**
  String get editSurgery;

  /// No description provided for @confirmDeleteSurgery.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this surgery? This action cannot be undone.'**
  String get confirmDeleteSurgery;

  /// No description provided for @labTests.
  ///
  /// In en, this message translates to:
  /// **'Lab Tests'**
  String get labTests;

  /// No description provided for @trackLabTestResults.
  ///
  /// In en, this message translates to:
  /// **'Track your lab test results'**
  String get trackLabTestResults;

  /// No description provided for @addLabTest.
  ///
  /// In en, this message translates to:
  /// **'Add Lab Test'**
  String get addLabTest;

  /// No description provided for @labTestAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Lab test added successfully'**
  String get labTestAddedSuccess;

  /// No description provided for @labTestDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Lab test deleted successfully'**
  String get labTestDeletedSuccess;

  /// No description provided for @addNewLabTest.
  ///
  /// In en, this message translates to:
  /// **'Add New Lab Test'**
  String get addNewLabTest;

  /// No description provided for @fillLabTestDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the lab test details below'**
  String get fillLabTestDetails;

  /// No description provided for @testName.
  ///
  /// In en, this message translates to:
  /// **'Test Name *'**
  String get testName;

  /// No description provided for @pleaseEnterTestName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a test name'**
  String get pleaseEnterTestName;

  /// No description provided for @testNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Test Number (Optional)'**
  String get testNumberOptional;

  /// No description provided for @testNumberMinLength.
  ///
  /// In en, this message translates to:
  /// **'Test number should be at least 2 characters'**
  String get testNumberMinLength;

  /// No description provided for @testDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Test Date (Optional)'**
  String get testDateOptional;

  /// No description provided for @testResultImage.
  ///
  /// In en, this message translates to:
  /// **'Test Result Image (Optional)'**
  String get testResultImage;

  /// No description provided for @tapToSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select image'**
  String get tapToSelectImage;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @noLabTestsYet.
  ///
  /// In en, this message translates to:
  /// **'No lab tests yet'**
  String get noLabTestsYet;

  /// No description provided for @addFirstLabTest.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first lab test.'**
  String get addFirstLabTest;

  /// No description provided for @labTestOptions.
  ///
  /// In en, this message translates to:
  /// **'Lab Test Options'**
  String get labTestOptions;

  /// No description provided for @deleteLabTest.
  ///
  /// In en, this message translates to:
  /// **'Delete Lab Test'**
  String get deleteLabTest;

  /// No description provided for @editLabTest.
  ///
  /// In en, this message translates to:
  /// **'Edit Lab Test'**
  String get editLabTest;

  /// No description provided for @confirmDeleteLabTest.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this lab test? This action cannot be undone.'**
  String get confirmDeleteLabTest;

  /// No description provided for @testNumber.
  ///
  /// In en, this message translates to:
  /// **'Test Number'**
  String get testNumber;

  /// No description provided for @testDate.
  ///
  /// In en, this message translates to:
  /// **'Test Date'**
  String get testDate;

  /// No description provided for @resultImage.
  ///
  /// In en, this message translates to:
  /// **'Result Image:'**
  String get resultImage;

  /// No description provided for @unnamedTest.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Test'**
  String get unnamedTest;

  /// No description provided for @testNumberValue.
  ///
  /// In en, this message translates to:
  /// **'Test #: {number}'**
  String testNumberValue(String number);

  /// No description provided for @testDateValue.
  ///
  /// In en, this message translates to:
  /// **'Test Date: {date}'**
  String testDateValue(String date);

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get failedToUploadImage;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @medicalRecords.
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get medicalRecords;

  /// No description provided for @chronicDiseases.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronicDiseases;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @whatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg'**
  String weightKg(String weight);

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'{height} cm'**
  String heightCm(String height);

  /// No description provided for @yourHealthDashboard.
  ///
  /// In en, this message translates to:
  /// **'Your Health Dashboard'**
  String get yourHealthDashboard;

  /// No description provided for @searchDoctors.
  ///
  /// In en, this message translates to:
  /// **'Search doctors...'**
  String get searchDoctors;

  /// No description provided for @topDoctors.
  ///
  /// In en, this message translates to:
  /// **'Top Doctors'**
  String get topDoctors;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @addedDate.
  ///
  /// In en, this message translates to:
  /// **'Added: {date}'**
  String addedDate(String date);

  /// No description provided for @myDoctors.
  ///
  /// In en, this message translates to:
  /// **'My Doctors'**
  String get myDoctors;

  /// No description provided for @doctorsConnectedWith.
  ///
  /// In en, this message translates to:
  /// **'Doctors you connected with'**
  String get doctorsConnectedWith;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @loggedOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccess;

  /// No description provided for @errorLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Error logging out: {error}'**
  String errorLoggingOut(String error);

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String yearsOld(String age);

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get noData;

  /// No description provided for @fillDetailsToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Fill your details to get started'**
  String get fillDetailsToGetStarted;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @signedInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get signedInSuccess;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @pleaseSelectWeight.
  ///
  /// In en, this message translates to:
  /// **'Please select your weight to continue.'**
  String get pleaseSelectWeight;

  /// No description provided for @pleaseSelectHeight.
  ///
  /// In en, this message translates to:
  /// **'Please select your height to continue.'**
  String get pleaseSelectHeight;

  /// No description provided for @pleaseSelectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth to continue.'**
  String get pleaseSelectDateOfBirth;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender to continue.'**
  String get pleaseSelectGender;

  /// No description provided for @pleaseSelectBloodType.
  ///
  /// In en, this message translates to:
  /// **'Please select your blood type to continue.'**
  String get pleaseSelectBloodType;

  /// No description provided for @pleaseSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Please select an image to continue.'**
  String get pleaseSelectImage;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @enterYourUserName.
  ///
  /// In en, this message translates to:
  /// **'enter your user name'**
  String get enterYourUserName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterBloodType.
  ///
  /// In en, this message translates to:
  /// **'enter your blood type'**
  String get enterBloodType;

  /// No description provided for @enterHeightCm.
  ///
  /// In en, this message translates to:
  /// **'enter your height in cm'**
  String get enterHeightCm;

  /// No description provided for @enterWeightKg.
  ///
  /// In en, this message translates to:
  /// **'enter your weight in kg'**
  String get enterWeightKg;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @enterContactName.
  ///
  /// In en, this message translates to:
  /// **'enter contact name'**
  String get enterContactName;

  /// No description provided for @contactRelationship.
  ///
  /// In en, this message translates to:
  /// **'Contact Relationship'**
  String get contactRelationship;

  /// No description provided for @enterContactRelationship.
  ///
  /// In en, this message translates to:
  /// **'enter contact relationship'**
  String get enterContactRelationship;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @enterContactNumber.
  ///
  /// In en, this message translates to:
  /// **'enter contact number'**
  String get enterContactNumber;

  /// No description provided for @setYourBirthday.
  ///
  /// In en, this message translates to:
  /// **'Set your Birthday'**
  String get setYourBirthday;

  /// No description provided for @selectYourDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'select your date of birth'**
  String get selectYourDateOfBirth;

  /// No description provided for @asAPatient.
  ///
  /// In en, this message translates to:
  /// **'As a Patient'**
  String get asAPatient;

  /// No description provided for @findDesiredDoctor.
  ///
  /// In en, this message translates to:
  /// **'Find your desired doctor'**
  String get findDesiredDoctor;

  /// No description provided for @asADoctor.
  ///
  /// In en, this message translates to:
  /// **'As a Doctor'**
  String get asADoctor;

  /// No description provided for @joinAsHealthcareProvider.
  ///
  /// In en, this message translates to:
  /// **'Join as a healthcare provider'**
  String get joinAsHealthcareProvider;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @enterYourBio.
  ///
  /// In en, this message translates to:
  /// **'enter your bio'**
  String get enterYourBio;

  /// No description provided for @hospitalName.
  ///
  /// In en, this message translates to:
  /// **'Hospital Name'**
  String get hospitalName;

  /// No description provided for @enterHospitalName.
  ///
  /// In en, this message translates to:
  /// **'enter your hospital name'**
  String get enterHospitalName;

  /// No description provided for @bookDoctorToday.
  ///
  /// In en, this message translates to:
  /// **'Book your doctor today'**
  String get bookDoctorToday;

  /// No description provided for @findYourDesired.
  ///
  /// In en, this message translates to:
  /// **'Find Your Desired'**
  String get findYourDesired;

  /// No description provided for @doctorsNearYou.
  ///
  /// In en, this message translates to:
  /// **'Doctors near you'**
  String get doctorsNearYou;

  /// No description provided for @searchForDoctor.
  ///
  /// In en, this message translates to:
  /// **'Search for a doctor'**
  String get searchForDoctor;

  /// No description provided for @searchForPatient.
  ///
  /// In en, this message translates to:
  /// **'Search for a patient'**
  String get searchForPatient;

  /// No description provided for @connectedWithDoctorSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connected with doctor successfully'**
  String get connectedWithDoctorSuccess;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @aboutDoctor.
  ///
  /// In en, this message translates to:
  /// **'About Doctor'**
  String get aboutDoctor;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @helloCareLink.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m CareLink AI'**
  String get helloCareLink;

  /// No description provided for @personalAssistantDesc.
  ///
  /// In en, this message translates to:
  /// **'Your personal medical assistant.\nAsk me anything about health & wellness!'**
  String get personalAssistantDesc;

  /// No description provided for @explainMedications.
  ///
  /// In en, this message translates to:
  /// **'💊 Explain my medications'**
  String get explainMedications;

  /// No description provided for @commonColdSymptoms.
  ///
  /// In en, this message translates to:
  /// **'🩺 Common cold symptoms'**
  String get commonColdSymptoms;

  /// No description provided for @understandLabResults.
  ///
  /// In en, this message translates to:
  /// **'🧪 Understand lab results'**
  String get understandLabResults;

  /// No description provided for @heartHealthTips.
  ///
  /// In en, this message translates to:
  /// **'🫀 Heart health tips'**
  String get heartHealthTips;

  /// No description provided for @uploadLabTestImage.
  ///
  /// In en, this message translates to:
  /// **'📷 Upload lab test image'**
  String get uploadLabTestImage;

  /// No description provided for @useVoiceToAsk.
  ///
  /// In en, this message translates to:
  /// **'🎤 Use voice to ask'**
  String get useVoiceToAsk;

  /// No description provided for @uploadMedicalImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Medical Image'**
  String get uploadMedicalImage;

  /// No description provided for @medicalImageTypes.
  ///
  /// In en, this message translates to:
  /// **'Lab tests, MRI scans, X-rays, prescriptions'**
  String get medicalImageTypes;

  /// No description provided for @addMessageOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a message (optional)...'**
  String get addMessageOptional;

  /// No description provided for @askAboutHealth.
  ///
  /// In en, this message translates to:
  /// **'Ask about health & wellness...'**
  String get askAboutHealth;

  /// No description provided for @imageAttached.
  ///
  /// In en, this message translates to:
  /// **'Image attached'**
  String get imageAttached;

  /// No description provided for @readyToAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Ready to analyze'**
  String get readyToAnalyze;

  /// No description provided for @voiceError.
  ///
  /// In en, this message translates to:
  /// **'Voice error: {error}'**
  String voiceError(String error);

  /// No description provided for @speechNotAvailablePermission.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition not available. Please check microphone permissions.'**
  String get speechNotAvailablePermission;

  /// No description provided for @voiceInputFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start voice input. Please restart the app and try again.'**
  String get voiceInputFailed;

  /// No description provided for @onboardingNewTitle1.
  ///
  /// In en, this message translates to:
  /// **'All Your Medical Data in One Place'**
  String get onboardingNewTitle1;

  /// No description provided for @onboardingNewDesc1.
  ///
  /// In en, this message translates to:
  /// **'Keep your health info organized — medications, allergies, surgeries, chronic conditions, and lab results, all safely stored.'**
  String get onboardingNewDesc1;

  /// No description provided for @onboardingNewTitle2.
  ///
  /// In en, this message translates to:
  /// **'Share Your Medical Info Instantly'**
  String get onboardingNewTitle2;

  /// No description provided for @onboardingNewDesc2.
  ///
  /// In en, this message translates to:
  /// **'Your personal QR Code lets doctors and visitors access your essential health details quickly and securely.'**
  String get onboardingNewDesc2;

  /// No description provided for @onboardingNewTitle3.
  ///
  /// In en, this message translates to:
  /// **'Ask Anything. Get Instant Answers.'**
  String get onboardingNewTitle3;

  /// No description provided for @onboardingNewDesc3.
  ///
  /// In en, this message translates to:
  /// **'Get clear explanations about medications, lab tests, symptoms, or chronic conditions from your AI assistant anytime.'**
  String get onboardingNewDesc3;

  /// No description provided for @onboardingNewTitle4.
  ///
  /// In en, this message translates to:
  /// **'Your Data. Fully Protected.'**
  String get onboardingNewTitle4;

  /// No description provided for @onboardingNewDesc4.
  ///
  /// In en, this message translates to:
  /// **'Your medical information is securely stored and only you can access and control it.'**
  String get onboardingNewDesc4;

  /// No description provided for @manageYourOngoingHealthConditions.
  ///
  /// In en, this message translates to:
  /// **'Manage your ongoing health conditions'**
  String get manageYourOngoingHealthConditions;

  /// No description provided for @filterBySpecialty.
  ///
  /// In en, this message translates to:
  /// **'Filter by Specialty'**
  String get filterBySpecialty;

  /// No description provided for @allSpecialties.
  ///
  /// In en, this message translates to:
  /// **'All Specialties'**
  String get allSpecialties;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noResultsFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter'**
  String get tryDifferentSearch;

  /// No description provided for @nDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} doctors found'**
  String nDoctorsFound(int count);

  /// No description provided for @noConnectedDoctors.
  ///
  /// In en, this message translates to:
  /// **'No connected doctors'**
  String get noConnectedDoctors;

  /// No description provided for @noConnectedDoctorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect with doctors from the home page and they will appear here.'**
  String get noConnectedDoctorsDesc;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent! Check your email.'**
  String get resetLinkSent;

  /// No description provided for @resetLinkSentDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions.'**
  String get resetLinkSentDesc;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Reset your account password'**
  String get changePasswordDesc;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: February 2026'**
  String get privacyPolicyLastUpdated;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'CareLink (\"we\", \"our\", or \"us\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.'**
  String get privacyPolicyIntro;

  /// No description provided for @privacyInfoCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacyInfoCollectTitle;

  /// No description provided for @privacyInfoCollectDesc.
  ///
  /// In en, this message translates to:
  /// **'We collect personal information that you voluntarily provide to us when you register for the app, including your name, email address, phone number, date of birth, blood type, weight, height, and medical information such as chronic conditions, surgeries, vaccinations, and medications.'**
  String get privacyInfoCollectDesc;

  /// No description provided for @privacyHowWeUseTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacyHowWeUseTitle;

  /// No description provided for @privacyHowWeUseDesc.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to provide and maintain the CareLink service, connect you with healthcare professionals, manage your health records, send you appointment reminders and health updates, and improve our application.'**
  String get privacyHowWeUseDesc;

  /// No description provided for @privacyDataSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get privacyDataSecurityTitle;

  /// No description provided for @privacyDataSecurityDesc.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate technical and organizational security measures to protect your personal and medical information. Your data is encrypted in transit and at rest using industry-standard protocols.'**
  String get privacyDataSecurityDesc;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Information Sharing'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingDesc.
  ///
  /// In en, this message translates to:
  /// **'We do not sell, trade, or rent your personal information to third parties. Your medical data is only shared with healthcare providers you explicitly connect with through the application.'**
  String get privacySharingDesc;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsDesc.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, update, or delete your personal information at any time through the app settings. You may also request a complete copy of your data or ask us to erase all your information.'**
  String get privacyRightsDesc;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactDesc.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about this Privacy Policy, please contact us through the app\'s support section.'**
  String get privacyContactDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About CareLink'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDesc.
  ///
  /// In en, this message translates to:
  /// **'CareLink is a comprehensive healthcare management platform that connects patients with doctors, manages medical records, and provides AI-powered health assistance.'**
  String get aboutDesc;

  /// No description provided for @aboutMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get aboutMission;

  /// No description provided for @aboutMissionDesc.
  ///
  /// In en, this message translates to:
  /// **'To make healthcare accessible, organized, and seamless for everyone. We believe that technology can bridge the gap between patients and healthcare providers.'**
  String get aboutMissionDesc;

  /// No description provided for @aboutFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get aboutFeatures;

  /// No description provided for @aboutFeature1.
  ///
  /// In en, this message translates to:
  /// **'Connect with qualified doctors'**
  String get aboutFeature1;

  /// No description provided for @aboutFeature2.
  ///
  /// In en, this message translates to:
  /// **'Manage your complete medical history'**
  String get aboutFeature2;

  /// No description provided for @aboutFeature3.
  ///
  /// In en, this message translates to:
  /// **'AI-powered health chatbot'**
  String get aboutFeature3;

  /// No description provided for @aboutFeature4.
  ///
  /// In en, this message translates to:
  /// **'Track chronic conditions & medications'**
  String get aboutFeature4;

  /// No description provided for @aboutFeature5.
  ///
  /// In en, this message translates to:
  /// **'Secure and private health data'**
  String get aboutFeature5;

  /// No description provided for @aboutTeam.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get aboutTeam;

  /// No description provided for @aboutTeamDesc.
  ///
  /// In en, this message translates to:
  /// **'Built with ❤️ as a Graduation Project 2025'**
  String get aboutTeamDesc;

  /// No description provided for @aboutPoweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Flutter & Supabase'**
  String get aboutPoweredBy;

  /// No description provided for @rateUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying CareLink?'**
  String get rateUsTitle;

  /// No description provided for @rateUsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve! Please rate your experience with our app.'**
  String get rateUsDesc;

  /// No description provided for @rateUsSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get rateUsSubmit;

  /// No description provided for @rateUsThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get rateUsThankYou;

  /// No description provided for @rateUsThankYouDesc.
  ///
  /// In en, this message translates to:
  /// **'We appreciate your rating. Your feedback helps us make CareLink better for everyone.'**
  String get rateUsThankYouDesc;

  /// No description provided for @rateUsTapStar.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate'**
  String get rateUsTapStar;

  /// No description provided for @contactUsDesc.
  ///
  /// In en, this message translates to:
  /// **'Need help? Chat with our AI assistant for instant support.'**
  String get contactUsDesc;

  /// No description provided for @openChatbot.
  ///
  /// In en, this message translates to:
  /// **'Open AI Assistant'**
  String get openChatbot;

  /// No description provided for @imageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailable;

  /// No description provided for @analyzeThisImage.
  ///
  /// In en, this message translates to:
  /// **'Analyze this image'**
  String get analyzeThisImage;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @arabicShort.
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get arabicShort;

  /// No description provided for @englishShort.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get englishShort;

  /// No description provided for @onboardingStepsCount.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get onboardingStepsCount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
