import 'dart:developer';

import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/blog/services/blog_service.dart';
import 'package:blogspace/features/profile/models/user.dart';
import 'package:blogspace/features/profile/service/profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileNotiferProvider = AsyncNotifierProvider<ProfileNotifier, User>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<User> {
  final profileService = $sl.get<ProfileService>();

  @override
  Future<User> build() async {
    log(state.runtimeType.toString());
    final user = await profileService.fetchUserData();
    return user!.user!;
  }

  // Future<User> _fetchUser() async {
  //   try {
  //     final userResponse = await profileService.fetchUserData();
  //     return userResponse!.user!;
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }
}

final fetchUserPostsProvider = FutureProvider.autoDispose((ref) async {
  return $sl.get<BlogService>().fetchCurrentUserBlogPosts();
});
