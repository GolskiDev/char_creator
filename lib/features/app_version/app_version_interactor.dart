import 'package:async/async.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spells_and_tools/features/app_version/models/app_version_representation.dart';

import 'app_version_state.dart';
import 'sources/current_app_version_source.dart';
import 'sources/remote_app_version_source.dart';
import 'sources/update_link_source.dart';

final appVersionStateProvider = StreamProvider<UpdateVersionState>(
  (ref) {
    final interactor = ref.watch(appVersionInteractorProvider);
    return interactor.getAppVersionStateStream();
  },
);

final currentAppVersionProvider = FutureProvider<AppVersionRepresentation>(
  (ref) {
    final interactor = ref.watch(appVersionInteractorProvider);
    return interactor.currentAppVersion;
  },
);

final currentAppVersionSourceProvider = Provider(
  (ref) => CurrentAppVersionSource(),
);

final appVersionInteractorProvider = Provider(
  (ref) {
    final updateLinkSource = ref.watch(updateLinkSourceProvider);
    final currentAppVersionSource = ref.watch(currentAppVersionSourceProvider);
    return AppUpdateInteractor(
      currentAppVersionSource,
      RemoteAppVersionSource(
        remoteLatestVersionStream: Stream.empty(),
        remoteRequiredVersionStream: Stream.empty(),
      ),
      updateLinkSource,
    );
  },
);

class AppUpdateInteractor {
  final CurrentAppVersionSource currentSource;
  final RemoteAppVersionSource remoteSource;
  final UpdateLinkSource updateLinkSource;

  AppUpdateInteractor(
    this.currentSource,
    this.remoteSource,
    this.updateLinkSource,
  );

  Future<AppVersionRepresentation> get currentAppVersion {
    return currentSource.getCurrentVersion();
  }

  Stream<UpdateVersionState> getAppVersionStateStream() async* {
    final currentVersion = await currentSource.getCurrentVersion();

    final zippedStream = StreamZip([
      remoteSource.getLatestVersionStream(),
      remoteSource.getLatestRequiredVersionStream(),
    ]);

    await for (final versions in zippedStream) {
      final latestVersion = versions[0];
      final latestRequiredVersion = versions[1];

      yield UpdateVersionState(
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
