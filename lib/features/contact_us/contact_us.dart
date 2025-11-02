import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_version/app_version_interactor.dart';
// Remember to configure UrlLauncher as in pub.dev

class ContactUs {
  static Future<void> sendMail(BuildContext context, WidgetRef ref) async {
    final version = await ref.watch(appVersionStateProvider.future);
    final versionString = version.currentVersion.toString();
    return _sendMail(versionName: versionString);
  }

  static Future<void> _sendMail({
    required String versionName,
  }) async {
    final mail = "contact@golski.dev";
    final title = "App Support";
    final body = "Please write your message here";
    final footer = "\n\n--\Spells & Tools v$versionName";
    final url = Uri(
      scheme: 'mailto',
      path: mail,
      query: 'subject=$title&body=$body$footer',
    );
    await launchUrl(
      url,
    );
  }
}
