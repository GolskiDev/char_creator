import 'package:url_launcher/url_launcher.dart';
// Remember to configure UrlLauncher as in pub.dev

class ContactUs {
  static sendMail() {
    final mail = "support@example.com";
    final title = "App Support";
    final body = "Please write your message here";
    final footer = "\n\n--\nAppName v1.0.0";
    final url = Uri(
      scheme: 'mailto',
      path: mail,
      query: 'subject=$title&body=$body$footer',
    );
    launchUrl(
      url,
    );
  }
}
