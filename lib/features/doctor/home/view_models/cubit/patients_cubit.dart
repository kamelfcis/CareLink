import 'package:bloc/bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  PatientsCubit() : super(PatientsInitial()) {
    getPatients();
  }
// -->> variavles
  List<PatientModel> patients = [];
  final supabase = getIt<SupabaseClient>();
// -->> functions
  getPatients() async {
    try {
      emit(GetPatientsLoading());
      final response = await supabase.from('doctor_patients').select('''
      *,
      patients (
        *,
          users (*)
      )
    ''').eq('doctor_id', getIt<CacheHelper>().getDoctorModel()!.id);
      patients =
          response.map((e) => PatientModel.fromJson(e['patients'])).toList();
      emit(GetPatientsSuccess());
    } catch (e) {
      emit(GetPatientsError(errorMessage: e.toString()));
    }
  }
}
