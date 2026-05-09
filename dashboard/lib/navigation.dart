import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth_providers.dart';
import 'layouts/mobile/mobile_app_shell.dart';
import 'layouts/web/auth/web_auth_page.dart';
import 'layouts/web/web_app_shell.dart';

final goRouterProvider = Provider<GoRouter>((ref) => Navigation.goRouter(ref));

bool get _isMobilePlatform =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS);

class Navigation {
  static GoRouter goRouter(Ref ref) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      initialLocation: '/main',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const WebAuthPage(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) =>
              _isMobilePlatform ? const MobileAppShell() : const WebAppShell(),
        ),
      ],
      refreshListenable: GoRouterAuthRiverpodRefreshStream(ref),
      redirect: (context, state) async {
        final isAuth = await ref.read(isAuthenticatedProvider.future);
        if (!isAuth) return '/';
        return null;
      },
    );
  }
}

class GoRouterAuthRiverpodRefreshStream extends ChangeNotifier {
  GoRouterAuthRiverpodRefreshStream(this._ref) {
    _removeListener = _ref.listen<AsyncValue<User?>>(
      authStateProvider,
      (previous, next) => notifyListeners(),
    );
  }
  final Ref _ref;
  late final ProviderSubscription<AsyncValue<User?>> _removeListener;
  @override
  void dispose() {
    _removeListener.close();
    super.dispose();
  }
}
