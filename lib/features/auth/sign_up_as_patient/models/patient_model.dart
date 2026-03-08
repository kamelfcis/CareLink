import 'package:care_link/features/auth/sign_in/models/user_model.dart';
import 'package:care_link/features/auth/sign_up_as_patient/models/emergency_contact_model.dart';

class PatientModel {
  final String id;
  final String gender;
  final double weight;
  final double height;
  final EmergencyContactModel emergencyContact;
  final UserModel? patient;
  final String dateOfBirth;
  final String bloodType;
  PatientModel({
    required this.id,
    required this.gender,
    required this.weight,
    required this.height,
    required this.emergencyContact,
    this.patient,
    required this.dateOfBirth,
    required this.bloodType,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? '', // لو null نحط ''
      gender: json['gender'] ?? 'unknown',
      weight: double.tryParse(json['weight_kg']?.toString() ?? '0.0') ?? 0.0,
      height: double.tryParse(json['height_cm']?.toString() ?? '0.0') ?? 0.0,
      emergencyContact: json['emergency_contact'] != null
          ? EmergencyContactModel.fromJson(json['emergency_contact'])
          : EmergencyContactModel(
              name: '', phone: '', relationship: ""), // قيم افتراضية
      patient: json['users'] != null ? UserModel.fromJson(json['users']) : null,
      dateOfBirth: json['date_of_birth'] ?? '', // أهم سطر
      bloodType: json['blood_type'] ?? 'Unknown',
    );
  }
  toJson() {
    return {
      'id': id,
      'gender': gender,
      'weight_kg': weight,
      'height_cm': height,
      'emergency_contact': emergencyContact.toJson(),
      'users': patient?.toJson(),
      'date_of_birth': dateOfBirth,
      'blood_type': bloodType
    };
  }

  copyWith(
      {String? id,
      String? gender,
      double? weight,
      double? height,
      EmergencyContactModel? emergencyContact,
      UserModel? patient,
      String? dateOfBirth,
      String? bloodType}) {
    return PatientModel(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      patient: patient ?? this.patient,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodType: bloodType ?? this.bloodType,
    );
  }
}
