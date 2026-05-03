import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/agreements/agreements_list_page.dart';
import 'features/auth/auth_page.dart';
import 'features/auth/auth_providers.dart';
import 'features/main_feature.dart';
import 'features/updates/updates_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) => Navigation.goRouter(ref));

class Navigation {
  static GoRouter goRouter(Ref ref) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      initialLocation: '/main',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const AuthPage()),
        GoRoute(path: '/main', builder: (context, state) => const MainPage()),
        GoRoute(
          path: '/agreements',
          builder: (context, state) => const AgreementsListPage(),
        ),
        GoRoute(
          path: '/app_versions',
          builder: (context, state) => const AppVersionsPage(),
        ),
      ],
      refreshListenable: GoRouterAuthRiverpodRefreshStream(ref),
      redirect: (context, state) async {
        final isAuth = await ref.read(isAuthenticatedProvider.future);
        if (!isAuth) {
          return '/';
        }
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
