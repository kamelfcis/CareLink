import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/network/supabase/database/get_data_with_spacific_id.dart';
import 'package:care_link/features/auth/sign_in/models/user_model.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:care_link/app/my_app.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/network/supabase/auth/sign_in_with_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'sign_in_state.dart';

enum UserRole { doctor, patient }

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = getIt<SupabaseClient>();
  UserModel? userModel;
  // Sign in Method
  signIn() async {
    if (formKey.currentState!.validate()) {
      try {
        emit(SignInLoading());
        FocusScope.of(navigatorKey.currentContext!).unfocus();
        await signInWithPassword(
            email: emailController.text, password: passwordController.text);
        await getUserData();
        emit(SignInSuccess(route: getScreenRoute()));
      } on Exception catch (e) {
        emit(SignInFailure(message: e.toString()));
      }
    }
  }

  Future<void> getUserData() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) {
      throw Exception("User not found");
    }

    try {
      var userData = await getDataWithSpacificId(
        tableName: "users",
        primaryKey: "id",
        id: authUser.id,
      );

      if (userData.isEmpty) {
        await supabase.from('users').upsert({
          'id': authUser.id,
          'email': authUser.email ?? '',
          'name': authUser.userMetadata?['full_name']?.toString() ?? '',
          'role': UserRole.patient.name,
        });
        userData = await getDataWithSpacificId(
          tableName: "users",
          primaryKey: "id",
          id: authUser.id,
        );
      }

      if (userData.isEmpty) {
        throw Exception("User not found");
      }

      userModel = UserModel.fromJson(userData.first);

      if (userModel!.role == UserRole.doctor.name) {
        final doctorData =
            await getIt<SupabaseClient>().from('doctors').select('''
      *,
      doctor_specialties (
*      )
    ''').eq('doctor_id', userModel!.id).single();
        DoctorModel doctorModel = DoctorModel.fromJson(doctorData);
        doctorModel = doctorModel.copyWith(doctor: userModel!);
        await getIt<CacheHelper>().saveDoctorModel(doctorModel);
      } else {
        var patientData = await getDataWithSpacificId(
          tableName: "patients",
          primaryKey: "patient_id",
          id: userModel!.id,
        );

        if (patientData.isEmpty) {
          patientData = await getDataWithSpacificId(
            tableName: "patients",
            primaryKey: "auth_user_id",
            id: userModel!.id,
          );
        }

        if (patientData.isEmpty) {
          throw Exception("Patient profile not found");
        }

        PatientModel patientModel = PatientModel.fromJson(patientData.first);
        patientModel = patientModel.copyWith(patient: userModel!);
        await getIt<CacheHelper>().savePatientModel(patientModel);
      }
    } on Exception {
      rethrow;
    } catch (e, stackTrace) {
      log('getUserData failed: $e', stackTrace: stackTrace);
      throw Exception("Failed to fetch user data or user not found");
    }
  }

  // get screen route
  String getScreenRoute() {
    if (userModel!.role == UserRole.doctor.name) {
      return RouteNames.doctorHomeScreen;
    } else {
      return RouteNames.patientHomeScreen;
    }
  }

  // Dispose Controllers
  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
