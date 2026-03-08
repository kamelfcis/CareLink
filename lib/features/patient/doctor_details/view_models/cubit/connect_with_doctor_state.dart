part of 'connect_with_doctor_cubit.dart';

@immutable
sealed class ConnectWithDoctorState {}

final class ConnectWithDoctorInitial extends ConnectWithDoctorState {}

final class ConnectWithDoctorLoading extends ConnectWithDoctorState {}

final class ConnectWithDoctorSuccess extends ConnectWithDoctorState {}

final class ConnectWithDoctorFailure extends ConnectWithDoctorState {
  final String message;
  ConnectWithDoctorFailure({required this.message});
}
