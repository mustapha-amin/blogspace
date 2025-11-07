import 'dart:async';

import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/blog/models/comment.dart';
import 'package:blogspace/features/blog/services/blog_service.dart';
import 'package:blogspace/shared/app_flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final commentIsLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final commentsNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<CommentsNotifier, List<Comment>, String>(CommentsNotifier.new);

class CommentsNotifier extends AsyncNotifier<List<Comment>> {
  CommentsNotifier(this.postId);
  final String postId;

  @override
  FutureOr<List<Comment>> build() {
    return $sl.get<BlogService>().fetchPostComments(postId);
  }

  Future<void> addComment(BuildContext context, String comment) async {
    List<Comment> existingComments = state.value!;
    try {
      ref.read(commentIsLoadingProvider.notifier).state = true;
      final newComment = await $sl.get<BlogService>().addComment(
        postId,
        comment,
      );
      state = AsyncData([...state.value!, newComment]);
    } catch (e) {
      state = AsyncData(existingComments);
      if (context.mounted) showCustomFlushbar(context, message: e.toString());
    } finally {
      ref.read(commentIsLoadingProvider.notifier).state = true;
    }
  }
}
