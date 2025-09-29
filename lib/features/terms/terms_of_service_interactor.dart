import 'dart:async';

import 'package:char_creator/features/terms/data_sources/user_accepted_agreements_data_source.dart';
import 'package:riverpod/riverpod.dart';

import 'data_sources/agreements_documents_data_source.dart';

final requiredTermsOfUseToAcceptProvider = StreamProvider<AgreementDetails?>(
  (ref) {
    final interactor = ref.watch(agreementsInteractorProvider);
    return interactor.requiredTermsOfUseToAccept();
  },
);

final requiredPrivacyPolicyToAcceptProvider = StreamProvider<AgreementDetails?>(
  (ref) {
    final interactor = ref.watch(agreementsInteractorProvider);
    return interactor.requiredPrivacyPolicyToAccept();
  },
);

final agreementsInteractorProvider = Provider<AgreementsInteractor>(
  (ref) {
    final userAcceptedAgreementsDataSource =
        ref.watch(userAcceptedAgreementsDataSourceProvider);
    final agreementsDocumentsDataSource =
        ref.watch(agreementsDocumentsDataSourceProvider);
    return AgreementsInteractor(
      userAcceptedAgreementsDataSource: userAcceptedAgreementsDataSource,
      agreementsDocumentsDataSource: agreementsDocumentsDataSource,
    );
  },
);

class AgreementsInteractor {
  final UserAcceptedAgreementsDataSource userAcceptedAgreementsDataSource;
  final AgreementsDocumentsDataSource agreementsDocumentsDataSource;

  AgreementsInteractor({
    required this.userAcceptedAgreementsDataSource,
    required this.agreementsDocumentsDataSource,
  });

  Future<void> acceptAgreement({
    required AgreementType type,
    AgreementDetails? agreementDetails,
  }) {
    final agreementCompleter = Completer<void>();
    if (agreementDetails != null) {
      requiredTermsOfUseToAccept().first.then((value) {
        if (value == null) {
          agreementCompleter.complete();
        }
      }).catchError((error) {
        agreementCompleter.completeError(error);
      });
      userAcceptedAgreementsDataSource.acceptAgreement(
        type: AgreementType.termsOfUse,
        version: agreementDetails.version,
      );
    } else {
      agreementCompleter.complete();
    }
    return agreementCompleter.future;
  }

  /// Returns the latest TOS that must be accepted, or null if none required.
  Stream<AgreementDetails?> requiredTermsOfUseToAccept() async* {
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
  Stream<AgreementDetails?> requiredPrivacyPolicyToAccept() async* {
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
