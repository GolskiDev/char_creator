// Re-export from feature layer.
// The app versions page has no web-specific layout changes.
import 'package:flutter/material.dart';
import '../../../features/updates/updates_page.dart';

class WebAppVersionsPage extends StatelessWidget {
  const WebAppVersionsPage({super.key});

  @override
  Widget build(BuildContext context) => const AppVersionsPage();
}
