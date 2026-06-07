class EmergencyContactModel {
  final String name;
  final String relationship;
  final String phone;

  EmergencyContactModel({
    required this.name,
    required this.relationship,
    required this.phone,
  });
  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) => value?.toString() ?? '';

    return EmergencyContactModel(
      name: safeString(json['name']),
      relationship: safeString(
        json['relationship'] ?? json['relation'],
      ),
      phone: safeString(json['phone']),
    );
  }
  toJson() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }
}