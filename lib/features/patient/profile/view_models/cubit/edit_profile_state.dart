part of 'edit_profile_cubit.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final PatientModel updatedPatient;
  EditProfileSuccess(this.updatedPatient);
}

class EditProfileFailure extends EditProfileState {
  final String message;
  EditProfileFailure(this.message);
}

class EditProfileImagePicked extends EditProfileState {}

class EditProfileFieldUpdated extends EditProfileState {}
