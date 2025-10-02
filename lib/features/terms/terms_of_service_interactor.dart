import 'dart:async';

import 'package:char_creator/features/terms/data_sources/user_accepted_agreements_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/firestore.dart';
import '../authentication/auth_controller.dart';
import 'data_sources/agreements_documents_data_source.dart';
import 'data_sources/firebase_user_accepted_agreements_data_source.dart';

final latestEffectiveTermsOfUseProvider =
    StreamProvider<AgreementDetails?>((ref) async* {
  final interactor = await ref.watch(agreementsInteractorProvider.future);
  if (interactor == null) {
    return;
  }
  yield* interactor.requiredUpdatedTermsOfUseToAccept();
});

final latestEffectivePrivacyPolicyProvider =
    StreamProvider<AgreementDetails?>((ref) async* {
  final interactor = await ref.watch(agreementsInteractorProvider.future);
  if (interactor == null) {
    return;
  }
  yield* interactor.requiredUpdatedPrivacyPolicyToAccept();
});

final requiredTermsOfUseToAcceptProvider = StreamProvider<AgreementDetails?>(
  (ref) async* {
    final interactor = await ref.watch(agreementsInteractorProvider.future);
    if (interactor == null) {
      return;
    }
    yield* interactor.requiredUpdatedTermsOfUseToAccept();
  },
);

final requiredPrivacyPolicyToAcceptProvider = StreamProvider<AgreementDetails?>(
  (ref) async* {
    final interactor = await ref.watch(agreementsInteractorProvider.future);
    if (interactor == null) {
      return;
    }
    yield* interactor.requiredUpdatedPrivacyPolicyToAccept();
  },
);

final userAcceptedAgreementsDataSourceProvider =
    FutureProvider<UserAcceptedAgreementsDataSource?>(
  (ref) async {
    final firestore = ref.watch(firestoreProvider);
    final userId = await ref.watch(currentUserProvider.selectAsync(
      (data) => data?.uid,
    ));
    if (userId == null) {
      return null;
    }
    return FirebaseUserAcceptedAgreementsDataSource(
      uid: userId,
      firestore: firestore,
    );
  },
);

final agreementsInteractorProvider = FutureProvider<AgreementsInteractor?>(
  (ref) async {
    final userAcceptedAgreementsDataSource =
        await ref.watch(userAcceptedAgreementsDataSourceProvider.future);
    final agreementsDocumentsDataSource =
        ref.watch(agreementsDocumentsDataSourceProvider);

    if (userAcceptedAgreementsDataSource == null) {
      return null;
    }

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

  static Future<void> waitForSignInAndAccept({
    required WidgetRef ref,
    required AgreementType type,
    required AgreementDetails? agreementDetails,
  }) async {
    final completer = Completer<void>();
    ref.listen(
      agreementsInteractorProvider.future,
      (previous, next) async {
        final interactor = await next;
        if (interactor == null) {
          return;
        }
        await interactor.acceptAgreement(
          type: type,
          agreementDetails: agreementDetails,
        );
        completer.complete();
      },
    );

    return completer.future;
  }

  Future<void> acceptAgreement({
    required AgreementType type,
    AgreementDetails? agreementDetails,
  }) async {
    final agreementCompleter = Completer<void>();
    if (agreementDetails != null) {
      requiredUpdatedTermsOfUseToAccept().first.then((value) {
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
  Stream<AgreementDetails?> requiredUpdatedTermsOfUseToAccept() async* {
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
  Stream<AgreementDetails?> requiredUpdatedPrivacyPolicyToAccept() async* {
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
