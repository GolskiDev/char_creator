import '../models/app_version_representation.dart';

class RemoteAppVersionSource {
  final Stream<String> remoteLatestVersionStream;
  final Stream<String> remoteRequiredVersionStream;

  RemoteAppVersionSource({
    required this.remoteLatestVersionStream,
    required this.remoteRequiredVersionStream,
  });

  Stream<AppVersionRepresentation> getLatestVersionStream() {
    return remoteLatestVersionStream.map(
      (version) => AppVersionRepresentation.parse(version),
    );
  }

  Stream<AppVersionRepresentation> getLatestRequiredVersionStream() {
    return remoteRequiredVersionStream.map(
      (version) => AppVersionRepresentation.parse(version),
    );
  }
}
