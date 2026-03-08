import 'package:care_link/features/auth/select_role/views/screens/select_role_screen.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:care_link/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/view_models/cubit/sign_up_as_doctor_cubit.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/screens/sign_up_as_doctor_screen.dart';
import 'package:care_link/features/auth/sign_up_as_patient/view_models/cubit/sign_up_as_patient_cubit.dart';
import 'package:care_link/features/auth/sign_up_as_patient/views/screens/sign_up_as_patient_screen.dart';
import 'package:care_link/features/chatbot/view_models/cubit/chatbot_cubit.dart';
import 'package:care_link/features/chatbot/views/screens/chatbot_screen.dart';
import 'package:care_link/features/doctor/home/view_models/cubit/patients_cubit.dart';
import 'package:care_link/features/doctor/home/views/screens/doctor_home_screen.dart';
import 'package:care_link/features/doctor/patient_details/views/screens/patient_details_screen.dart';
import 'package:care_link/features/on_boarding/view_models/cubit/on_boarding_cubit.dart';
import 'package:care_link/features/on_boarding/views/screens/on_boarding_screen.dart';
import 'package:care_link/features/patient/allergies/views/screens/allergies_screen.dart';
import 'package:care_link/features/patient/chronic_conditions/views/screens/chronic_conditions_screen.dart';
import 'package:care_link/features/patient/doctor_details/view_models/cubit/connect_with_doctor_cubit.dart';
import 'package:care_link/features/patient/doctor_details/views/screens/doctor_details_screen.dart';
import 'package:care_link/features/patient/home/view_models/cubit/doctors_cubit.dart';
import 'package:care_link/features/patient/home/views/screens/home_screen.dart';
import 'package:care_link/features/patient/lab_tests/views/screens/lab_tests_screen.dart';
import 'package:care_link/features/patient/medications/views/screens/medications_screen.dart';
import 'package:care_link/features/patient/settings/views/screens/settings_screen.dart';
import 'package:care_link/features/patient/surgeries/views/screens/surgeries_screen.dart';
import 'package:care_link/features/patient/vaccinations/views/screens/vaccinations_screen.dart';
import 'package:care_link/features/splash/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:care_link/core/app_route/route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    RouteNames.splashScreen: (context) => const SplashScreen(),
    RouteNames.onBoardingScreen: (context) => BlocProvider(
          create: (context) => OnBoardingCubit(),
          child: const OnBoardingScreen(),
        ),
    RouteNames.selectRoleScreen: (context) => const SelectRoleScreen(),
    RouteNames.signInScreen: (context) => BlocProvider(
          create: (context) => SignInCubit(),
          child: const SignInScreen(),
        ),
    RouteNames.signUpAsPatientScreen: (context) => BlocProvider(
          create: (context) => SignUpAsPatientCubit(),
          child: const SignUpAsPatientScreen(),
        ),
    RouteNames.signUpAsDoctorScreen: (context) => BlocProvider(
          create: (context) => SignUpAsDoctorCubit(),
          child: const SignUpAsDoctorScreen(),
        ),
    RouteNames.patientHomeScreen: (context) => BlocProvider(
          create: (context) => DoctorsCubit(),
          child: const PatientHomeScreen(),
        ),
    RouteNames.doctorHomeScreen: (context) => BlocProvider(
          create: (context) => PatientsCubit(),
          child: const DoctorHomeScreen(),
        ),
    RouteNames.chronicConditionsScreen: (context) {
      return ChronicConditionsScreen();
    },
    RouteNames.medicationsScreen: (context) => const MedicationsScreen(),
    RouteNames.allergiesScreen: (context) => const AllergiesScreen(),
    RouteNames.vaccinationsScreen: (context) => const VaccinationsScreen(),
    RouteNames.surgeriesScreen: (context) => const SurgeriesScreen(),
    RouteNames.labTestsScreen: (context) => const LabTestsScreen(),
    RouteNames.settingsScreen: (context) => const SettingsScreen(),
    RouteNames.patientDetailsScreen: (context) => const PatientProfileScreen(),
    RouteNames.doctorDetailsScreen: (context) => BlocProvider(
          create: (context) => ConnectWithDoctorCubit(),
          child: const DoctorProfileScreen(),
        ),
    RouteNames.chatBotScreen: (context) => BlocProvider(
          create: (context) => ChatBotCubit(),
          child: const ChatBotScreen(),
        ),
  };
}
