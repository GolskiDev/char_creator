import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appIdProvider = FutureProvider<String>(
  (ref) async {
    final packageInfo = await ref.watch(packageInfoProvider.future);
    return packageInfo.packageName;
  },
);

final packageInfoProvider = FutureProvider(
  (ref) async => await PackageInfo.fromPlatform(),
);
