import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/navigation/navigation.dart';
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

class App extends ConsumerWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final isDarkModeEnabled = ref.watch(isDarkModeEnabledProvider);

    return MaterialApp.router(
      theme: AppTheme().themeData(isDarkMode: isDarkModeEnabled),
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
