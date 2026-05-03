import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/helper/pick_image.dart';
import 'package:care_link/core/network/supabase/storage/upload_file.dart';
import 'package:care_link/features/auth/sign_in/models/user_model.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/emergency_contact_model.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this.patient) : super(EditProfileInitial()) {
    _init();
  }

  final PatientModel patient;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final emergencyNameController = TextEditingController();
  final emergencyRelationshipController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? selectedGender;
  String? selectedBloodType;
  String? selectedDateOfBirth;
  File? pickedImage;

  void _init() {
    nameController.text = patient.patient?.name ?? '';
    phoneController.text = patient.patient?.phone ?? '';
    weightController.text =
        patient.weight == 0.0 ? '' : patient.weight.toStringAsFixed(1);
    heightController.text =
        patient.height == 0.0 ? '' : patient.height.toStringAsFixed(1);
    emergencyNameController.text = patient.emergencyContact.name;
    emergencyRelationshipController.text =
        patient.emergencyContact.relationship;
    emergencyPhoneController.text = patient.emergencyContact.phone;
    selectedGender = patient.gender;
    selectedBloodType = patient.bloodType;
    selectedDateOfBirth = patient.dateOfBirth;
  }

  void selectGender(String gender) {
    selectedGender = gender;
    emit(EditProfileFieldUpdated());
  }

  void selectBloodType(String bloodType) {
    selectedBloodType = bloodType;
    emit(EditProfileFieldUpdated());
  }

  void selectDateOfBirth(String date) {
    selectedDateOfBirth = date;
    emit(EditProfileFieldUpdated());
  }

  Future<void> pickProfileImage() async {
    final file = await pickImage(source: ImageSource.gallery);
    if (file != null) {
      pickedImage = file;
      emit(EditProfileImagePicked());
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      emit(EditProfileLoading());

      final supabase = getIt<SupabaseClient>();
      final userId = patient.patient!.id;

      String imageUrl = patient.patient!.image;
      if (pickedImage != null) {
        final url = await uploadFileToSupabaseStorage(
          file: pickedImage!,
          pucketName: 'user-avatars',
        );
        if (url != null) imageUrl = url;
      }

      await supabase.from('users').update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'image': imageUrl,
      }).eq('id', userId);

      await supabase.from('patients').update({
        'gender': selectedGender ?? patient.gender,
        'blood_type': selectedBloodType ?? patient.bloodType,
        'date_of_birth': selectedDateOfBirth ?? patient.dateOfBirth,
        'weight_kg':
            double.tryParse(weightController.text.trim()) ?? patient.weight,
        'height_cm':
            double.tryParse(heightController.text.trim()) ?? patient.height,
        'emergency_contact': {
          'name': emergencyNameController.text.trim(),
          'relationship': emergencyRelationshipController.text.trim(),
          'phone': emergencyPhoneController.text.trim(),
        },
      }).eq('patient_id', userId);

      final updatedPatient = patient.copyWith(
        gender: selectedGender ?? patient.gender,
        bloodType: selectedBloodType ?? patient.bloodType,
        dateOfBirth: selectedDateOfBirth ?? patient.dateOfBirth,
        weight:
            double.tryParse(weightController.text.trim()) ?? patient.weight,
        height:
            double.tryParse(heightController.text.trim()) ?? patient.height,
        emergencyContact: EmergencyContactModel(
          name: emergencyNameController.text.trim(),
          relationship: emergencyRelationshipController.text.trim(),
          phone: emergencyPhoneController.text.trim(),
        ),
        patient: UserModel(
          id: patient.patient!.id,
          name: nameController.text.trim(),
          email: patient.patient!.email,
          phone: phoneController.text.trim(),
          image: imageUrl,
          role: patient.patient!.role,
          tokens: patient.patient!.tokens,
        ),
      );

      await getIt<CacheHelper>().savePatientModel(updatedPatient);
      emit(EditProfileSuccess(updatedPatient));
    } catch (e) {
      emit(EditProfileFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    weightController.dispose();
    heightController.dispose();
    emergencyNameController.dispose();
    emergencyRelationshipController.dispose();
    emergencyPhoneController.dispose();
    return super.close();
  }
}
