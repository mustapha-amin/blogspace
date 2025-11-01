// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String username;

  const User({required this.id, required this.username});

  User copyWith({String? id, String? username}) {
    return User(id: id ?? this.id, username: username ?? this.username);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'username': username};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(id: map['id'] as String, username: map['username'] as String);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(id: $id, username: $username)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id && other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode;
}
