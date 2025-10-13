import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/navigation/navigation.dart';
import 'features/terms/terms_of_service_interactor.dart';
import 'features/terms/widgets/terms_and_conditions_widget.dart';
import 'firebase_options.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(
    const MainApp(),
  );
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders(
    [
      EmailAuthProvider(),
      GoogleProvider(
        clientId: 'YOUR_CLIENT_ID',
      ),
    ],
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: App(),
    );
  }
}

class App extends HookConsumerWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final isDarkModeEnabled = ref.watch(isDarkModeEnabledProvider);

    return MaterialApp.router(
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
      builder: (context, child) {
        return Consumer(
          child: child,
          builder: (_, ref, child) {
            ref.listen(
              requiredUpdatedAgreementsProvider,
              (previous, next) {
                next.whenData(
                  (agreements) {
                    if (agreements.termsOfUse != null ||
                        agreements.privacyPolicy != null) {
                      AgreementsWidget.showTosUpdateDialog(
                        goRouter: goRouter,
                        termsOfUseDetails: agreements.termsOfUse,
                        privacyPolicyDetails: agreements.privacyPolicy,
                      );
                    }
                  },
                );
              },
            );
            return child!;
          },
        );
      },
      theme: AppTheme().themeData(isDarkMode: isDarkModeEnabled),
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
