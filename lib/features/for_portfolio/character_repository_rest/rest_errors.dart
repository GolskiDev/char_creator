// In cases where the server returns response
sealed class RestError implements Exception {
  final String? message;

  RestError(this.message);

  @override
  String toString() {
    return 'RestError: $message';
  }
}

class UnexpectedError extends RestError {
  UnexpectedError(super.message);
}

class BadRequestError extends RestError {
  BadRequestError(super.message);
}

class NotFoundError extends RestError {
  NotFoundError(super.message);
}

class InternalServerError extends RestError {
  InternalServerError(super.message);
}

class RequestTimeoutError extends RestError {
  RequestTimeoutError(super.message);
}
