import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String? id;
  final String? email;
  final String? username;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'email': email,
      'username': username,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] != null ? map['_id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }
}
