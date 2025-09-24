import 'privacy_policy_data_source.dart';
import 'terms_of_use_data_source.dart';
import 'terms_of_use_details.dart';
import 'user_accepted_privacy_policy_data_source.dart';
import 'user_accepted_terms_data_source.dart';

class TermsOfServiceInteractor {
  final UserAcceptedTermsDataSource userAcceptedTermsDataSource;
  final UserAcceptedPrivacyPolicyDataSource userAcceptedPrivacyPolicyDataSource;
  final TermsOfUseDataSource termsOfUseDataSource;
  final PrivacyPolicyDataSource privacyPolicyDataSource;

  TermsOfServiceInteractor({
    required this.userAcceptedTermsDataSource,
    required this.userAcceptedPrivacyPolicyDataSource,
    required this.termsOfUseDataSource,
    required this.privacyPolicyDataSource,
  });

  /// Returns the latest TOS that must be accepted, or null if none required.
  Stream<TermsOfUseDetails?> requiredTermsOfUseToAccept() async* {
    await for (final userAccepted
        in userAcceptedTermsDataSource.lastAcceptedTermsStream()) {
      final afterDate = userAccepted?.acceptedAt;
      final now = DateTime.now();
      await for (final tosList in termsOfUseDataSource
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
    await for (final userAccepted in userAcceptedPrivacyPolicyDataSource
        .lastAcceptedPrivacyPolicyStream()) {
      final afterDate = userAccepted?.acceptedAt;
      final now = DateTime.now();
      await for (final policyList in privacyPolicyDataSource
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
