class UserAcceptedPrivacyPolicy {
  final String version;
  final DateTime acceptedAt;

  UserAcceptedPrivacyPolicy({
    required this.version,
    required this.acceptedAt,
  });
}

abstract class UserAcceptedPrivacyPolicyDataSource {
  /// Stream of the last accepted privacy policy for the user, or null if none.
  Stream<UserAcceptedPrivacyPolicy?> lastAcceptedPrivacyPolicyStream();
}
