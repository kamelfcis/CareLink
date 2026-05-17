import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit() : super(DoctorsInitial()) {
    getDoctorsList();
  }

  List<DoctorModel> doctors = [];
  List<DoctorModel> filteredDoctors = [];
  final supabase = getIt<SupabaseClient>();

  String _searchQuery = '';
  String? _selectedSpecialty;
  String? _selectedGovernorate;

  String? get selectedSpecialty => _selectedSpecialty;
  String? get selectedGovernorate => _selectedGovernorate;

  /// How many filters are currently active
  int get activeFilterCount =>
      (_selectedSpecialty != null ? 1 : 0) +
      (_selectedGovernorate != null ? 1 : 0);

  /// All unique specialty names from loaded doctors
  List<String> get specialties {
    final set = <String>{};
    for (final doc in doctors) {
      set.add(doc.specialty.name);
    }
    return set.toList()..sort();
  }

  /// All unique governorates from loaded doctors (non-null only)
  List<String> get governorates {
    final set = <String>{};
    for (final doc in doctors) {
      if (doc.governorate != null && doc.governorate!.isNotEmpty) {
        set.add(doc.governorate!);
      }
    }
    return set.toList()..sort();
  }

  /// Pull-to-refresh: reload doctors without replacing the list with a full-screen loader.
  Future<void> refreshDoctors() => getDoctorsList(showLoading: false);

  Future<void> getDoctorsList({bool showLoading = true}) async {
    try {
      if (showLoading) emit(GetDoctorsLoading());

      // Fetch doctors and all reviews in parallel
      final results = await Future.wait([
        supabase.from('doctors').select('''
          *,
          users (*),
          doctor_specialties (*)
        '''),
        supabase.from('doctor_reviews').select('doctor_id, rating'),
      ]);

      final doctorResponse = results[0] as List;
      final reviewResponse = results[1] as List;

      // Build a map: doctor_id -> {sum, count}
      final Map<String, _RatingAccum> ratingMap = {};
      for (final row in reviewResponse) {
        final doctorId = row['doctor_id'] as String?;
        final rating = (row['rating'] as num?)?.toDouble();
        if (doctorId == null || rating == null) continue;
        ratingMap.putIfAbsent(doctorId, () => _RatingAccum()).add(rating);
      }

      log(doctorResponse.toString());
      doctors = doctorResponse.map<DoctorModel>((e) {
        final model = DoctorModel.fromJson(e);
        final accum = ratingMap[model.id];
        if (accum == null || accum.count == 0) return model;
        return model.withRating(
          averageRating: accum.sum / accum.count,
          reviewCount: accum.count,
        );
      }).toList();

      _applyFilters();
    } catch (e) {
      emit(GetDoctorsFailure(errorMessage: e.toString()));
    }
  }

  /// Search doctors by name, specialty, or hospital
  void searchDoctors(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  /// Filter by specialty (pass null to clear)
  void filterBySpecialty(String? specialty) {
    _selectedSpecialty = specialty;
    _applyFilters();
  }

  /// Filter by governorate (pass null to clear)
  void filterByGovernorate(String? governorate) {
    _selectedGovernorate = governorate;
    _applyFilters();
  }

  /// Clear all filters and search
  void clearFilters() {
    _searchQuery = '';
    _selectedSpecialty = null;
    _selectedGovernorate = null;
    _applyFilters();
  }

  void _applyFilters() {
    filteredDoctors = doctors.where((doc) {
      // Text search (name, specialty, hospital)
      if (_searchQuery.isNotEmpty) {
        final name = doc.doctor?.name.toLowerCase() ?? '';
        final specialty = doc.specialty.name.toLowerCase();
        final hospital = doc.hospital.toLowerCase();
        final governorate = doc.governorate?.toLowerCase() ?? '';
        final center = doc.center?.toLowerCase() ?? '';
        final matchesSearch = name.contains(_searchQuery) ||
            specialty.contains(_searchQuery) ||
            hospital.contains(_searchQuery) ||
            governorate.contains(_searchQuery) ||
            center.contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Specialty filter
      if (_selectedSpecialty != null) {
        if (doc.specialty.name != _selectedSpecialty) return false;
      }

      // Governorate filter
      if (_selectedGovernorate != null) {
        if (doc.governorate != _selectedGovernorate) return false;
      }

      return true;
    }).toList();

    emit(DoctorsFiltered());
  }
}

class _RatingAccum {
  double sum = 0;
  int count = 0;
  void add(double rating) {
    sum += rating;
    count++;
  }
}
