part of 'doctor_reviews_cubit.dart';

@immutable
sealed class DoctorReviewsState {}

final class DoctorReviewsInitial extends DoctorReviewsState {}

final class DoctorReviewsLoading extends DoctorReviewsState {}

final class DoctorReviewsLoaded extends DoctorReviewsState {}

final class DoctorReviewsFailure extends DoctorReviewsState {
  final String message;
  DoctorReviewsFailure(this.message);
}

final class DoctorReviewSubmitting extends DoctorReviewsState {}

final class DoctorReviewSubmitSuccess extends DoctorReviewsState {}

final class DoctorReviewDeleting extends DoctorReviewsState {}

final class DoctorReviewDeleteSuccess extends DoctorReviewsState {}
