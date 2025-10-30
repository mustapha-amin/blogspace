import 'package:blogspace/core/services/api/endpoints.dart';
import 'package:blogspace/core/routes/router.dart';
import 'package:blogspace/core/services/api/auth_intercptor.dart';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:blogspace/features/onboarding/services/onboarding_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

GetIt $sl = GetIt.instance;

Future<void> setupServices() async {
  $sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  $sl.registerLazySingleton<TokenStorageService>(() {
    return TokenStorageService($sl.get<FlutterSecureStorage>());
  });
  $sl.registerLazySingleton<OnboardingStorageService>(
    () => OnboardingStorageService($sl.get<FlutterSecureStorage>()),
  );
  $sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: Endpoints.baseUrl))
      ..interceptors.add(
        AuthInterceptor($sl.get<Dio>(), $sl.get<TokenStorageService>()),
      ),
  );
  $sl.registerSingleton<AppRouter>(AppRouter());
}
