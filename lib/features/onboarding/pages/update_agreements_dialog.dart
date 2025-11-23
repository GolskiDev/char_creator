import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spells_and_tools/features/navigation/dialog_route.dart';

import '../../terms/terms_of_service_interactor.dart';
import '../../terms/widgets/terms_and_conditions_widget.dart';

class UpdateAgreementsDialog {
  static DialogPage route({
    required BuildContext context,
  }) {
    return DialogPage(
      barrierDismissible: false,
      builder: (context) {
        final title = 'Terms and Conditions Update';
        final subtitle =
            'We have updated our Terms and Conditions and Privacy Policy. Please review and accept the updated documents to continue using the app.';
        return Consumer(
          builder: (context, ref, child) {
            final termsOfUseDetails =
                ref.watch(requiredUpdatedAgreementsProvider).asData?.value.termsOfUse;
            final privacyPolicyDetails =
                ref.watch(requiredUpdatedAgreementsProvider).asData?.value.privacyPolicy;
            return AlertDialog(
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  children: [
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                    ),
                    AgreementsWidget(
                      termsOfUseDetails: termsOfUseDetails,
                      privacyPolicyDetails: privacyPolicyDetails,
                      onContinue: (context, ref) async {
                        await ref
                            .read(
                              updatedAgreementsSubmitterProvider.notifier,
                            )
                            .submitAgreements(
                              privacyPolicy: privacyPolicyDetails,
                              termsOfUse: termsOfUseDetails,
                            );
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
