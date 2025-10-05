import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data_sources/agreements_documents_data_source.dart';
import '../data_sources/user_accepted_agreements_data_source.dart';
import '../terms_of_service_interactor.dart';

class AgreementsWidget extends HookConsumerWidget {
  const AgreementsWidget({
    this.termsOfUseDetails,
    this.privacyPolicyDetails,
    required this.onContinue,
    super.key,
  });
  final AgreementDetails? termsOfUseDetails;
  final AgreementDetails? privacyPolicyDetails;
  final Function(BuildContext context, WidgetRef ref)? onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkboxText = htmlDeclaration(
      context: context,
      termsOfUseDetails: termsOfUseDetails,
      privacyPolicyDetails: privacyPolicyDetails,
    );

    final isSelected = useState(false);

    final listTile = ListTile(
      trailing: Checkbox(
        value: isSelected.value,
        onChanged: (value) {
          isSelected.value = value ?? false;
        },
      ),
      title: Html(
        data: checkboxText,
        onAnchorTap: (url, attributes, element) {
          if (url != null) {
            launchUrl(Uri.parse(url));
          }
        },
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        listTile,
        FilledButton(
          onPressed: isSelected.value && onContinue != null
              ? () => onContinue!(context, ref)
              : null,
          child: const Text('Continue'),
        ),
      ],
    );
  }

  String htmlDeclaration({
    required BuildContext context,
    AgreementDetails? termsOfUseDetails,
    AgreementDetails? privacyPolicyDetails,
  }) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final tosLink =
        termsOfUseDetails?.extra?['link_$languageCode'] as String? ?? '';
    final ppLink =
        privacyPolicyDetails?.extra?['link_$languageCode'] as String? ?? '';

    final String checkboxText =
        "I declare that I have read the <a href=\"$tosLink\">Terms and Conditions</a> and <a href=\"$ppLink\">Privacy Policy</a> and accept their provisions.";
    return checkboxText;
  }

  static Future<void> showTosUpdateDialog({
    required BuildContext context,
    required AgreementDetails? termsOfUseDetails,
    required AgreementDetails? privacyPolicyDetails,
  }) {
    final title = 'Terms and Conditions Update';
    final subtitle =
        'We have updated our Terms and Conditions and Privacy Policy. Please review and accept the updated documents to continue using the app.';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
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
                      final Future<void> tosFuture;
                      final Future<void> ppFuture;
                      if (termsOfUseDetails != null) {
                        tosFuture = AgreementsInteractor.waitForSignInAndAccept(
                          ref: ref,
                          type: AgreementType.termsOfUse,
                          agreementDetails: termsOfUseDetails,
                        );
                      } else {
                        tosFuture = Future.value();
                      }

                      if (privacyPolicyDetails != null) {
                        ppFuture = AgreementsInteractor.waitForSignInAndAccept(
                          ref: ref,
                          type: AgreementType.privacyPolicy,
                          agreementDetails: privacyPolicyDetails,
                        );
                      } else {
                        ppFuture = Future.value();
                      }

                      await Future.wait([tosFuture, ppFuture]);

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
