import 'dart:convert';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/patient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  //! Initialize the cache
  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  //! Save basic types
  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else {
      throw Exception('Unsupported type');
    }
  }

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  String? getDataString({required String key}) {
    return sharedPreferences.getString(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }

  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

  //! Save PatientModel in local storage
  Future<bool> savePatientModel(PatientModel patient) async {
    String userJson = jsonEncode(patient.toJson());
    return await sharedPreferences.setString('patient', userJson);
  }

  //! Get PatientModel from local storage
  PatientModel? getPatientModel() {
    String? userJson = sharedPreferences.getString('patient');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson!);
    return PatientModel.fromJson(userMap);
  }

  //! Save DoctorModel in local storage
  Future<bool> saveDoctorModel(DoctorModel doctor) async {
    String userJson = jsonEncode(doctor.toJson());
    return await sharedPreferences.setString('doctor', userJson);
  }

  //! Get DoctorModel from local storage
  DoctorModel? getDoctorModel() {
    final userJson = sharedPreferences.getString('doctor');
    if (userJson == null) return null;

    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return DoctorModel.fromJson(userMap);
  }
}
