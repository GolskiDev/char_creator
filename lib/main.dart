import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation.dart';
import 'theme.dart';

void main() {
  runApp(const MainApp());
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
