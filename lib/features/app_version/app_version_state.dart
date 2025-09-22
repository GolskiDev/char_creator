import 'models/app_version_representation.dart';

class AppVersionState {
  final AppVersionRepresentation currentVersion;
  final AppVersionRepresentation? latestVersion;
  final AppVersionRepresentation? latestRequiredVersion;

  AppVersionState({
    required this.currentVersion,
    required this.latestVersion,
    required this.latestRequiredVersion,
  });

  bool get isUpdateAvailable => (latestVersion?.compareTo(currentVersion) ?? -1) > 0;
  bool get isForceUpdateRequired =>
      (latestRequiredVersion?.compareTo(currentVersion) ?? -1) > 0;
}
