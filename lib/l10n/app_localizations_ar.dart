// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'كير لينك';

  @override
  String get success => 'نجاح';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get close => 'إغلاق';

  @override
  String get notes => 'ملاحظات';

  @override
  String get viewMore => 'عرض المزيد...';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get added => 'أُضيف:';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get deleteConfirmation => 'تأكيد الحذف';

  @override
  String get actionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء';

  @override
  String get adding => 'جارٍ الإضافة...';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get notesMinLength => 'يجب أن تكون الملاحظات 5 أحرف على الأقل';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get signInToContinue => 'سجّل الدخول للمتابعة';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get orSignInWith => 'أو سجّل الدخول باستخدام';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinAsPatient => 'انضم إلى كير لينك كمريض';

  @override
  String get joinAsDoctor => 'انضم إلى كير لينك كطبيب';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterYourFullName => 'أدخل اسمك الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterYourPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get selectYourGender => 'اختر جنسك';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get selectDateOfBirth => 'اختر تاريخ الميلاد';

  @override
  String get specialization => 'التخصص';

  @override
  String get enterYourSpecialization => 'أدخل تخصصك';

  @override
  String get chooseYourRole => 'اختر دورك';

  @override
  String get selectHowToUse => 'اختر كيف تريد استخدام كير لينك';

  @override
  String get imAPatient => 'أنا مريض';

  @override
  String get trackHealthRecords => 'تتبع سجلاتك الصحية وتواصل مع الأطباء';

  @override
  String get imADoctor => 'أنا طبيب';

  @override
  String get managePatients => 'إدارة المرضى وسجلاتهم';

  @override
  String helloDr(String name) {
    return 'مرحباً، د. $name';
  }

  @override
  String helloUser(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get managePatientsToday => 'أدِر مرضاك اليوم';

  @override
  String get manageYour => 'أدِر';

  @override
  String get patients => 'المرضى';

  @override
  String get searchPatients => 'ابحث عن مرضى...';

  @override
  String get noPatientsYet => 'لا يوجد مرضى بعد';

  @override
  String get noPatientsDesc => 'سيظهر مرضاك هنا بمجرد اتصالهم بك.';

  @override
  String get account => 'الحساب';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get app => 'التطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get theme => 'المظهر';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get about => 'حول';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get general => 'عام';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get careLinkAI => 'كير لينك AI';

  @override
  String get online => 'متصل';

  @override
  String get askMeAnything => 'اسألني أي شيء عن الصحة...';

  @override
  String get typeYourMessage => 'اكتب رسالتك...';

  @override
  String get analyzeAnImage => 'تحليل صورة';

  @override
  String get sendAVoiceNote => 'إرسال رسالة صوتية';

  @override
  String get commonFluSymptoms => 'ما هي أعراض الإنفلونزا الشائعة؟';

  @override
  String get healthyDiet => 'كيف تحافظ على نظام غذائي صحي؟';

  @override
  String speechRecognitionError(String error) {
    return 'خطأ في التعرف على الصوت: $error';
  }

  @override
  String get speechNotAvailable => 'التعرف على الصوت غير متاح على هذا الجهاز.';

  @override
  String failedSpeechRecognition(String error) {
    return 'فشل بدء التعرف على الصوت: $error';
  }

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get aiChat => 'محادثة AI';

  @override
  String get sorryNoResponse => 'عذراً، لم أتمكن من توليد رد.';

  @override
  String get failedToAnalyzeImage =>
      'فشل تحليل الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboardingTitle1 => 'صحتك، أولويتنا';

  @override
  String get onboardingDesc1 =>
      'تتبع سجلاتك الصحية وابقَ على تواصل مع مقدمي الرعاية الصحية.';

  @override
  String get onboardingTitle2 => 'تواصل مع الأطباء';

  @override
  String get onboardingDesc2 =>
      'ابحث وتواصل مع أطباء مؤهلين للحصول على رعاية مخصصة.';

  @override
  String get onboardingTitle3 => 'تتبع سجلاتك';

  @override
  String get onboardingDesc3 =>
      'احتفظ بجميع سجلاتك الطبية منظمة ومتاحة في أي وقت.';

  @override
  String get chronicConditions => 'الأمراض المزمنة';

  @override
  String get manageChronicConditions => 'إدارة أمراضك المزمنة';

  @override
  String get addCondition => 'إضافة حالة';

  @override
  String get conditionAddedSuccess => 'تمت إضافة الحالة بنجاح';

  @override
  String get conditionDeletedSuccess => 'تم حذف الحالة بنجاح';

  @override
  String get addNewCondition => 'إضافة حالة جديدة';

  @override
  String get fillConditionDetails => 'املأ تفاصيل الحالة أدناه';

  @override
  String get conditionName => 'اسم الحالة *';

  @override
  String get pleaseEnterConditionName => 'يرجى إدخال اسم الحالة';

  @override
  String get noConditionsYet => 'لا توجد حالات بعد';

  @override
  String get addFirstCondition => 'اضغط على زر + أدناه لإضافة أول حالة.';

  @override
  String get conditionOptions => 'خيارات الحالة';

  @override
  String get deleteCondition => 'حذف الحالة';

  @override
  String get editCondition => 'تعديل الحالة';

  @override
  String get confirmDeleteCondition =>
      'هل أنت متأكد من حذف هذه الحالة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allergies => 'الحساسية';

  @override
  String get manageAllergies => 'إدارة حساسياتك المعروفة';

  @override
  String get addAllergy => 'إضافة حساسية';

  @override
  String get allergyAddedSuccess => 'تمت إضافة الحساسية بنجاح';

  @override
  String get allergyDeletedSuccess => 'تم حذف الحساسية بنجاح';

  @override
  String get addNewAllergy => 'إضافة حساسية جديدة';

  @override
  String get fillAllergyDetails => 'املأ تفاصيل الحساسية أدناه';

  @override
  String get allergyName => 'اسم الحساسية *';

  @override
  String get pleaseEnterAllergyName => 'يرجى إدخال اسم الحساسية';

  @override
  String get severity => 'الشدة';

  @override
  String get selectSeverityOptional => 'اختر الشدة (اختياري)';

  @override
  String get mild => 'خفيفة';

  @override
  String get moderate => 'متوسطة';

  @override
  String get severe => 'شديدة';

  @override
  String get unknown => 'غير معروفة';

  @override
  String get noAllergiesYet => 'لا توجد حساسية بعد';

  @override
  String get addFirstAllergy => 'اضغط على زر + أدناه لإضافة أول حساسية.';

  @override
  String get allergyOptions => 'خيارات الحساسية';

  @override
  String get deleteAllergy => 'حذف الحساسية';

  @override
  String get editAllergy => 'تعديل الحساسية';

  @override
  String get confirmDeleteAllergy =>
      'هل أنت متأكد من حذف هذه الحساسية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String severityLabel(String severity) {
    return 'الشدة: $severity';
  }

  @override
  String get medications => 'الأدوية';

  @override
  String get manageCurrentMedications => 'إدارة أدويتك الحالية';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get medicationAddedSuccess => 'تمت إضافة الدواء بنجاح';

  @override
  String get medicationDeletedSuccess => 'تم حذف الدواء بنجاح';

  @override
  String get addNewMedication => 'إضافة دواء جديد';

  @override
  String get fillMedicationDetails => 'املأ تفاصيل الدواء أدناه';

  @override
  String get medicationName => 'اسم الدواء *';

  @override
  String get pleaseEnterMedicationName => 'يرجى إدخال اسم الدواء';

  @override
  String get dosage => 'الجرعة (مثال: قرص واحد)';

  @override
  String get dosageLabel => 'الجرعة';

  @override
  String get dosageMinLength => 'يجب أن تكون الجرعة حرفين على الأقل';

  @override
  String get frequency => 'التكرار (مثال: يومياً)';

  @override
  String get frequencyLabel => 'التكرار';

  @override
  String get frequencyMinLength => 'يجب أن يكون التكرار حرفين على الأقل';

  @override
  String get startDate => 'تاريخ البدء *';

  @override
  String get startDateLabel => 'تاريخ البدء';

  @override
  String get endDateOptional => 'تاريخ الانتهاء (اختياري)';

  @override
  String get endDateLabel => 'تاريخ الانتهاء';

  @override
  String get noMedicationsYet => 'لا توجد أدوية بعد';

  @override
  String get addFirstMedication => 'اضغط على زر + أدناه لإضافة أول دواء.';

  @override
  String get medicationOptions => 'خيارات الدواء';

  @override
  String get deleteMedication => 'حذف الدواء';

  @override
  String get editMedication => 'تعديل الدواء';

  @override
  String get confirmDeleteMedication =>
      'هل أنت متأكد من حذف هذا الدواء؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get startDateRequired => 'تاريخ البدء مطلوب';

  @override
  String get endDateAfterStart => 'يجب أن يكون تاريخ الانتهاء بعد تاريخ البدء';

  @override
  String dosageValue(String value) {
    return 'الجرعة: $value';
  }

  @override
  String frequencyValue(String value) {
    return 'التكرار: $value';
  }

  @override
  String startValue(String date) {
    return 'البداية: $date';
  }

  @override
  String endValue(String date) {
    return 'النهاية: $date';
  }

  @override
  String get vaccinations => 'التطعيمات';

  @override
  String get trackVaccinationHistory => 'تتبع سجل التطعيمات';

  @override
  String get addVaccination => 'إضافة تطعيم';

  @override
  String get vaccinationAddedSuccess => 'تمت إضافة التطعيم بنجاح';

  @override
  String get vaccinationDeletedSuccess => 'تم حذف التطعيم بنجاح';

  @override
  String get addNewVaccination => 'إضافة تطعيم جديد';

  @override
  String get fillVaccinationDetails => 'املأ تفاصيل التطعيم أدناه';

  @override
  String get vaccineName => 'اسم اللقاح *';

  @override
  String get pleaseEnterVaccineName => 'يرجى إدخال اسم اللقاح';

  @override
  String get doseNumberOptional => 'رقم الجرعة (اختياري)';

  @override
  String get enterDoseNumber => 'أدخل رقم الجرعة';

  @override
  String get doseNumberPositive => 'يجب أن يكون رقم الجرعة عدداً صحيحاً موجباً';

  @override
  String get vaccinationDate => 'تاريخ التطعيم *';

  @override
  String get vaccinationDateRequired => 'تاريخ التطعيم مطلوب';

  @override
  String get noVaccinationsYet => 'لا توجد تطعيمات بعد';

  @override
  String get addFirstVaccination => 'اضغط على زر + أدناه لإضافة أول تطعيم.';

  @override
  String get vaccinationOptions => 'خيارات التطعيم';

  @override
  String get deleteVaccination => 'حذف التطعيم';

  @override
  String get editVaccination => 'تعديل التطعيم';

  @override
  String get confirmDeleteVaccination =>
      'هل أنت متأكد من حذف هذا التطعيم؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String doseLabel(int number) {
    return 'الجرعة $number';
  }

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get surgeries => 'العمليات الجراحية';

  @override
  String get trackSurgicalHistory => 'تتبع سجل العمليات الجراحية';

  @override
  String get addSurgery => 'إضافة عملية';

  @override
  String get surgeryAddedSuccess => 'تمت إضافة العملية بنجاح';

  @override
  String get surgeryDeletedSuccess => 'تم حذف العملية بنجاح';

  @override
  String get addNewSurgery => 'إضافة عملية جديدة';

  @override
  String get fillSurgeryDetails => 'املأ تفاصيل العملية أدناه';

  @override
  String get operationName => 'اسم العملية *';

  @override
  String get pleaseEnterOperationName => 'يرجى إدخال اسم العملية';

  @override
  String get operationDateOptional => 'تاريخ العملية (اختياري)';

  @override
  String get operationDate => 'تاريخ العملية';

  @override
  String get noSurgeriesYet => 'لا توجد عمليات بعد';

  @override
  String get addFirstSurgery => 'اضغط على زر + أدناه لإضافة أول عملية.';

  @override
  String get surgeryOptions => 'خيارات العملية';

  @override
  String get deleteSurgery => 'حذف العملية';

  @override
  String get editSurgery => 'تعديل العملية';

  @override
  String get confirmDeleteSurgery =>
      'هل أنت متأكد من حذف هذه العملية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get labTests => 'الفحوصات المخبرية';

  @override
  String get trackLabTestResults => 'تتبع نتائج الفحوصات المخبرية';

  @override
  String get addLabTest => 'إضافة فحص';

  @override
  String get labTestAddedSuccess => 'تمت إضافة الفحص بنجاح';

  @override
  String get labTestDeletedSuccess => 'تم حذف الفحص بنجاح';

  @override
  String get addNewLabTest => 'إضافة فحص جديد';

  @override
  String get fillLabTestDetails => 'املأ تفاصيل الفحص أدناه';

  @override
  String get testName => 'اسم الفحص *';

  @override
  String get pleaseEnterTestName => 'يرجى إدخال اسم الفحص';

  @override
  String get testNumberOptional => 'رقم الفحص (اختياري)';

  @override
  String get testNumberMinLength => 'يجب أن يكون رقم الفحص حرفين على الأقل';

  @override
  String get testDateOptional => 'تاريخ الفحص (اختياري)';

  @override
  String get testResultImage => 'صورة نتيجة الفحص (اختياري)';

  @override
  String get tapToSelectImage => 'اضغط لاختيار صورة';

  @override
  String get removeImage => 'إزالة الصورة';

  @override
  String get noLabTestsYet => 'لا توجد فحوصات بعد';

  @override
  String get addFirstLabTest => 'اضغط على زر + أدناه لإضافة أول فحص.';

  @override
  String get labTestOptions => 'خيارات الفحص';

  @override
  String get deleteLabTest => 'حذف الفحص';

  @override
  String get editLabTest => 'تعديل الفحص';

  @override
  String get confirmDeleteLabTest =>
      'هل أنت متأكد من حذف هذا الفحص؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get testNumber => 'رقم الفحص';

  @override
  String get testDate => 'تاريخ الفحص';

  @override
  String get resultImage => 'صورة النتيجة:';

  @override
  String get unnamedTest => 'فحص بدون اسم';

  @override
  String testNumberValue(String number) {
    return 'الفحص #: $number';
  }

  @override
  String testDateValue(String date) {
    return 'تاريخ الفحص: $date';
  }

  @override
  String get failedToUploadImage => 'فشل رفع الصورة';

  @override
  String get gender => 'الجنس';

  @override
  String get bloodType => 'فصيلة الدم';

  @override
  String get weight => 'الوزن';

  @override
  String get height => 'الطول';

  @override
  String get emergencyContact => 'جهة اتصال الطوارئ';

  @override
  String get name => 'الاسم';

  @override
  String get relationship => 'العلاقة';

  @override
  String get phone => 'الهاتف';

  @override
  String get medicalRecords => 'السجلات الطبية';

  @override
  String get chronicDiseases => 'الأمراض المزمنة';

  @override
  String get mobile => 'الجوال';

  @override
  String get whatsApp => 'واتساب';

  @override
  String get qrCode => 'رمز QR';

  @override
  String get connect => 'تواصل';

  @override
  String weightKg(String weight) {
    return '$weight كجم';
  }

  @override
  String heightCm(String height) {
    return '$height سم';
  }

  @override
  String get yourHealthDashboard => 'لوحة صحتك';

  @override
  String get searchDoctors => 'ابحث عن أطباء...';

  @override
  String get topDoctors => 'أفضل الأطباء';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String errorPrefix(String message) {
    return 'خطأ: $message';
  }

  @override
  String addedDate(String date) {
    return 'أُضيف: $date';
  }

  @override
  String get myDoctors => 'أطبائي';

  @override
  String get doctorsConnectedWith => 'الأطباء الذين تواصلت معهم';

  @override
  String get rateUs => 'قيّمنا';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get support => 'الدعم';

  @override
  String get loggingOut => 'جارٍ تسجيل الخروج...';

  @override
  String get loggedOutSuccess => 'تم تسجيل الخروج بنجاح';

  @override
  String errorLoggingOut(String error) {
    return 'خطأ في تسجيل الخروج: $error';
  }

  @override
  String get pleaseEnterEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get pleaseEnterFullName => 'يرجى إدخال اسمك الكامل';

  @override
  String get pleaseEnterPhoneNumber => 'يرجى إدخال رقم هاتفك';

  @override
  String get age => 'العمر';

  @override
  String yearsOld(String age) {
    return '$age سنة';
  }

  @override
  String get basicInformation => 'المعلومات الأساسية';

  @override
  String get contactInformation => 'معلومات الاتصال';

  @override
  String get noData => 'غير متوفر';

  @override
  String get fillDetailsToGetStarted => 'أدخل بياناتك للبدء';

  @override
  String get accountCreatedSuccess => 'تم إنشاء الحساب بنجاح!';

  @override
  String get signedInSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get pleaseSelectWeight => 'يرجى اختيار وزنك للمتابعة.';

  @override
  String get pleaseSelectHeight => 'يرجى اختيار طولك للمتابعة.';

  @override
  String get pleaseSelectDateOfBirth => 'يرجى اختيار تاريخ ميلادك للمتابعة.';

  @override
  String get pleaseSelectGender => 'يرجى اختيار جنسك للمتابعة.';

  @override
  String get pleaseSelectBloodType => 'يرجى اختيار فصيلة دمك للمتابعة.';

  @override
  String get pleaseSelectImage => 'يرجى اختيار صورة للمتابعة.';

  @override
  String get userName => 'اسم المستخدم';

  @override
  String get enterYourUserName => 'أدخل اسم المستخدم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterBloodType => 'أدخل فصيلة دمك';

  @override
  String get enterHeightCm => 'أدخل طولك بالسنتيمتر';

  @override
  String get enterWeightKg => 'أدخل وزنك بالكيلوجرام';

  @override
  String get contactName => 'اسم جهة الاتصال';

  @override
  String get enterContactName => 'أدخل اسم جهة الاتصال';

  @override
  String get contactRelationship => 'علاقة جهة الاتصال';

  @override
  String get enterContactRelationship => 'أدخل علاقة جهة الاتصال';

  @override
  String get contactNumber => 'رقم جهة الاتصال';

  @override
  String get enterContactNumber => 'أدخل رقم جهة الاتصال';

  @override
  String get setYourBirthday => 'حدد تاريخ ميلادك';

  @override
  String get selectYourDateOfBirth => 'اختر تاريخ ميلادك';

  @override
  String get asAPatient => 'كمريض';

  @override
  String get findDesiredDoctor => 'ابحث عن طبيبك المفضل';

  @override
  String get asADoctor => 'كطبيب';

  @override
  String get joinAsHealthcareProvider => 'انضم كمقدم رعاية صحية';

  @override
  String get continueBtn => 'متابعة';

  @override
  String get bio => 'نبذة';

  @override
  String get enterYourBio => 'أدخل نبذتك';

  @override
  String get hospitalName => 'اسم المستشفى';

  @override
  String get enterHospitalName => 'أدخل اسم المستشفى';

  @override
  String get bookDoctorToday => 'احجز طبيبك اليوم';

  @override
  String get findYourDesired => 'ابحث عن';

  @override
  String get doctorsNearYou => 'الأطباء القريبين منك';

  @override
  String get searchForDoctor => 'ابحث عن طبيب';

  @override
  String get searchForPatient => 'ابحث عن مريض';

  @override
  String get connectedWithDoctorSuccess => 'تم التواصل مع الطبيب بنجاح';

  @override
  String get specialty => 'التخصص';

  @override
  String get aboutDoctor => 'عن الطبيب';

  @override
  String get call => 'اتصال';

  @override
  String get helloCareLink => 'مرحباً! أنا كير لينك AI';

  @override
  String get personalAssistantDesc =>
      'مساعدك الطبي الشخصي.\nاسألني أي شيء عن الصحة والعافية!';

  @override
  String get explainMedications => '💊 اشرح أدويتي';

  @override
  String get commonColdSymptoms => '🩺 أعراض نزلة البرد';

  @override
  String get understandLabResults => '🧪 فهم نتائج الفحوصات';

  @override
  String get heartHealthTips => '🫀 نصائح لصحة القلب';

  @override
  String get uploadLabTestImage => '📷 رفع صورة فحص مخبري';

  @override
  String get useVoiceToAsk => '🎤 استخدم الصوت للسؤال';

  @override
  String get uploadMedicalImage => 'رفع صورة طبية';

  @override
  String get medicalImageTypes =>
      'فحوصات مخبرية، أشعة رنين، أشعة سينية، وصفات طبية';

  @override
  String get addMessageOptional => 'أضف رسالة (اختياري)...';

  @override
  String get askAboutHealth => 'اسأل عن الصحة والعافية...';

  @override
  String get imageAttached => 'تم إرفاق صورة';

  @override
  String get readyToAnalyze => 'جاهز للتحليل';

  @override
  String voiceError(String error) {
    return 'خطأ صوتي: $error';
  }

  @override
  String get speechNotAvailablePermission =>
      'التعرف على الصوت غير متاح. يرجى التحقق من أذونات الميكروفون.';

  @override
  String get voiceInputFailed =>
      'تعذر بدء الإدخال الصوتي. يرجى إعادة تشغيل التطبيق والمحاولة مرة أخرى.';

  @override
  String get onboardingNewTitle1 => 'جميع بياناتك الطبية في مكان واحد';

  @override
  String get onboardingNewDesc1 =>
      'نظّم معلوماتك الصحية — الأدوية، الحساسية، العمليات الجراحية، الأمراض المزمنة، ونتائج الفحوصات، كلها مخزنة بأمان.';

  @override
  String get onboardingNewTitle2 => 'شارك معلوماتك الطبية فوراً';

  @override
  String get onboardingNewDesc2 =>
      'رمز QR الشخصي الخاص بك يتيح للأطباء والزوار الوصول إلى تفاصيلك الصحية الأساسية بسرعة وأمان.';

  @override
  String get onboardingNewTitle3 => 'اسأل أي شيء. احصل على إجابات فورية.';

  @override
  String get onboardingNewDesc3 =>
      'احصل على شروحات واضحة حول الأدوية، الفحوصات المخبرية، الأعراض، أو الأمراض المزمنة من مساعدك الذكي في أي وقت.';

  @override
  String get onboardingNewTitle4 => 'بياناتك. محمية بالكامل.';

  @override
  String get onboardingNewDesc4 =>
      'معلوماتك الطبية مخزنة بأمان وأنت وحدك من يمكنه الوصول إليها والتحكم بها.';

  @override
  String get manageYourOngoingHealthConditions =>
      'إدارة حالاتك الصحية المستمرة';

  @override
  String get filterBySpecialty => 'تصفية حسب التخصص';

  @override
  String get allSpecialties => 'جميع التخصصات';

  @override
  String get clearFilter => 'مسح التصفية';

  @override
  String get apply => 'تطبيق';

  @override
  String get noResultsFound => 'لم يتم العثور على أطباء';

  @override
  String get tryDifferentSearch => 'جرّب بحثاً أو تصفية مختلفة';

  @override
  String nDoctorsFound(int count) {
    return 'تم العثور على $count أطباء';
  }

  @override
  String get noConnectedDoctors => 'لا يوجد أطباء متصلين';

  @override
  String get noConnectedDoctorsDesc =>
      'تواصل مع الأطباء من الصفحة الرئيسية وسيظهرون هنا.';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordDesc =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get resetLinkSent =>
      'تم إرسال رابط إعادة تعيين كلمة المرور! تحقق من بريدك.';

  @override
  String get resetLinkSentDesc =>
      'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد واتباع التعليمات.';

  @override
  String get pleaseEnterValidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordDesc => 'إعادة تعيين كلمة مرور حسابك';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get checkYourEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get sending => 'جارٍ الإرسال...';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get privacyPolicyLastUpdated => 'آخر تحديث: فبراير 2026';

  @override
  String get privacyPolicyIntro =>
      'تلتزم CareLink (\"نحن\" أو \"لنا\") بحماية خصوصيتك. توضح سياسة الخصوصية هذه كيف نجمع معلوماتك ونستخدمها ونفصح عنها ونحميها عند استخدامك لتطبيقنا.';

  @override
  String get privacyInfoCollectTitle => 'المعلومات التي نجمعها';

  @override
  String get privacyInfoCollectDesc =>
      'نجمع المعلومات الشخصية التي تقدمها طوعاً عند التسجيل في التطبيق، بما في ذلك اسمك وبريدك الإلكتروني ورقم هاتفك وتاريخ ميلادك وفصيلة دمك ووزنك وطولك والمعلومات الطبية مثل الأمراض المزمنة والعمليات الجراحية والتطعيمات والأدوية.';

  @override
  String get privacyHowWeUseTitle => 'كيف نستخدم معلوماتك';

  @override
  String get privacyHowWeUseDesc =>
      'نستخدم المعلومات التي نجمعها لتقديم خدمة CareLink والحفاظ عليها، وربطك بمتخصصي الرعاية الصحية، وإدارة سجلاتك الصحية، وإرسال تذكيرات المواعيد والتحديثات الصحية، وتحسين تطبيقنا.';

  @override
  String get privacyDataSecurityTitle => 'أمن البيانات';

  @override
  String get privacyDataSecurityDesc =>
      'ننفذ إجراءات أمنية تقنية وتنظيمية مناسبة لحماية معلوماتك الشخصية والطبية. يتم تشفير بياناتك أثناء النقل وفي حالة السكون باستخدام بروتوكولات قياسية.';

  @override
  String get privacySharingTitle => 'مشاركة المعلومات';

  @override
  String get privacySharingDesc =>
      'لا نبيع أو نتاجر أو نؤجر معلوماتك الشخصية لأطراف ثالثة. تتم مشاركة بياناتك الطبية فقط مع مقدمي الرعاية الصحية الذين تتواصل معهم صراحةً عبر التطبيق.';

  @override
  String get privacyRightsTitle => 'حقوقك';

  @override
  String get privacyRightsDesc =>
      'لديك الحق في الوصول إلى معلوماتك الشخصية أو تحديثها أو حذفها في أي وقت من خلال إعدادات التطبيق. يمكنك أيضاً طلب نسخة كاملة من بياناتك أو مطالبتنا بمسح جميع معلوماتك.';

  @override
  String get privacyContactTitle => 'اتصل بنا';

  @override
  String get privacyContactDesc =>
      'إذا كانت لديك أسئلة حول سياسة الخصوصية هذه، يرجى التواصل معنا من خلال قسم الدعم في التطبيق.';

  @override
  String get aboutTitle => 'حول CareLink';

  @override
  String aboutVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get aboutDesc =>
      'CareLink هي منصة شاملة لإدارة الرعاية الصحية تربط المرضى بالأطباء وتدير السجلات الطبية وتوفر مساعدة صحية مدعومة بالذكاء الاصطناعي.';

  @override
  String get aboutMission => 'مهمتنا';

  @override
  String get aboutMissionDesc =>
      'جعل الرعاية الصحية متاحة ومنظمة وسلسة للجميع. نؤمن بأن التكنولوجيا يمكن أن تسد الفجوة بين المرضى ومقدمي الرعاية الصحية.';

  @override
  String get aboutFeatures => 'الميزات الرئيسية';

  @override
  String get aboutFeature1 => 'تواصل مع أطباء مؤهلين';

  @override
  String get aboutFeature2 => 'إدارة تاريخك الطبي الكامل';

  @override
  String get aboutFeature3 => 'روبوت محادثة صحي مدعوم بالذكاء الاصطناعي';

  @override
  String get aboutFeature4 => 'تتبع الأمراض المزمنة والأدوية';

  @override
  String get aboutFeature5 => 'بيانات صحية آمنة وخاصة';

  @override
  String get aboutTeam => 'فريق التطوير';

  @override
  String get aboutTeamDesc => 'تم بناؤه بـ ❤️ كمشروع تخرج 2025';

  @override
  String get aboutPoweredBy => 'مدعوم بـ Flutter و Supabase';

  @override
  String get rateUsTitle => 'هل تستمتع بـ CareLink؟';

  @override
  String get rateUsDesc =>
      'ملاحظاتك تساعدنا على التحسين! يرجى تقييم تجربتك مع تطبيقنا.';

  @override
  String get rateUsSubmit => 'إرسال التقييم';

  @override
  String get rateUsThankYou => 'شكراً لملاحظاتك!';

  @override
  String get rateUsThankYouDesc =>
      'نقدر تقييمك. ملاحظاتك تساعدنا في جعل CareLink أفضل للجميع.';

  @override
  String get rateUsTapStar => 'انقر على نجمة للتقييم';

  @override
  String get contactUsDesc =>
      'تحتاج مساعدة؟ تحدث مع مساعدنا الذكي للحصول على دعم فوري.';

  @override
  String get openChatbot => 'فتح المساعد الذكي';

  @override
  String get imageUnavailable => 'الصورة غير متاحة';

  @override
  String get analyzeThisImage => 'تحليل هذه الصورة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get arabicShort => 'عربي';

  @override
  String get englishShort => 'EN';

  @override
  String get onboardingStepsCount => '4';
}
