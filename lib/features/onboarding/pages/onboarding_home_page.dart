import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingHomePage extends HookConsumerWidget {
  const OnboardingHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = 'Welcome Stranger!';
    final buttonText = 'Begin Your Journey';
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(GameSystemViewModel.signIn.icon),
              onPressed: () {
                context.go('/consents');
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () {
                    context.go('/onboarding/exploreSpells');
                  },
                  child: Text(buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
