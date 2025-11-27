import 'package:riverpod/riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spells_and_tools/features/app_version/models/app_version_representation.dart';

import 'app_version_state.dart';
import 'sources/current_app_version_source.dart';
import 'sources/remote_app_version_source.dart';

final isUpdateAvailableProvider = FutureProvider<bool>(
  (ref) async {
    final appVersionState = await ref.watch(appVersionStateProvider.future);
    return appVersionState.isUpdateAvailable;
  },
);

final isUpdateRequiredProvider = FutureProvider<bool>(
  (ref) async {
    final appVersionState = await ref.watch(appVersionStateProvider.future);
    return appVersionState.isForceUpdateRequired;
  },
);

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
    final currentAppVersionSource = ref.watch(currentAppVersionSourceProvider);
    final remoteSource = ref.watch(remoteAppVersionSourceProvider);
    return AppUpdateInteractor(
      currentAppVersionSource,
      remoteSource,
    );
  },
);

class AppUpdateInteractor {
  final CurrentAppVersionSource currentSource;
  final RemoteAppVersionSource remoteSource;

  AppUpdateInteractor(
    this.currentSource,
    this.remoteSource,
  );

  Future<AppVersionRepresentation> get currentAppVersion {
    return currentSource.getCurrentVersion();
  }

  Stream<UpdateVersionState> getAppVersionStateStream() async* {
    final currentVersion = await currentSource.getCurrentVersion();

    yield* Rx.combineLatest2(
      remoteSource.remoteLatestVersionStream,
      remoteSource.remoteRequiredVersionStream,
      (latestVersion, latestRequiredVersion) => UpdateVersionState(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        latestRequiredVersion: latestRequiredVersion,
      ),
    );
  }
}
