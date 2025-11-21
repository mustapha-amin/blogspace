import 'package:blogspace/core/exceptions.dart';
import 'package:blogspace/core/services/api/endpoints.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/blog/models/blog_post.dart';
import 'package:blogspace/features/blog/models/blog_response.dart';
import 'package:blogspace/features/blog/models/comment.dart';
import 'package:dio/dio.dart';

class BlogService {
  final Dio _dio = $sl.get<Dio>();

  Future<BlogResponse?> fetchBlogPosts() async {
    try {
      final response = await _dio.get(Endpoints.posts);

      return BlogResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        final response = BlogResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error ?? 'Unknown error occurred';
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlogResponse?> fetchCurrentUserBlogPosts() async {
    try {
      final response = await _dio.get(Endpoints.userPosts);

      return BlogResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        final response = BlogResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error ?? 'Unknown error occurred';
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> createPost(String content, String title) async {
    try {
      final response = await _dio.post(
        Endpoints.posts,
        data: {"content": content, "title": title},
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        final response = BlogResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error ?? 'Unknown error occurred';
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Comment>> fetchPostComments(String postId) async {
    try {
      final response = await _dio.get(Endpoints.fetchComments(postId));
      final data = response.data['comments'] as List<dynamic>;
      return data.map((d) => Comment.fromMap(d)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final response = BlogResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error ?? 'Unknown error occurred';
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Comment> addComment(String postId, String comment) async {
    try {
      final response = await _dio.post(Endpoints.commentOnPost(postId));
      return Comment.fromMap(response.data['comment']);
    } on DioException catch (e) {
      if (e.response != null) {
        final response = BlogResponse.fromMap(
          e.response!.data as Map<String, dynamic>,
        );
        throw response.error ?? 'Unknown error occurred';
      } else {
        throw handleDioException(e);
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
