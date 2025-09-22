import 'dart:io';

import 'package:char_creator/services/package_info.dart';
import 'package:riverpod/riverpod.dart';

final updateLinkSourceProvider = Provider(
  (ref) {
    return UpdateLinkSource(
      androidPackageNameFuture: ref.read(appIdProvider.future),
    );
  },
);

class UpdateLinkSource {
  // TODO: Replace with your app's Apple ID
  static String iOSAppId = '';

  final Future<String> androidPackageNameFuture;

  UpdateLinkSource({
    required this.androidPackageNameFuture,
  });

  Future<String?> getUpdateLink() async {
    if (Platform.isIOS) {
      return 'https://apps.apple.com/app/id$iOSAppId';
    }
    if (Platform.isAndroid) {
      final androidPackageName = await androidPackageNameFuture;
      return 'market://details?id=$androidPackageName';
    }
    return null;
  }
}
