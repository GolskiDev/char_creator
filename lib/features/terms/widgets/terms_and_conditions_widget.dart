import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data_sources/agreements_documents_data_source.dart';

class AgreementsWidget extends HookConsumerWidget {
  const AgreementsWidget({
    this.termsOfUseDetails,
    this.privacyPolicyDetails,
    required this.onContinue,
    super.key,
  });
  final AgreementDetails? termsOfUseDetails;
  final AgreementDetails? privacyPolicyDetails;
  final Future Function(BuildContext context, WidgetRef ref)? onContinue;

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

    final future = useState<Future?>(
      null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        listTile,
        FutureBuilder(
          future: future.value,
          builder: (context, snapshot) {
            return FilledButton(
              onPressed: isSelected.value && onContinue != null
                  ? () async {
                      future.value = onContinue!(context, ref);
                    }
                  : null,
              child: snapshot.connectionState == ConnectionState.waiting
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : const Text('Continue'),
            );
          },
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

  static void showTosUpdateDialog({
    required GoRouter goRouter,
    required AgreementDetails? termsOfUseDetails,
    required AgreementDetails? privacyPolicyDetails,
  }) {
    goRouter.go('/updateAgreements', extra: {
      'termsOfUseDetails': termsOfUseDetails,
      'privacyPolicyDetails': privacyPolicyDetails,
    });
  }
}
