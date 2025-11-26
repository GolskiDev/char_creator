import 'dart:io';

import 'package:riverpod/riverpod.dart';

import '../../../services/package_info.dart';

final updateLinkProvider = FutureProvider<String?>(
  (ref) async {
    final packageInfo = await ref.watch(packageInfoProvider.future);
    final appId = packageInfo.packageName;

    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=$appId';
    } else if (Platform.isIOS) {
      return 'https://apps.apple.com/app/id$appId';
    } else {
      return null;
    }
  },
);
