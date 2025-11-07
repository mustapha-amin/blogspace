import 'package:blogspace/features/profile/models/user.dart';

class Comment {
  final String? id;
  final String? postId;
  final String? comment;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.id,
    required this.postId,
    required this.comment,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Comment from JSON
  factory Comment.fromMap(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String?,
      postId: json['postId'] as String?,
      comment: json['comment'] as String?,
      user: json['user'] != null ? User.fromMap(json['user']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert Comment to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'comment': comment,
      'user': user?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
