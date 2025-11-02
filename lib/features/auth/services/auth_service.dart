import 'dart:developer';

import 'package:blogspace/core/exceptions.dart';
import 'package:blogspace/core/services/api/endpoints.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:blogspace/features/auth/models/auth_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = $sl.get<Dio>();

  Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.login,
        data: {"email": email, "password": password},
      );
      final data = response.data as Map<String, dynamic>;
      return AuthResponse.fromMap(data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final response = AuthResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error!;
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw UnexpectedException().toString();
    }
  }

  Future<AuthResponse?> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.register,

        data: {"email": email, "password": password, "username": username},
      );
      final data = response.data as Map<String, dynamic>;
      return AuthResponse.fromMap(data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final response = AuthResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error!;
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw UnexpectedException().toString();
    }
  }

  Future<bool> refreshTokens() async {
    final refreshToken = await $sl.get<TokenStorageService>().getRefreshToken();
    try {
      final response = await _dio.post(
        Endpoints.refresh,
        data: {'refresh': refreshToken},
      );
      final data = AuthResponse.fromMap(response.data as Map<String, dynamic>);
      await $sl.get<TokenStorageService>().saveTokens(
        accessToken: data.tokens!['access'],
        refreshToken: data.tokens!['refresh'],
      );
      return true;
    } catch (e) {
      throw UnexpectedException().toString();
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await $sl
          .get<TokenStorageService>()
          .getRefreshToken();
      await _dio.post(Endpoints.refresh, data: {'refresh': refreshToken});
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final response = AuthResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error!;
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw UnexpectedException().toString();
    }
  }
}
