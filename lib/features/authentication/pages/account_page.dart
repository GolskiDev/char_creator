import 'package:spells_and_tools/features/5e/game_system_view_model.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth_controller.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GameSystemViewModel.account.name),
      ),
      body: ProfileScreen(
        actions: [
          SignedOutAction(
            (context) async {
              final authController = ref.read(authControllerProvider);
              await authController.authStateChanges.firstWhere(
                (user) => user == null,
              );
              if (context.mounted) {
                context.go('/seeYouSoon');
              }
            },
          ),
          AccountDeletedAction(
            (context, user) async {
              context.go('/seeYouSoon');
            },
          ),
        ],
      ),
    );
  }
}
