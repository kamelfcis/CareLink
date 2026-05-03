import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'connect_with_doctor_state.dart';

class ConnectWithDoctorCubit extends Cubit<ConnectWithDoctorState> {
  ConnectWithDoctorCubit() : super(ConnectWithDoctorInitial());

  final supabase = getIt<SupabaseClient>();
  final cacheHelper = getIt<CacheHelper>();

  bool isConnected = false;

  // ── Check if patient is already connected to this doctor ─────────────────
  Future<void> checkConnection(String doctorId) async {
    try {
      emit(ConnectWithDoctorChecking());
      final patientId = cacheHelper.getPatientModel()!.id;
      final response = await supabase
          .from('doctor_patients')
          .select()
          .eq('doctor_id', doctorId)
          .eq('patient_id', patientId)
          .maybeSingle();

      isConnected = response != null;
      if (isConnected) {
        emit(ConnectWithDoctorConnected());
      } else {
        emit(ConnectWithDoctorNotConnected());
      }
    } catch (e) {
      log('checkConnection error: $e');
      isConnected = false;
      emit(ConnectWithDoctorNotConnected());
    }
  }

  // ── Connect ───────────────────────────────────────────────────────────────
  Future<void> connectWithDoctor({required String doctorId}) async {
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
        await supabase.from('doctor_patients').upsert(
          {
            'doctor_id': doctorId,
            'patient_id': patientId,
          },
          onConflict: 'doctor_id,patient_id',
        );
      }
      isConnected = true;
      emit(ConnectWithDoctorSuccess());
    } catch (e) {
      log('connectWithDoctor error: $e');
      emit(ConnectWithDoctorFailure(message: e.toString()));
    }
  }

  // ── Disconnect ────────────────────────────────────────────────────────────
  Future<void> disconnectFromDoctor({required String doctorId}) async {
    try {
      emit(ConnectWithDoctorLoading());
      final patientId = cacheHelper.getPatientModel()!.id;
      await supabase
          .from('doctor_patients')
          .delete()
          .eq('doctor_id', doctorId)
          .eq('patient_id', patientId);
      isConnected = false;
      emit(ConnectWithDoctorDisconnected());
    } catch (e) {
      log('disconnectFromDoctor error: $e');
      emit(ConnectWithDoctorFailure(message: e.toString()));
    }
  }
}
