import 'package:char_creator/features/terms/terms_of_service_interactor.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../views/default_page_wrapper.dart';
import '../../terms/data_sources/user_accepted_agreements_data_source.dart';
import '../../terms/new_user_terms.dart';
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
    final termsOfUseFuture = ref.watch(
        latestEffectiveAgreementStreamProvider(AgreementType.termsOfUse)
            .future);
    final privacyPolicyFuture = ref.watch(
        latestEffectiveAgreementStreamProvider(AgreementType.privacyPolicy)
            .future);
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  child: Center(
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/ui/contract.png',
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: AgreementsWidget(
                    termsOfUseDetails: tos,
                    privacyPolicyDetails: privacyPolicy,
                    onContinue: (context, ref) async {
                      await ref
                          .read(agreementSubmitterProvider.notifier)
                          .scheduleAgreements(
                            termsOfUse: tos!,
                            privacyPolicy: privacyPolicy!,
                          );
                      if (!context.mounted) {
                        return;
                      }
                      onAccepted(context, ref);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
