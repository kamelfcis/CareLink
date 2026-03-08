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
//--> Variables
  List<DoctorModel> doctors = [];
  List<DoctorModel> filteredDoctors = [];
  final supabase = getIt<SupabaseClient>();

  String _searchQuery = '';
  String? _selectedSpecialty;

  String? get selectedSpecialty => _selectedSpecialty;

  /// All unique specialty names from loaded doctors
  List<String> get specialties {
    final set = <String>{};
    for (final doc in doctors) {
      set.add(doc.specialty.name);
    }
    return set.toList()..sort();
  }

//--> Methods
  // get doctors list
  getDoctorsList() async {
    try {
      emit(GetDoctorsLoading());
      final response = await supabase.from('doctors').select('''
      *,
      users (*),
      doctor_specialties (*)
    ''');
      log(response.toString());
      doctors = (response as List)
          .map<DoctorModel>((e) => DoctorModel.fromJson(e))
          .toList();
      filteredDoctors = List.from(doctors);
      emit(GetDoctorsSuccess());
    } on Exception catch (e) {
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

  /// Clear all filters and search
  void clearFilters() {
    _searchQuery = '';
    _selectedSpecialty = null;
    _applyFilters();
  }

  void _applyFilters() {
    filteredDoctors = doctors.where((doc) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final name = doc.doctor?.name.toLowerCase() ?? '';
        final specialty = doc.specialty.name.toLowerCase();
        final hospital = doc.hospital.toLowerCase();
        final matchesSearch = name.contains(_searchQuery) ||
            specialty.contains(_searchQuery) ||
            hospital.contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Specialty filter
      if (_selectedSpecialty != null) {
        if (doc.specialty.name != _selectedSpecialty) return false;
      }

      return true;
    }).toList();

    emit(DoctorsFiltered());
  }
}
