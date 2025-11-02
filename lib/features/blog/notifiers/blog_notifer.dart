import 'dart:async';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/blog/models/blog_response.dart';
import 'package:blogspace/features/blog/services/blog_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blogNotifierProvider = AsyncNotifierProvider<BlogNotifier, BlogResponse>(
  BlogNotifier.new,
);

class BlogNotifier extends AsyncNotifier<BlogResponse> {
  final _blogService = $sl.get<BlogService>();

  @override
  Future<BlogResponse> build() async {
    if (state is! AsyncData) {
      state = const AsyncLoading();
      return await _fetchPosts();
    }
    return state.value!;
  }

  Future<BlogResponse> _fetchPosts() async {
    try {
      final posts = await _blogService.fetchBlogPosts();
      return posts!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPosts());
  }
}
