part of 'sign_up_as_doctor_cubit.dart';

@immutable
sealed class SignUpAsDoctorState {}

final class SignUpInitial extends SignUpAsDoctorState {}

final class SignUpLoading extends SignUpAsDoctorState {}

final class SignUpSuccess extends SignUpAsDoctorState {}

final class SignUpFailure extends SignUpAsDoctorState {
  final String errorMessage;
  SignUpFailure({required this.errorMessage});
}

// pick image
final class PickImageLoading extends SignUpAsDoctorState {}

final class PickImageSuccess extends SignUpAsDoctorState {}

final class PickImageFailure extends SignUpAsDoctorState {
  final String errorMessage;
  PickImageFailure({required this.errorMessage});
}

final class SelectImage extends SignUpAsDoctorState {}

// sign up with google
final class SignUpWithGoogleLoading extends SignUpAsDoctorState {}

final class SignUpWithGoogleSuccess extends SignUpAsDoctorState {}

final class SignUpWithGoogleFailure extends SignUpAsDoctorState {
  final String errorMessage;
  SignUpWithGoogleFailure({required this.errorMessage});
}
// get doctor specialization list
final class GetDoctorSpecialtiesLoading extends SignUpAsDoctorState {}

final class GetDoctorSpecialtiesSuccess extends SignUpAsDoctorState {}
final class GetDoctorSpecialtiesFailure extends SignUpAsDoctorState {
  final String errorMessage;
  GetDoctorSpecialtiesFailure({required this.errorMessage});
}
// for select specialty
final class SelectSpecialty extends SignUpAsDoctorState {}