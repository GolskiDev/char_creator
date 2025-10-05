import 'package:char_creator/features/terms/terms_of_service_interactor.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../views/default_page_wrapper.dart';
import '../../terms/data_sources/user_accepted_agreements_data_source.dart';
import '../../terms/widgets/terms_and_conditions_widget.dart';

class ConsentsPage extends HookConsumerWidget {
  final Function(
    BuildContext context,
    WidgetRef ref,
  ) onAccepted;

  const ConsentsPage({
    required this.onAccepted,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsOfUseFuture =
        ref.watch(requiredTermsOfUseToAcceptProvider.future);
    final privacyPolicyFuture =
        ref.watch(requiredPrivacyPolicyToAcceptProvider.future);
    final together = Future.wait(
      [
        termsOfUseFuture,
        privacyPolicyFuture,
      ],
    );
    return Scaffold(
      body: DefaultPageWrapper(
        future: together,
        builder: (BuildContext context, data) {
          final tos = data[0];
          final privacyPolicy = data[1];
          return AgreementsWidget(
            termsOfUseDetails: tos,
            privacyPolicyDetails: privacyPolicy,
            onContinue: (context, ref) {
              AgreementsInteractor.waitForSignInAndAccept(
                ref: ref,
                type: AgreementType.termsOfUse,
                agreementDetails: tos,
              );
              AgreementsInteractor.waitForSignInAndAccept(
                ref: ref,
                type: AgreementType.privacyPolicy,
                agreementDetails: privacyPolicy,
              );
              onAccepted(context, ref);
            },
          );
        },
      ),
    );
  }
}
