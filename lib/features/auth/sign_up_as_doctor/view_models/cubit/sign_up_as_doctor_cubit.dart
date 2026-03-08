import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:care_link/core/network/supabase/database/get_data.dart';
import 'package:care_link/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_specialty_model.dart';
import 'package:flutter/material.dart';
import 'package:care_link/app/my_app.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/helper/pick_image.dart';
import 'package:care_link/core/network/supabase/auth/sign_up_with_password.dart';
import 'package:care_link/core/network/supabase/database/add_data.dart';
import 'package:care_link/core/network/supabase/storage/upload_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'sign_up_as_doctor_state.dart';

class SignUpAsDoctorCubit extends Cubit<SignUpAsDoctorState> {
  SignUpAsDoctorCubit() : super(SignUpInitial()){
    getDoctorSpecialties();
  }
  // Controllers && Keys && Variables
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final hospitalController = TextEditingController();
  final passwordController = TextEditingController();
  //
  final formKey = GlobalKey<FormState>();
  File? image;
  String? sselectedSpecialtyId;
  //// Methods
  /// get doctor specialization list
  List<DoctorSpecialtyModel> doctorSpecialties = [];
  getDoctorSpecialties() async{
    try {
      emit(GetDoctorSpecialtiesLoading());
      final response =await getData(tableName: "doctor_specialties");
      doctorSpecialties = response
          .map<DoctorSpecialtyModel>(
              (e) => DoctorSpecialtyModel.fromJson(e))
          .toList();
      emit(GetDoctorSpecialtiesSuccess());
    } on Exception catch (e) {
      emit(GetDoctorSpecialtiesFailure(errorMessage: e.toString()));
    }
  }

  /// Sign Up Method
  signUpAsDoctor() async {
    if (formKey.currentState!.validate()) {
      if (sselectedSpecialtyId == null) {
        emit(SelectSpecialty());
        return;
      }
      if (image == null) {
        emit(SelectImage());
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
            "role": UserRole.doctor.name,
            "image": await uploadFileToSupabaseStorage(
                file: image!, pucketName: "user-avatars"),
          },
        );
        await addData(
          tableName: "doctors",
          data: {
            "doctor_id": getIt<SupabaseClient>().auth.currentUser!.id,
            "specialty_id": sselectedSpecialtyId,
            "hospital": hospitalController.text,
            "bio": bioController.text,
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
    bioController.dispose();
    hospitalController.dispose();
    return super.close();
  }
}
