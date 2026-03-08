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
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      bio: json['bio'],
      hospital: json['hospital'],
      specialty: DoctorSpecialtyModel.fromJson(json['doctor_specialties']),
      doctor: json['users'] == null ? null : UserModel.fromJson(json['users']),
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
