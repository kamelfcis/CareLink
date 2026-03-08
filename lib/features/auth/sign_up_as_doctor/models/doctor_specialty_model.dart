class DoctorSpecialtyModel {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final bool isActive;
  final DateTime createdAt;

  const DoctorSpecialtyModel({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    required this.isActive,
    required this.createdAt,
  });

  factory DoctorSpecialtyModel.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialtyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
