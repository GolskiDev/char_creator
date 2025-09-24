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

abstract class PrivacyPolicyDataSource {
  /// If [after] is provided, only emit policies with effectiveDate > [after].
  Stream<List<PrivacyPolicyDetails>> getPrivacyPolicyDetailsStream(
      {DateTime? after});
}
