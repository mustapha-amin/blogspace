import 'dart:async';

import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/blog/models/blog_response.dart';
import 'package:blogspace/features/blog/services/blog_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blogNotifierProvider = AsyncNotifierProvider<BlogNotifer, BlogResponse>(
  () => BlogNotifer(),
);

class BlogNotifer extends AsyncNotifier<BlogResponse> {
  final _blogService = $sl.get<BlogService>();

  @override
  Future<BlogResponse> build() async {
    return _fetchPosts();
  }

  Future<BlogResponse> _fetchPosts() async {
    try {
      final posts = await _blogService.fetchBlogPosts();
      return posts!;
    } catch (e) {
      return BlogResponse(error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPosts());
  }
}
