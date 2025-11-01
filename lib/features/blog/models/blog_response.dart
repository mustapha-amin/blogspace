import 'dart:convert';

import 'package:blogspace/features/blog/models/blog_post.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BlogResponse {
  String? message;
  List<BlogPost>? posts;
  String? error;
  BlogResponse({this.message, this.posts, this.error});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'posts': posts,
      'error': error,
    };
  }

  factory BlogResponse.fromMap(Map<String, dynamic> map) {
    return BlogResponse(
      message: map['message'] != null ? map['message'] as String : null,
      posts: map['posts'] != null
          ? (map['posts'] as List<dynamic>)
                .map((e) => BlogPost.fromMap(e))
                .toList()
          : null,
      error: map['error'] != null ? map['error'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogResponse.fromJson(String source) =>
      BlogResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
