import 'package:dio/dio.dart';

class UnexpectedException implements Exception {
  @override
  String toString() {
    return "An unexpected error occured";
  }
}

class NoInternetException {
  @override
  String toString() {
    return "A network error occurred. Please check your connection and try again";
  }
}

String handleDioException(DioException exp) {
  if (exp.type == DioExceptionType.connectionError) {
    return "A connection error occured. Please check your internet and try again";
  } else if (exp.type == DioExceptionType.connectionTimeout ||
      exp.type == DioExceptionType.receiveTimeout) {
    return "Connection timeout";
  } else {
    return "An unexpected error occured";
  }
}
