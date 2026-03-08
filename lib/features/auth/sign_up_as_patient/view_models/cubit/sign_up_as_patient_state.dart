part of 'sign_up_as_patient_cubit.dart';

@immutable
sealed class SignUpAsPatientState {}

final class SignUpInitial extends SignUpAsPatientState {}

final class SignUpLoading extends SignUpAsPatientState {}

final class SignUpSuccess extends SignUpAsPatientState {}

final class SignUpFailure extends SignUpAsPatientState {
  final String errorMessage;
  SignUpFailure({required this.errorMessage});
}

// pick image
final class PickImageLoading extends SignUpAsPatientState {}

final class PickImageSuccess extends SignUpAsPatientState {}

final class PickImageFailure extends SignUpAsPatientState {
  final String errorMessage;
  PickImageFailure({required this.errorMessage});
}

final class SelectImage extends SignUpAsPatientState {}

// sign up with google
final class SignUpWithGoogleLoading extends SignUpAsPatientState {}

final class SignUpWithGoogleSuccess extends SignUpAsPatientState {}

final class SignUpWithGoogleFailure extends SignUpAsPatientState {
  final String errorMessage;
  SignUpWithGoogleFailure({required this.errorMessage});
}

// required fields not selected
final class SelectGender extends SignUpAsPatientState {}

final class UpdateGender extends SignUpAsPatientState {}

final class SelectBloodType extends SignUpAsPatientState {}

final class SelectHeight extends SignUpAsPatientState {}

final class SelectWeight extends SignUpAsPatientState {}

final class SelectDateOfBirth extends SignUpAsPatientState {}

final class UpdateDateOfBirth extends SignUpAsPatientState {}
