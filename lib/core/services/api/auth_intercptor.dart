import 'dart:async';
import 'dart:developer';

import 'package:blogspace/core/routes/router.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/auth/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorageService _tokenStorage;
  bool _isRefreshing = false;
  final List<Completer<void>> _refreshCompleters = [];

  AuthInterceptor(this._dio, this._tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for refresh token requests
    if (options.path.contains('refresh')) {
      return handler.next(options);
    }

    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    log('➡️ [REQUEST] ${options.method} ${options.data} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      "✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}${kDebugMode ? response.data.toString() : "Data fetched"}",
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.data == null) {
      log('❌ [ERROR] Network error or server unreachable');
      return handler.next(err);
    }

    log(
      '❌ [ERROR] ${err.response?.statusCode} ${err.requestOptions.uri} ${err.response!.data.toString()}',
    );

    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;

      if (options.path.endsWith('/refresh')) {
        _handleLogout();
        return handler.next(err);
      }

      try {
        await _handleTokenRefresh();

        final response = await _retryRequest(options);
        return handler.resolve(response);
      } catch (e) {
        log('❌ [ERROR] Failed to refresh token or retry request: $e');
        _handleLogout();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<void> _handleTokenRefresh() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshCompleters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final refreshed = await $sl.get<AuthService>().refreshTokens();
      
      if (!refreshed) {
        throw Exception('Token refresh failed');
      }

      for (final completer in _refreshCompleters) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      _refreshCompleters.clear();
    } catch (e) {
      for (final completer in _refreshCompleters) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
      _refreshCompleters.clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final token = await _tokenStorage.getAccessToken();

    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void _handleLogout() {
    for (final completer in _refreshCompleters) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Session expired'));
      }
    }
    _refreshCompleters.clear();
    _isRefreshing = false;

    $sl.get<TokenStorageService>().clearTokens();
    $sl.get<AppRouter>().replaceAll([AuthRoute()]);
  }
}