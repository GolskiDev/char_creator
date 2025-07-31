import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../theme.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkModeEnabled = ref.watch(isDarkModeEnabledProvider);

    final List<Widget> settings = [
      SwitchListTile(
        title: const Text("Dark Mode"),
        value: isDarkModeEnabled,
        onChanged: (value) {
          ref.read(isDarkModeEnabledProvider.notifier).state =
              !isDarkModeEnabled;
        },
      ),
      ListTile(
        leading: Icon(GameSystemViewModel.account.icon),
        subtitle: Text(GameSystemViewModel.account.name),
        onTap: () {
          context.go('/settings/account');
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return settings[index];
        },
      ),
    );
  }
}
