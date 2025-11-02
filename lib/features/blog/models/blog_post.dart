// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:blogspace/features/profile/models/user.dart';

class BlogPost {
  final String? id;
  final User? user;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BlogPost({
    this.id,
    this.user,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogPost.fromMap(Map<String, dynamic>? map) {

    final content = map!['content'] as String?;
    final firstLineBreak = content?.indexOf('\n') ?? -1;

    final autoTitle = (content != null && firstLineBreak > 0)
        ? content.substring(0, firstLineBreak).trim()
        : (content != null && content.length > 50)
            ? '${content.substring(0, 47)}...'
            : content;

    return BlogPost(
      id: map['id'] as String?,
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      title: map['title'] as String? ?? autoTitle,
      content: content,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user?.toMap(),
      'title': title,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  BlogPost copyWith({
    String? id,
    User? user,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BlogPost(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'BlogPost(id: $id, user: $user, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BlogPost other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.title == title &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        title.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

}
