// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:blogspace/features/profile/models/user.dart';

class UserResponse {
  String? error;
  String? message;
  User? user;
  UserResponse({
    this.error,
    this.message,
    this.user,
  });

  UserResponse copyWith({
    String? error,
    String? message,
    User? user,
  }) {
    return UserResponse(
      error: error ?? this.error,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'user': user?.toMap(),
    };
  }

  factory UserResponse.fromMap(Map<String, dynamic> map) {
    return UserResponse(
      error: map['error'] != null ? map['error'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String,dynamic>) : null,
    );
  }

 
  @override
  String toString() => 'UserResponse(error: $error, message: $message, user: $user)';

  @override
  bool operator ==(covariant UserResponse other) {
    if (identical(this, other)) return true;
  
    return 
      other.error == error &&
      other.message == message &&
      other.user == user;
  }

  @override
  int get hashCode => error.hashCode ^ message.hashCode ^ user.hashCode;
}
