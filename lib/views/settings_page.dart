import 'package:spells_and_tools/features/5e/game_system_view_model.dart';
import 'package:spells_and_tools/features/contact_us/contact_us.dart';
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
        title: Text(GameSystemViewModel.account.name),
        onTap: () {
          context.go('/settings/account');
        },
      ),
      ListTile(
        leading: Icon(GameSystemViewModel.contactUs.icon),
        title: Text(GameSystemViewModel.contactUs.name),
        onTap: () {
          ContactUs.sendMail();
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: settings[index],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
      ),
    );
  }
}
