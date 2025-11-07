// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:blogspace/features/blog/models/comment.dart';

class CommentResponse {
  String? message;
  List<Comment>? comments;
  String? error;
  CommentResponse({this.message, this.comments, this.error});

  CommentResponse copyWith({
    String? message,
    List<Comment>? comments,
    String? error,
  }) {
    return CommentResponse(
      message: message ?? this.message,
      comments: comments ?? this.comments,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'comments': comments?.map((x) => x.toMap()).toList(),
      'error': error,
    };
  }

  factory CommentResponse.fromMap(Map<String, dynamic> map) {
    return CommentResponse(
      message: map['message'] != null ? map['message'] as String : null,
      comments: map['comments'] != null
          ? List<Comment>.from(
              (map['comments'] as List<dynamic>).map((e) => Comment.fromMap(e)),
            )
          : null,
      error: map['error'] != null ? map['error'] as String : null,
    );
  }

  @override
  String toString() =>
      'CommentResponse(message: $message, comments: $comments, error: $error)';

  @override
  bool operator ==(covariant CommentResponse other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        listEquals(other.comments, comments) &&
        other.error == error;
  }

  @override
  int get hashCode => message.hashCode ^ comments.hashCode ^ error.hashCode;
}
