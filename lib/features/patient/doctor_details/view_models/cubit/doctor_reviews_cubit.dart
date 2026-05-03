import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'doctor_reviews_state.dart';

// ═══════════════════════════════════════════════════
//  MODEL
// ═══════════════════════════════════════════════════

@immutable
class DoctorReviewModel {
  final String id;
  final String doctorId;
  final String patientId;
  final int rating;
  final String? reviewText;
  final DateTime createdAt;
  final String? reviewerName;
  final String? reviewerImage;

  const DoctorReviewModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.rating,
    this.reviewText,
    required this.createdAt,
    this.reviewerName,
    this.reviewerImage,
  });

  factory DoctorReviewModel.fromMap(Map<String, dynamic> map) {
    final patient = map['patients'] as Map<String, dynamic>?;
    final user = patient?['users'] as Map<String, dynamic>?;
    return DoctorReviewModel(
      id: map['id'] as String,
      doctorId: map['doctor_id'] as String,
      patientId: map['patient_id'] as String,
      rating: (map['rating'] as num).toInt(),
      reviewText: map['review_text'] as String?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
      reviewerName: user?['name'] as String?,
      reviewerImage: user?['image'] as String?,
    );
  }
}

// ═══════════════════════════════════════════════════
//  CUBIT
// ═══════════════════════════════════════════════════

class DoctorReviewsCubit extends Cubit<DoctorReviewsState> {
  DoctorReviewsCubit() : super(DoctorReviewsInitial());

  final _supabase = getIt<SupabaseClient>();
  final _cache = getIt<CacheHelper>();

  List<DoctorReviewModel> reviews = [];
  DoctorReviewModel? myReview;
  double avgRating = 0.0;

  String get _patientId => _cache.getPatientModel()!.id;

  // ── Fetch all reviews for a doctor ───────────────
  Future<void> fetchReviews(String doctorId) async {
    try {
      emit(DoctorReviewsLoading());
      final response = await _supabase
          .from('doctor_reviews')
          .select('*, patients(users(name, image))')
          .eq('doctor_id', doctorId)
          .order('created_at', ascending: false);

      reviews = (response as List)
          .map((e) => DoctorReviewModel.fromMap(e))
          .toList();

      final pid = _patientId;
      myReview = reviews.where((r) => r.patientId == pid).firstOrNull;

      avgRating = reviews.isEmpty
          ? 0.0
          : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
              reviews.length;

      emit(DoctorReviewsLoaded());
    } catch (e) {
      log('fetchReviews error: $e');
      emit(DoctorReviewsFailure(e.toString()));
    }
  }

  // ── Submit (insert or update) a review ───────────
  Future<void> submitReview({
    required String doctorId,
    required int rating,
    String? reviewText,
  }) async {
    try {
      emit(DoctorReviewSubmitting());
      await _supabase.from('doctor_reviews').upsert(
        {
          'doctor_id': doctorId,
          'patient_id': _patientId,
          'rating': rating,
          'review_text': reviewText?.trim().isEmpty == true
              ? null
              : reviewText?.trim(),
        },
        onConflict: 'doctor_id,patient_id',
      );
      emit(DoctorReviewSubmitSuccess());
      await fetchReviews(doctorId);
    } catch (e) {
      log('submitReview error: $e');
      emit(DoctorReviewsFailure(e.toString()));
    }
  }

  // ── Delete current patient's review ──────────────
  Future<void> deleteReview(String doctorId) async {
    try {
      emit(DoctorReviewDeleting());
      await _supabase
          .from('doctor_reviews')
          .delete()
          .eq('doctor_id', doctorId)
          .eq('patient_id', _patientId);
      emit(DoctorReviewDeleteSuccess());
      await fetchReviews(doctorId);
    } catch (e) {
      log('deleteReview error: $e');
      emit(DoctorReviewsFailure(e.toString()));
    }
  }
}
