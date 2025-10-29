import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spells_and_tools/features/terms/data_sources/user_accepted_agreements_data_source.dart';

import '../../services/firestore.dart';
import '../authentication/auth_controller.dart';
import 'data_sources/agreements_documents_data_source.dart';
import 'data_sources/firebase_user_accepted_agreements_data_source.dart';

final requiredUpdatedAgreementsProvider = StreamProvider<
    ({AgreementDetails? termsOfUse, AgreementDetails? privacyPolicy})>(
  (ref) async* {
    final interactor = await ref.watch(agreementsInteractorProvider.future);
    if (interactor == null) {
      return;
    }
    final termsOfUseStream =
        interactor.requiredUpdatedAgreementToAccept(AgreementType.termsOfUse);
    final privacyPolicyStream = interactor
        .requiredUpdatedAgreementToAccept(AgreementType.privacyPolicy);
    final zippedStream = StreamZip([
      termsOfUseStream,
      privacyPolicyStream,
    ]);
    await for (final values in zippedStream) {
      yield (
        termsOfUse: values[0],
        privacyPolicy: values[1],
      );
    }
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

final agreementSubmitterProvider = NotifierProvider<AgreementsSubmitter, void>(
  () => AgreementsSubmitter(),
);

/// Used in onboarding for new users or users that are signing in
class AgreementsSubmitter extends Notifier {
  List<AgreementDetails> agreementsToAccept = [];
  bool get isSubmitting => agreementsToAccept.isNotEmpty;

  @override
  build() {
    ref.listen(
      agreementsInteractorProvider.future,
      (previous, next) async {
        final interactor = await next;
        if (interactor == null) {
          return;
        }
        Future.wait(
          agreementsToAccept.map(
            (agreement) => interactor.acceptAgreement(
              agreementDetails: agreement,
            ),
          ),
        );
        agreementsToAccept.clear();
      },
    );
  }

  Future<void> scheduleAgreements({
    required AgreementDetails termsOfUse,
    required AgreementDetails privacyPolicy,
  }) async {
    agreementsToAccept.clear();
    agreementsToAccept.addAll([termsOfUse, privacyPolicy]);
  }
}

final updatedAgreementsSubmitterProvider =
    NotifierProvider<UpdatedAgreementsSubmitter, void>(
  () => UpdatedAgreementsSubmitter(),
);

class UpdatedAgreementsSubmitter extends Notifier {
  @override
  build() {}

  Future<void> submitAgreements({
    AgreementDetails? termsOfUse,
    AgreementDetails? privacyPolicy,
  }) async {
    try {
      List<Future<void>> futures = [];
      if (termsOfUse != null) {
        futures.add(
          AgreementsInteractor.waitForSignInAndAccept(
            ref: ref,
            agreementDetails: termsOfUse,
          ),
        );
      }
      if (privacyPolicy != null) {
        futures.add(
          AgreementsInteractor.waitForSignInAndAccept(
            ref: ref,
            agreementDetails: privacyPolicy,
          ),
        );
      }
      await Future.wait(futures);
    } catch (e) {
      print(e);
    }
  }
}

class AgreementsInteractor {
  final UserAcceptedAgreementsDataSource userAcceptedAgreementsDataSource;
  final AgreementsDocumentsDataSource agreementsDocumentsDataSource;

  AgreementsInteractor({
    required this.userAcceptedAgreementsDataSource,
    required this.agreementsDocumentsDataSource,
  });

  static Future<void> waitForSignInAndAccept({
    required Ref ref,
    required AgreementDetails? agreementDetails,
  }) async {
    final completer = Completer<void>();
    final interactor = ref.read(agreementsInteractorProvider).asData?.value;
    if (interactor != null) {
      await interactor.acceptAgreement(
        agreementDetails: agreementDetails,
      );
      return;
    }
    ref.listen(
      agreementsInteractorProvider,
      (previous, next) async {
        final previousInteractor = previous?.asData?.value;
        final nextInteractor = next.asData?.value;
        final newIsAvailable = nextInteractor != null;
        final previousIsAvailable = previousInteractor != null;
        if (previousIsAvailable && newIsAvailable) {
          return;
        }
        final interactor = nextInteractor ?? previousInteractor;
        await interactor?.acceptAgreement(
          agreementDetails: agreementDetails,
        );
        completer.complete();
      },
    );

    return completer.future;
  }

  Future<void> acceptAgreement({
    AgreementDetails? agreementDetails,
  }) async {
    if (agreementDetails != null) {
      try {
        final requiredToAccept =
            await requiredUpdatedAgreementToAccept(agreementDetails.type).first;
        if (requiredToAccept == null) {
          return;
        }
        return userAcceptedAgreementsDataSource.acceptAgreement(
          type: agreementDetails.type,
          version: agreementDetails.version,
        );
      } catch (e) {
        return;
      }
    }
    return;
  }

  /// Returns the latest agreement (TOS or Privacy Policy) that must be accepted, or null if none required.
  Stream<AgreementDetails?> requiredUpdatedAgreementToAccept(
    AgreementType type,
  ) async* {
    await for (final userAcceptedAgreement
        in userAcceptedAgreementsDataSource.lastAcceptedAgreementStream(type)) {
      final now = DateTime.now();
      await for (final agreementList
          in agreementsDocumentsDataSource.getAgreementDetailsStream(
        type: type,
      )) {
        final candidates = agreementList
            .where((agreement) => agreement.effectiveDate.isBefore(now))
            .toList()
          ..sort((a, b) => b.effectiveDate.compareTo(a.effectiveDate));
        final latest = candidates.firstOrNull;
        if (userAcceptedAgreement == null) {
          yield latest;
        }
        if (userAcceptedAgreement != null &&
            latest != null &&
            userAcceptedAgreement.version != latest.version) {
          yield latest;
        } else {
          yield null;
        }
      }
    }
  }
}
