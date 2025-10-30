import 'dart:async';

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

  void login(String email, String password) async {
    try {
      state = AsyncValue.loading();
      final response = await authService.login(email, password);

      state = AsyncValue.data(response);
      await $sl.get<TokenStorageService>().saveTokens(
        accessToken: response!.tokens!['access'],
        refreshToken: response.tokens!['refresh'],
      );
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
    }
  }

  void register(String email, String password, String username) async {
    try {
      state = AsyncValue.loading();
      final response = await authService.register(email, password, username);
      if (response!.error == null) {
        state = AsyncValue.data(response);
        await $sl.get<TokenStorageService>().saveTokens(
          accessToken: response.tokens!['access'],
          refreshToken: response.tokens!['refresh'],
        );
      } else {
        state = AsyncValue.error(response.error!, StackTrace.current);
      }
    } catch (e, stk) {
      state = AsyncValue.error("An unknown error occured", stk);
    }
  }
}
