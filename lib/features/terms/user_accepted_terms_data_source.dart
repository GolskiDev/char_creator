class UserAcceptedTerms {
  final String version;
  final DateTime acceptedAt;

  UserAcceptedTerms({
    required this.version,
    required this.acceptedAt,
  });
}

abstract class UserAcceptedTermsDataSource {
  /// Stream of the last accepted terms for the user, or null if none.
  Stream<UserAcceptedTerms?> lastAcceptedTermsStream();
}
