sealed class RemoteRepositoryError implements Exception {
  final String? message;

  RemoteRepositoryError(this.message);

  @override
  String toString() {
    return 'RemoteRepositoryError: $message';
  }
}

class UnexpectedError extends RemoteRepositoryError {
  UnexpectedError(super.message);
}

class RequestTimeoutError extends RemoteRepositoryError {
  RequestTimeoutError(super.message);
}

class ConnectionError extends RemoteRepositoryError {
  ConnectionError(super.message);
}

class BadResponseError extends RemoteRepositoryError {
  BadResponseError(super.message);
}

class BadCertificateError extends RemoteRepositoryError {
  BadCertificateError(super.message);
}

class RequestCancelledError extends RemoteRepositoryError {
  RequestCancelledError(super.message);
}

class UnknownError extends RemoteRepositoryError {
  UnknownError(super.message);
}