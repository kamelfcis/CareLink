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

  static UserModel? _parseNestedUser(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) return UserModel.fromJson(raw);
    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(raw.first as Map));
    }
    return null;
  }

  static EmergencyContactModel _parseEmergency(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return EmergencyContactModel.fromJson(raw);
    }
    return EmergencyContactModel(name: '', phone: '', relationship: '');
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? '', // لو null نحط ''
      gender: json['gender'] ?? 'unknown',
      weight: double.tryParse(json['weight_kg']?.toString() ?? '0.0') ?? 0.0,
      height: double.tryParse(json['height_cm']?.toString() ?? '0.0') ?? 0.0,
      emergencyContact: _parseEmergency(json['emergency_contact']),
      patient: _parseNestedUser(json['users']),
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
