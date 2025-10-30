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