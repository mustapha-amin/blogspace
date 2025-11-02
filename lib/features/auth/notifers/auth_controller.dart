import 'dart:async';

import 'package:blogspace/core/routes/router.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:blogspace/features/auth/models/auth_response.dart';
import 'package:blogspace/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider =
    NotifierProvider.autoDispose<AuthNotifier, AsyncValue<AuthResponse?>>(
      AuthNotifier.new,
    );

class AuthNotifier extends Notifier<AsyncValue<AuthResponse?>> {
  final authService = $sl.get<AuthService>();
  @override
  build() {
    return AsyncValue.data(null);
  }

  void login({required String email, required String password}) async {
    try {
      state = AsyncValue.loading();
      final response = await authService.login(
        email: email,
        password: password,
      );

      await $sl.get<TokenStorageService>().saveTokens(
        accessToken: response!.tokens!['access'],
        refreshToken: response.tokens!['refresh'],
      );
      state = AsyncValue.data(response);
      $sl.get<AppRouter>().replaceAll([BlogsRoute()]);
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
    }
  }

  void register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      state = AsyncValue.loading();
      final response = await authService.register(
        email: email,
        password: password,
        username: username,
      );

      await $sl.get<TokenStorageService>().saveTokens(
        accessToken: response!.tokens!['access'],
        refreshToken: response.tokens!['refresh'],
      );
      state = AsyncValue.data(response);
      $sl.get<AppRouter>().replaceAll([BlogsRoute()]);
    } catch (e, stk) {
      state = AsyncValue.error("An unknown error occured", stk);
    }
  }

  void logout() async {
    try {
      state = AsyncLoading();
      await authService.logout();
      await $sl.get<TokenStorageService>().clearTokens();
      await $sl.get<AppRouter>().replaceAll([AuthRoute()]);
    } catch (e, stk) {
      state = AsyncValue.error("An unknown error occured", stk);
    }
  }
}
