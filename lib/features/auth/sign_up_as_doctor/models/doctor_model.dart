import 'package:care_link/features/auth/sign_in/models/user_model.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_specialty_model.dart';

class DoctorModel {
  final String id;
  final String bio;
  final String hospital;
  final DoctorSpecialtyModel specialty;
  final UserModel? doctor;
  DoctorModel({
    required this.id,
    required this.bio,
    required this.hospital,
    required this.specialty,
    this.doctor,
  });
  static UserModel? _parseNestedUser(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) {
      return UserModel.fromJson(raw);
    }
    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(raw.first as Map));
    }
    return null;
  }

  static Map<String, dynamic>? _parseSpecialtyJson(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return Map<String, dynamic>.from(raw.first as Map);
    }
    return null;
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final specialtyJson = _parseSpecialtyJson(json['doctor_specialties']);
    if (specialtyJson == null) {
      throw FormatException('doctor_specialties missing or invalid');
    }
    return DoctorModel(
      id: json['id'],
      bio: json['bio'],
      hospital: json['hospital'],
      specialty: DoctorSpecialtyModel.fromJson(specialtyJson),
      doctor: _parseNestedUser(json['users']),
    );
  }
  toJson() {
    return {
      'id': id,
      'bio': bio,
      'hospital': hospital,
      'doctor_specialties': specialty.toJson(),
      'users': doctor?.toJson(),
    };
  }

  copyWith({
    String? id,
    String? bio,
    String? hospital,
    DoctorSpecialtyModel? specialty,
    UserModel? doctor,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      bio: bio ?? this.bio,
      hospital: hospital ?? this.hospital,
      specialty: specialty ?? this.specialty,
      doctor: doctor ?? this.doctor,
    );
  }
}
