import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/srd_license.dart';

import 'features/5e/spells/view_models/spell_view_model.dart';
import 'features/navigation/navigation.dart';
import 'features/terms/terms_of_service_interactor.dart';
import 'features/terms/widgets/terms_and_conditions_widget.dart';
import 'features/user_preferences/user_theme.dart';
import 'firebase_options.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  otherTasks();
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

Future<void> otherTasks() async {
  SrdLicense.initSRD();
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
    final themeMode = ref.watch(userThemePreferenceProvider);

    /// just to initialize the spells
    ref.read(srdSpellViewModelsProvider.future);

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
      themeMode: themeMode.theme,
      theme: AppTheme().theme,
      darkTheme: AppTheme().darkTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
