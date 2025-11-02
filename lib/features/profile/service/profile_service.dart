import 'dart:developer';

import 'package:blogspace/core/exceptions.dart';
import 'package:blogspace/core/services/api/endpoints.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:blogspace/features/profile/models/user.dart';
import 'package:blogspace/features/profile/models/user_response.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileService {
  final _dio = $sl.get<Dio>();
  final _tokenStorage = $sl.get<TokenStorageService>();

  Future<UserResponse?> fetchUserData() async {
    try {
      final decodedData = JwtDecoder.decode(
        (await _tokenStorage.getAccessToken())!,
      );
      final userId = decodedData['userId'];

      final response = await _dio.get(Endpoints.userById(userId));
      return UserResponse.fromMap(response.data);
    } on DioException catch (e) {
      log(e.toString());
      if (e.response?.data != null) {
        final response = UserResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error!;
      } else {
        throw handleDioException(e);
      }
    } catch (e, stk) {
      log("Profile service" + e.toString(), stackTrace: stk);
      throw e.toString();
    }
  }
}
