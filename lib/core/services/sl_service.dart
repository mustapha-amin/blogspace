import 'package:blogspace/core/services/api/endpoints.dart';
import 'package:blogspace/core/routes/router.dart';
import 'package:blogspace/core/services/api/auth_intercptor.dart';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:blogspace/features/auth/services/auth_service.dart';
import 'package:blogspace/features/onboarding/services/onboarding_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt $sl = GetIt.instance;

Future<void> setupServices() async {
  $sl
    ..registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage())
    ..registerLazySingleton<TokenStorageService>(
      () => TokenStorageService($sl.get<FlutterSecureStorage>()),
    )
    ..registerLazySingleton<OnboardingStorageService>(
      () => OnboardingStorageService($sl.get<FlutterSecureStorage>()),
    )
    ..registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
      dio.interceptors.add(
        AuthInterceptor(dio, $sl.get<TokenStorageService>()),
      );
      return dio;
    })
    ..registerSingleton<AppRouter>(AppRouter())
    ..registerSingleton<AuthService>(AuthService());
}
