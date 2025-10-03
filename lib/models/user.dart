import 'dart:convert';

class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final UserType type;
  final String? profileImage;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.type,
    this.profileImage,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      type: UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => UserType.customer,
      ),
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'type': type.toString().split('.').last,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum UserType { customer, mechanic }