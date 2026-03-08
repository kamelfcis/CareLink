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
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      image: map['image'] as String,
      phone: map['phone'] as String,
      role: map['role'] as String,
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
