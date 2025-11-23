import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../authentication/auth_controller.dart';
import '../terms/terms_of_service_interactor.dart';

class RedirectManager {
  static Future<String?> getRedirectPath({
    required BuildContext context,
    required GoRouterState state,
    required Ref ref,
  }) async {
    final isUserSignedIn = await ref.read(
      isUserSignedInProvider.future,
    );
    if (!isUserSignedIn) {
      return '/onboarding';
    }

    final requiredAgreements =
        await ref.read(requiredUpdatedAgreementsProvider.future);
    final agreementsAreCurrentlySubmitted =
        ref.read(agreementSubmitterProvider.notifier).isSubmitting;
    if (!agreementsAreCurrentlySubmitted &&
        (requiredAgreements.termsOfUse != null ||
            requiredAgreements.privacyPolicy != null)) {
      return '/updateAgreements';
    }
    return null;
  }
}
