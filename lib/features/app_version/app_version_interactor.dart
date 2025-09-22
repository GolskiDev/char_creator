import 'package:async/async.dart';
import 'package:riverpod/riverpod.dart';

import 'app_version_state.dart';
import 'sources/current_app_version_source.dart';
import 'sources/remote_app_version_source.dart';
import 'sources/update_link_source.dart';

final appVersionStateProvider = StreamProvider<AppVersionState>(
  (ref) {
    final interactor = ref.watch(appVersionInteractorProvider);
    return interactor.getAppVersionStateStream();
  },
);

final appVersionInteractorProvider = Provider(
  (ref) {
    final updateLinkSource = ref.watch(updateLinkSourceProvider);
    return AppVersionInteractor(
      CurrentAppVersionSource(),
      RemoteAppVersionSource(
        remoteLatestVersionStream: Stream.empty(),
        remoteRequiredVersionStream: Stream.empty(),
      ),
      updateLinkSource,
    );
  },
);

class AppVersionInteractor {
  final CurrentAppVersionSource currentSource;
  final RemoteAppVersionSource remoteSource;
  final UpdateLinkSource updateLinkSource;

  AppVersionInteractor(
    this.currentSource,
    this.remoteSource,
    this.updateLinkSource,
  );

  Stream<AppVersionState> getAppVersionStateStream() async* {
    final currentVersion = await currentSource.getCurrentVersion();

    final zippedStream = StreamZip([
      remoteSource.getLatestVersionStream(),
      remoteSource.getLatestRequiredVersionStream(),
    ]);

    await for (final versions in zippedStream) {
      final latestVersion = versions[0];
      final latestRequiredVersion = versions[1];

      yield AppVersionState(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        latestRequiredVersion: latestRequiredVersion,
      );
    }
  }

  Future<String?> getUpdateLink() {
    return updateLinkSource.getUpdateLink();
  }
}
