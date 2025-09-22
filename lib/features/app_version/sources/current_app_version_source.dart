import 'package:package_info_plus/package_info_plus.dart';

import '../models/app_version_representation.dart';

class CurrentAppVersionSource {
  Future<AppVersionRepresentation> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppVersionRepresentation.parse(packageInfo.version);
  }
}
