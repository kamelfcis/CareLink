import 'package:bloc/bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'connect_with_doctor_state.dart';

class ConnectWithDoctorCubit extends Cubit<ConnectWithDoctorState> {
  ConnectWithDoctorCubit() : super(ConnectWithDoctorInitial());
  //-- variables
  final supabase = getIt<SupabaseClient>();
  final cacheHelper = getIt<CacheHelper>();
  //-- functions
  connectWithDoctor({required String doctorId}) async {
    try {
      emit(ConnectWithDoctorLoading());
      final patientId = cacheHelper.getPatientModel()!.id;
      try {
        await supabase.rpc(
          'connect_doctor_patient',
          params: {
            'p_doctor_id': doctorId,
            'p_patient_id': patientId,
          },
        );
      } catch (_) {
        // Backward-compatible fallback for environments without the RPC yet.
        await supabase.from('doctor_patients').upsert(
          {
            'doctor_id': doctorId,
            'patient_id': patientId,
          },
          onConflict: 'doctor_id,patient_id',
        );
      }
      emit(ConnectWithDoctorSuccess());
    } catch (e) {
      emit(ConnectWithDoctorFailure(message: e.toString()));
    }
  }
}
