part of 'connect_with_doctor_cubit.dart';

@immutable
sealed class ConnectWithDoctorState {}

final class ConnectWithDoctorInitial extends ConnectWithDoctorState {}

/// Checking current connection status with the doctor
final class ConnectWithDoctorChecking extends ConnectWithDoctorState {}

/// Patient is already connected to this doctor
final class ConnectWithDoctorConnected extends ConnectWithDoctorState {}

/// Patient is not connected to this doctor
final class ConnectWithDoctorNotConnected extends ConnectWithDoctorState {}

/// Connecting or disconnecting in progress
final class ConnectWithDoctorLoading extends ConnectWithDoctorState {}

/// Successfully connected
final class ConnectWithDoctorSuccess extends ConnectWithDoctorState {}

/// Successfully disconnected
final class ConnectWithDoctorDisconnected extends ConnectWithDoctorState {}

final class ConnectWithDoctorFailure extends ConnectWithDoctorState {
  final String message;
  ConnectWithDoctorFailure({required this.message});
}
