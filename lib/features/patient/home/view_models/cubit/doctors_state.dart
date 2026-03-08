part of 'doctors_cubit.dart';

@immutable
sealed class DoctorsState {}

final class DoctorsInitial extends DoctorsState {}

final class GetDoctorsLoading extends DoctorsState {}
final class GetDoctorsSuccess extends DoctorsState {}
final class DoctorsFiltered extends DoctorsState {}
final class GetDoctorsFailure extends DoctorsState {
  final String errorMessage;
  GetDoctorsFailure({required this.errorMessage});
}
