// Re-export from feature layer.
// The agreements page has no web-specific layout changes.
export '../../../features/agreements/agreements_list_page.dart'
    show AgreementsListPage;

// Alias so web_app_shell.dart can import WebAgreementsPage.
import 'package:flutter/material.dart';
import '../../../features/agreements/agreements_list_page.dart';

class WebAgreementsPage extends StatelessWidget {
  const WebAgreementsPage({super.key});

  @override
  Widget build(BuildContext context) => const AgreementsListPage();
}
