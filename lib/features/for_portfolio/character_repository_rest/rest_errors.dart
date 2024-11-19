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
