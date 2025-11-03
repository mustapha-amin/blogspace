import 'dart:async';
import 'package:blogspace/core/routes/router.dart';
import 'package:blogspace/core/routes/router.gr.dart';
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
    return _fetchPosts();
  }

  Future<BlogResponse> _fetchPosts() async {
    try {
      final posts = await _blogService.fetchBlogPosts();
      return posts!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> createPost({
    required String title,
    required String content,
  }) async {
    try {
      state = AsyncLoading();
      await _blogService.createPost(content, title);
      $sl.get<AppRouter>().replaceAll([BlogsRoute()]);
      ref.invalidateSelf();
    } catch (e, stk) {
      state = AsyncError(e.toString(), stk);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPosts());
  }
}
