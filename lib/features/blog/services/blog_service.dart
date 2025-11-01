import 'package:blogspace/core/services/api/endpoints.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/blog/models/blog_response.dart';
import 'package:dio/dio.dart';

class BlogService {
  final Dio _dio = $sl.get<Dio>();

  Future<BlogResponse?> fetchBlogPosts() async {
    try {
      final response = await _dio.get(
        Endpoints.fetchPosts,
      );

      return BlogResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        // Request was cancelled, no need to throw
        return null;
      }

      if (e.response != null) {
        final response = BlogResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error ?? 'Unknown error occurred';
      } else {
        throw e.message ?? 'Network error occurred';
      }
    } catch (e) {
      throw e.toString();
    } 
  }
}
