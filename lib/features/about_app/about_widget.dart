import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spells_and_tools/features/5e/game_system_view_model.dart';
import 'package:spells_and_tools/features/app_version/app_version_interactor.dart';
import 'package:spells_and_tools/features/navigation/dialog_route.dart';

class AboutAppDialog {
  static DialogPage route({
    required BuildContext context,
  }) {
    final aboutApp = GameSystemViewModel.aboutApp;
    return DialogPage(
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final title = aboutApp.name;
            final appVersion =
                ref.watch(currentAppVersionProvider).asData?.value ??
                    'Unknown Version';
            final description = "Spells & Tools - Version $appVersion";
            final licenses = GameSystemViewModel.licenses;
            return AlertDialog(
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      description,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context.push('/licenses');
                      },
                      child: Text(licenses.name),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
