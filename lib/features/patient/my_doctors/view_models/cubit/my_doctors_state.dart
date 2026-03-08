part of 'my_doctors_cubit.dart';

@immutable
sealed class MyDoctorsState {}

final class MyDoctorsInitial extends MyDoctorsState {}

final class MyDoctorsLoading extends MyDoctorsState {}

final class MyDoctorsSuccess extends MyDoctorsState {}

final class MyDoctorsFailure extends MyDoctorsState {
  final String errorMessage;
  MyDoctorsFailure({required this.errorMessage});
}








