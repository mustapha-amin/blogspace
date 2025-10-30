import 'dart:developer';

import 'package:blogspace/core/routes/router.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:dio/dio.dart';
import 'package:blogspace/core/services/token_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorageService _tokenStorage;

  bool _isRefreshing = false;

  AuthInterceptor(this._dio, this._tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    log('➡️ [REQUEST] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      "✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri} ${response.data.toString().substring(0, 10)}",
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log(
      '❌ [ERROR] ${err.response?.statusCode} ${err.requestOptions.uri} ${err.response!.data.toString()}',
    );

    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken == null) {
          _handleLogout();
          return handler.next(err);
        }
      } catch (e) {
        _isRefreshing = false;
        _handleLogout();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  void _handleLogout() {
    $sl.get<TokenStorageService>().clearTokens();
    $sl.get<AppRouter>().replaceAll([AuthRoute()]);
  }
}
