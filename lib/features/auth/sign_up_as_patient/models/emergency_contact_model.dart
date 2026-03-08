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
    return EmergencyContactModel(
      name: json['name'],
      relationship: json['relationship'],
      phone: json['phone'],
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