import 'package:char_creator/features/navigation/dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../terms/data_sources/agreements_documents_data_source.dart';
import '../../terms/terms_of_service_interactor.dart';
import '../../terms/widgets/terms_and_conditions_widget.dart';

class UpdateAgreementsDialog {
  static DialogPage route({
    required BuildContext context,
    required AgreementDetails? termsOfUseDetails,
    required AgreementDetails? privacyPolicyDetails,
  }) =>
      DialogPage(
        builder: (context) {
          final title = 'Terms and Conditions Update';
          final subtitle =
              'We have updated our Terms and Conditions and Privacy Policy. Please review and accept the updated documents to continue using the app.';
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
                        context.go('/');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
}
