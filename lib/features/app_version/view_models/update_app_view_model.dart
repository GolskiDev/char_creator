import 'package:riverpod/riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_version_interactor.dart';

final updateAppViewModelProvider = FutureProvider<UpdateAppViewModel?>(
  (ref) async {
    final appVersionInteractor = ref.watch(appVersionInteractorProvider);
    final appVersionState = await ref.watch(appVersionStateProvider.future);

    final updateLink = await appVersionInteractor.getUpdateLink();

    if (!appVersionState.isUpdateAvailable) {
      return null;
    }

    return UpdateAppViewModel(
      title: "Update Available",
      updateLink: updateLink,
    );
  },
);

class UpdateAppViewModel {
  final String title;
  final String description =
      'A new version of the app is available. Please update to the latest version for the best experience.';
  final String updateButtonText = 'Update Now';
  final String? updateLink;

  const UpdateAppViewModel({
    required this.title,
    this.updateLink,
  });

  Future<void> launchUpdateLink() {
    if (updateLink != null) {
      final uri = Uri.parse(updateLink!);
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      return Future.value();
    }
  }
}
