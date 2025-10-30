import 'dart:developer';

import 'package:blogspace/core/services/api/endpoints.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/auth/models/auth_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = $sl.get<Dio>();

  Future<AuthResponse?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        Endpoints.login,
        data: {"email": email, "password": password},
      );
      final data = response.data as Map<String, dynamic>;
      return AuthResponse.fromMap(data);
    } on DioException catch (e) {
      if (e.response != null) {
        final response = AuthResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error!;
      } else {
        throw e.toString();
      }
    }
  }

  Future<AuthResponse?> register(
    String email,
    String username,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.register,
        data: {"email": email, "password": password, "username": username},
      );
      final data = response.data as Map<String, dynamic>;
      return AuthResponse.fromMap(data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AuthResponse.fromMap(e.response!.data as Map<String, dynamic>);
      } else {
        return AuthResponse(error: e.toString());
      }
    }
  }

  Future<AuthResponse?> logout() async {}
}
