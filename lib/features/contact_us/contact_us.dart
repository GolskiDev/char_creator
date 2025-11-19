import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spells_and_tools/features/authentication/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_version/app_version_interactor.dart';
// Remember to configure UrlLauncher as in pub.dev

class ContactUs {
  static Future<void> sendMail(BuildContext context, WidgetRef ref) async {
    final version = await ref.watch(currentAppVersionProvider.future);
    final user = await ref.watch(currentUserProvider.future);
    final userId = user?.uid;
    final versionString = version.toString();
    return _sendMail(
      versionName: versionString,
      userId: userId,
    );
  }

  static Future<void> _sendMail({
    required String versionName,
    required String? userId,
  }) async {
    final mail = "contact@golski.dev";
    final title = "App Support";
    final body = "Please write your message here";
    final footer = "\n\n -- Spells %26 Tools v$versionName";
    final userIdPart = userId != null ? "\nUser ID: $userId" : "";
    final url = Uri(
      scheme: 'mailto',
      path: mail,
      query: 'subject=$title&body=$body$footer$userIdPart',
    );
    await launchUrl(
      url,
    );
  }
}
