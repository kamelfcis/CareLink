import 'package:bloc/bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'my_doctors_state.dart';

class MyDoctorsCubit extends Cubit<MyDoctorsState> {
  MyDoctorsCubit() : super(MyDoctorsInitial()) {
    getMyDoctors();
  }

  List<DoctorModel> myDoctors = [];
  final supabase = getIt<SupabaseClient>();
  final cacheHelper = getIt<CacheHelper>();

  Future<void> getMyDoctors() async {
    try {
      emit(MyDoctorsLoading());
      final patientId = cacheHelper.getPatientModel()!.id;
      final response = await supabase.from('doctor_patients').select('''
        *,
        doctors (
          *,
          users (*),
          doctor_specialties (*)
        )
      ''').eq('patient_id', patientId);

      myDoctors = (response as List)
          .map((e) => DoctorModel.fromJson(e['doctors']))
          .toList();
      emit(MyDoctorsSuccess());
    } catch (e) {
      emit(MyDoctorsFailure(errorMessage: e.toString()));
    }
  }
}








