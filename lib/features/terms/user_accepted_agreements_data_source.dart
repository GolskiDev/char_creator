class UserAcceptedAgreement {
  final String version;
  final DateTime acceptedAt;
  final AgreementType type;

  UserAcceptedAgreement({
    required this.version,
    required this.acceptedAt,
    required this.type,
  });
}

enum AgreementType {
  termsOfUse,
  privacyPolicy;
}

abstract class UserAcceptedAgreementsDataSource {
  /// Stream of the last accepted agreement for the user, or null if none.
  Stream<UserAcceptedAgreement?> lastAcceptedAgreementStream(
    AgreementType type,
  );

  Future<void> acceptAgreement({
    required String version,
    required AgreementType type,
  });
}
