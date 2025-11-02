abstract class Endpoints {
  // static const baseUrl = "localhost:3001/api/v1/";
  static const baseUrl = "http://10.0.2.2:3001/api/v1";

  static const auth = "$baseUrl/auth";
  static const register = "$auth/register";
  static const login = "$auth/login";
  static const logout = "$auth/logout";
  static const refresh = "$auth/refresh";

  static const posts = "$baseUrl/posts";

  static String userById(String id) => "$baseUrl/users/$id";  
  static String fetchComments(String postId) => "$posts/$postId/comments";
  static String commentOnPost(String postId) => "$posts/$postId/comment";
  static String deletePost(String postId) => "$posts/$postId";
}
