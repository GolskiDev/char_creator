class TermsOfUseDetails {
  final DateTime effectiveDate;
  final String version;
  final Map<String, dynamic>? extra;

  TermsOfUseDetails({
    required this.effectiveDate,
    required this.version,
    this.extra,
  });
}

class PrivacyPolicyDetails {
  final DateTime effectiveDate;
  final String version;
  final Map<String, dynamic>? extra;

  PrivacyPolicyDetails({
    required this.effectiveDate,
    required this.version,
    this.extra,
  });
}

abstract class AgreementsDocumentsDataSource {
  /// If [after] is provided, only emit TOS with effectiveDate > [after].
  Stream<List<TermsOfUseDetails>> getTermsOfUseDetailsStream({DateTime? after});

  /// If [after] is provided, only emit privacy policies with effectiveDate > [after].
  Stream<List<PrivacyPolicyDetails>> getPrivacyPolicyDetailsStream(
      {DateTime? after});
}
