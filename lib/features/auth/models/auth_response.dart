import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthResponse {
  String? message;
  Map<String, dynamic>? tokens;
  String? error;
  AuthResponse({
    this.message,
    this.tokens,
    this.error,
  });



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'tokens': tokens,
      'error': error,
    };
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      message: map['message'] != null ? map['message'] as String : null,
      tokens: map['tokens'] != null ? Map<String, dynamic>.from((map['tokens'] as Map<String, dynamic>)) : null,
      error: map['error'] != null ? map['error'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) => AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
