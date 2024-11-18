abstract class RestError implements Exception {
  final String? message;

  RestError(this.message);

  @override
  String toString() {
    return 'RestError: $message';
  }
}

class UnexpectedError extends RestError {
  UnexpectedError(String? message) : super(message);
}

class BadRequestError extends RestError {
  BadRequestError(String message) : super(message);
}