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
