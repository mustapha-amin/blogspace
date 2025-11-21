import 'dart:async';
import 'dart:developer';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorageService tokenStorage;
  final String refreshEndpoint;
  final VoidCallback? onTokenExpired; // Optional logout callback

  // To avoid multiple refresh calls simultaneously
  Completer<void>? _refreshCompleter;
  bool _isRefreshing = false;

  AuthInterceptor({
    required this.dio,
    required this.tokenStorage,
    required this.refreshEndpoint,
    required this.onTokenExpired,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for refresh and login requests
    if (options.path.contains('refresh') ||
        options.path.contains('login') ||
        options.path.contains('register')) {
      return handler.next(options);
    }

    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    log('➡️ [REQUEST] ${options.method} ${options.uri}');
    if (kDebugMode && options.data != null) {
      log('   Data: ${options.data}');
    }
    log(options.headers.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      "✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}${kDebugMode ? '\n   Data: ${response.data}' : ''}",
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    log('❌ [ERROR] ${statusCode ?? "No status"} ${requestOptions.uri}');
    if (kDebugMode) {
      log('   ${err.response?.data ?? err.message}');
    }

    // Only try refresh for 401 Unauthorized on non-auth endpoints
    if (statusCode == 401 &&
        !requestOptions.path.contains('refresh') &&
        !requestOptions.path.contains('login')) {
      try {
        // If another refresh is ongoing, wait for it
        if (_isRefreshing && _refreshCompleter != null) {
          log('⏳ [WAITING] Another token refresh in progress...');
          await _refreshCompleter!.future;
        } else {
          // Start a new refresh
          _isRefreshing = true;
          _refreshCompleter = Completer<void>();

          await _refreshToken();

          _refreshCompleter!.complete();
          _isRefreshing = false;
        }

        // Retry the original request with new token
        final newToken = await tokenStorage.getAccessToken();
        if (newToken != null && newToken.isNotEmpty) {
          requestOptions.headers['Authorization'] = 'Bearer $newToken';

          log(
            '🔁 [RETRY] Retrying request with new token: ${requestOptions.uri}',
          );

          final clonedRequest = await dio.fetch(requestOptions);
          return handler.resolve(clonedRequest);
        } else {
          throw Exception('No access token available after refresh');
        }
      } on DioException catch (e) {
        log('❌ [TOKEN REFRESH FAILED] DioException: ${e.message}');
        _isRefreshing = false;
        _refreshCompleter?.completeError(e);
        _refreshCompleter = null;

        // If refresh fails, logout the user
        onTokenExpired?.call();

        return handler.next(err);
      } catch (e, s) {
        log('❌ [TOKEN REFRESH FAILED] $e\n$s');
        _isRefreshing = false;
        _refreshCompleter?.completeError(e);
        _refreshCompleter = null;

        // If refresh fails, logout the user
        onTokenExpired?.call();

        return handler.next(err);
      }
    }

    handler.next(err);
  }

  Future<void> _refreshToken() async {
    log('🔄 [REFRESHING TOKEN]');

    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('No refresh token available');
    }

    try {
      // Create a separate Dio instance for refresh to avoid interceptor loops
      final refreshDio = Dio(dio.options);

      final response = await refreshDio.post(
        refreshEndpoint,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
          // Don't follow redirects during refresh
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Handle different response formats
        final newAccessToken =
            data['accessToken'] ?? data['access_token'] ?? data['token'];
        final newRefreshToken =
            data['refreshToken'] ?? data['refresh_token'] ?? refreshToken;

        if (newAccessToken == null || newRefreshToken == null) {
          throw Exception('No access token in refresh response');
        }

        await tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        log('✅ [TOKEN REFRESHED SUCCESSFULLY]');
      } else {
        throw Exception(
          'Refresh token request failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await tokenStorage.clearTokens();
        throw Exception('Refresh token expired or invalid');
      }
      rethrow;
    }
  }
}
