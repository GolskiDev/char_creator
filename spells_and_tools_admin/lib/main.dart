import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options_dev.dart';
import 'firebase_options_prod.dart';
import 'navigation.dart';

enum AppFlavor {
  dev,
  prod;

  static AppFlavor fromString(String? flavor) {
    switch (flavor) {
      case 'dev':
        return AppFlavor.dev;
      case 'prod':
        return AppFlavor.prod;
      default:
        throw UnsupportedError('Unsupported flavor: $flavor');
    }
  }

  static String? get webAppFlavor => const String.fromEnvironment('FLAVOR');

  static AppFlavor get currentFlavor => fromString(appFlavor ?? webAppFlavor);
}

final firebaseInitProvider = FutureProvider<void>((ref) async {
  switch (AppFlavor.currentFlavor) {
    case AppFlavor.dev:
      await Firebase.initializeApp(
        options: DefaultFirebaseOptionsDev.currentPlatform,
      );
      break;
    case AppFlavor.prod:
      await Firebase.initializeApp(
        options: DefaultFirebaseOptionsProd.currentPlatform,
      );
      break;
  }
});

Future<void> main() async {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseInit = ref.watch(firebaseInitProvider);
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      themeMode: ThemeMode.dark,
    );
  }
}
