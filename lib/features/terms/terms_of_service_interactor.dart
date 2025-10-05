import 'dart:async';

import 'package:char_creator/features/terms/data_sources/user_accepted_agreements_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/firestore.dart';
import '../authentication/auth_controller.dart';
import 'data_sources/agreements_documents_data_source.dart';
import 'data_sources/firebase_user_accepted_agreements_data_source.dart';

final requiredTermsOfUseToAcceptProvider = StreamProvider<AgreementDetails?>(
  (ref) async* {
    final interactor = await ref.watch(agreementsInteractorProvider.future);
    if (interactor == null) {
      return;
    }
    yield* interactor
        .requiredUpdatedAgreementToAccept(AgreementType.termsOfUse);
  },
);

final requiredPrivacyPolicyToAcceptProvider = StreamProvider<AgreementDetails?>(
  (ref) async* {
    final interactor = await ref.watch(agreementsInteractorProvider.future);
    if (interactor == null) {
      return;
    }
    yield* interactor
        .requiredUpdatedAgreementToAccept(AgreementType.privacyPolicy);
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

class AgreementsSubmitter {
  Future<void> scheduleAgreement() {}
}

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
      requiredUpdatedAgreementToAccept(type).first.then((value) {
        if (value == null) {
          agreementCompleter.complete();
        }
      }).catchError((error) {
        agreementCompleter.completeError(error);
      });
      userAcceptedAgreementsDataSource.acceptAgreement(
        type: type,
        version: agreementDetails.version,
      );
    } else {
      agreementCompleter.complete();
    }
    return agreementCompleter.future;
  }

  /// Returns the latest agreement (TOS or Privacy Policy) that must be accepted, or null if none required.
  Stream<AgreementDetails?> requiredUpdatedAgreementToAccept(
      AgreementType type) async* {
    await for (final userAccepted
        in userAcceptedAgreementsDataSource.lastAcceptedAgreementStream(type)) {
      final afterDate = userAccepted?.acceptedAt;
      final now = DateTime.now();
      await for (final agreementList in agreementsDocumentsDataSource
          .getAgreementDetailsStream(type: type, after: afterDate)) {
        final candidates = agreementList
            .where((agreement) => agreement.effectiveDate.isBefore(now))
            .toList()
          ..sort((a, b) => b.effectiveDate.compareTo(a.effectiveDate));
        yield candidates.firstOrNull;
      }
    }
  }
}
