part of 'patients_cubit.dart';

@immutable
sealed class PatientsState {}

final class PatientsInitial extends PatientsState {}

final class GetPatientsLoading extends PatientsState {}

final class GetPatientsSuccess extends PatientsState {}

final class GetPatientsError extends PatientsState {
  final String errorMessage;
  GetPatientsError({required this.errorMessage});
}
