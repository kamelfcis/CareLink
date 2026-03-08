import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:care_link/app/my_app.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/helper/pick_image.dart';
import 'package:care_link/core/network/supabase/auth/sign_up_with_password.dart';
import 'package:care_link/core/network/supabase/database/add_data.dart';
import 'package:care_link/core/network/supabase/storage/upload_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'sign_up_as_patient_state.dart';

class SignUpAsPatientCubit extends Cubit<SignUpAsPatientState> {
  SignUpAsPatientCubit() : super(SignUpInitial());
  // Controllers && Keys && Variables
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final emergencyContactNameController = TextEditingController();
  final emergencyContactrelationshipController = TextEditingController();
  final emergencyContactPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  //
  String? gender;
  String? bloodType;
  String? dateOfBirth;
  double? height;
  double? weight;
  final formKey = GlobalKey<FormState>();
  File? image;
  //// Methods
  /// pick Date of Birth Method
  selectDate(String date) {
    dateOfBirth = date;
    emit(UpdateDateOfBirth());
  }

  /// select Gender
  selectGender(String selectedGender) {
    gender = selectedGender;
    emit(UpdateGender());
  }

  /// Sign Up Method
  signUp() async {
    if (formKey.currentState!.validate()) {
      if (image == null) {
        emit(SelectImage());
        return;
      }
      if (dateOfBirth == null) {
        emit(SelectDateOfBirth());
        return;
      }
      if (gender == null) {
        emit(SelectGender());
        return;
      }
      if (bloodType == null) {
        emit(SelectBloodType());
        return;
      }
      if (height == null) {
        emit(SelectHeight());
        return;
      }
      if (weight == null) {
        emit(SelectWeight());
        return;
      }
      try {
        emit(SignUpLoading());
        FocusScope.of(navigatorKey.currentContext!).unfocus();
        await signUpWithPassword(
            email: emailController.text, password: passwordController.text);
        await addData(
          tableName: "users",
          data: {
            "id": getIt<SupabaseClient>().auth.currentUser!.id,
            "name": userNameController.text,
            "phone": phoneController.text,
            "email": emailController.text,
            "role": UserRole.patient.name,
            "image": await uploadFileToSupabaseStorage(
                file: image!, pucketName: "user-avatars"),
          },
        );
        await addData(
          tableName: "patients",
          data: {
            "patient_id": getIt<SupabaseClient>().auth.currentUser!.id,
            "height_cm": height,
            "weight_kg": weight,
            "blood_type": bloodType,
            "gender": gender,
            "emergency_contact": {
              "name": emergencyContactNameController.text,
              "relationship": emergencyContactrelationshipController.text,
              "phone": emergencyContactPhoneController.text,
            },
            "date_of_birth": dateOfBirth,
          },
        );
        emit(SignUpSuccess());
      } on Exception catch (e) {
        emit(SignUpFailure(errorMessage: e.toString()));
      }
    }
  }

  // pick Image Method
  pickProfileImage() {
    pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        image = value;
        emit(PickImageSuccess());
      } else {
        emit(PickImageFailure(errorMessage: "No image selected"));
      }
    });
  }

  // Dispose Controllers
  @override
  Future<void> close() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    emergencyContactNameController.dispose();
    emergencyContactrelationshipController.dispose();
    emergencyContactPhoneController.dispose();

    return super.close();
  }
}
