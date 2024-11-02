import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'work_in_progress/navigation.dart';
import 'work_in_progress/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: MaterialApp.router(
        theme: AppTheme().themeData,
        routerConfig: Navigation().goRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
