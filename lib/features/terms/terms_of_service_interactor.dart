import 'package:char_creator/features/terms/user_accepted_agreements_data_source.dart';

import 'agreements_documents_data_source.dart';

class AgreementsInteractor {
  final UserAcceptedAgreementsDataSource userAcceptedAgreementsDataSource;
  final AgreementsDocumentsDataSource agreementsDocumentsDataSource;

  AgreementsInteractor({
    required this.userAcceptedAgreementsDataSource,
    required this.agreementsDocumentsDataSource,
  });

  Future<void> acceptAgreements({
    TermsOfUseDetails? tos,
    PrivacyPolicyDetails? policy,
  }) {
    final futures = <Future>[];
    if (tos != null) {
      futures.add(userAcceptedAgreementsDataSource.acceptAgreement(
        type: AgreementType.termsOfUse,
        version: tos.version,
      ));
    }
    if (policy != null) {
      futures.add(userAcceptedAgreementsDataSource.acceptAgreement(
        type: AgreementType.privacyPolicy,
        version: policy.version,
      ));
    }
    return Future.wait(futures);
  }

  /// Returns the latest TOS that must be accepted, or null if none required.
  Stream<TermsOfUseDetails?> requiredTermsOfUseToAccept() async* {
    await for (final userAccepted in userAcceptedAgreementsDataSource
        .lastAcceptedAgreementStream(AgreementType.termsOfUse)) {
      final afterDate = userAccepted?.acceptedAt;
      final now = DateTime.now();
      await for (final tosList in agreementsDocumentsDataSource
          .getTermsOfUseDetailsStream(after: afterDate)) {
        final candidates = tosList
            .where((tos) => tos.effectiveDate.isBefore(now))
            .toList()
          ..sort((a, b) => b.effectiveDate.compareTo(a.effectiveDate));
        yield candidates.firstOrNull;
      }
    }
  }

  /// Returns the latest Privacy Policy that must be accepted, or null if none required.
  Stream<PrivacyPolicyDetails?> requiredPrivacyPolicyToAccept() async* {
    await for (final userAccepted in userAcceptedAgreementsDataSource
        .lastAcceptedAgreementStream(AgreementType.privacyPolicy)) {
      final afterDate = userAccepted?.acceptedAt;
      final now = DateTime.now();
      await for (final policyList in agreementsDocumentsDataSource
          .getPrivacyPolicyDetailsStream(after: afterDate)) {
        final candidates = policyList
            .where((policy) => policy.effectiveDate.isBefore(now))
            .toList()
          ..sort((a, b) => b.effectiveDate.compareTo(a.effectiveDate));
        yield candidates.firstOrNull;
      }
    }
  }
}
