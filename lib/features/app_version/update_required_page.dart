import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sources/update_link.dart';

class UpdateRequiredPage extends HookConsumerWidget {
  const UpdateRequiredPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = 'assets/images/ui/update_available.webp';
    final title =
        "Oh dear, my runes are misaligned! Please update me so I may serve you once more.";
    final description =
        'An update is required to continue using the app. Please update to the latest version from the app store.';
    final buttonText = 'Update Now';
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight;
                  double imageWidth = maxWidth - 32;
                  double imageHeight = imageWidth * 4 / 3;
                  if (imageHeight > maxHeight * 0.4) {
                    imageHeight = maxHeight * 0.4;
                    imageWidth = imageHeight * 3 / 4;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Image.asset(
                            imageUrl,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final updateLink = await ref.read(updateLinkProvider.future);
                if (updateLink != null) {
                  launchUrl(
                    Uri.parse(updateLink),
                    mode: LaunchMode.externalApplication,
                  );
                }
                if (updateLink == null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Oops! Please try updating the app from your device\'s app store.')),
                  );
                }
              },
              child: Text(buttonText),
            ),
          ),
        ),
      ),
    );
  }
}
