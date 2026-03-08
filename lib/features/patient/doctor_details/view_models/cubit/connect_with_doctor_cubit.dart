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
      await supabase.from('doctor_patients').insert({
        'doctor_id': doctorId,
        'patient_id': cacheHelper.getPatientModel()!.id,
      });
      emit(ConnectWithDoctorSuccess());
    } catch (e) {
      emit(ConnectWithDoctorFailure(message: e.toString()));
    }
  }
}
