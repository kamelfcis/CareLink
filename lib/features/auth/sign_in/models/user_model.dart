class UserModel {
  final String id;
  final String name;
  final String email;
  final String image;
  final String phone;
  final String role;
  final List<String>? tokens;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.role,
    this.tokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    String safeString(dynamic value) => value?.toString() ?? '';

    return UserModel(
      id: safeString(map['id']),
      name: safeString(map['name']),
      email: safeString(map['email']),
      image: safeString(map['image']),
      phone: safeString(map['phone']),
      role: safeString(map['role']),
      tokens: List<String>.from(map['tokens'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'phone': phone,
      'role': role,
      'tokens': tokens,
    };
  }
}
