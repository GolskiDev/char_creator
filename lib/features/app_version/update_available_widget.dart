import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sources/update_link.dart';

class UpdateAvailableWidget extends HookConsumerWidget {
  const UpdateAvailableWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = 'assets/images/ui/update_available.webp';
    final subtitle = 'I sense I\'m about to level up! Touch to update';
    void onTap() async {
      final link = await ref.watch(updateLinkProvider.future);
      if (link != null) {
        launchUrl(
          Uri.parse(link),
          mode: LaunchMode.externalApplication,
        );
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              Card(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Card.filled(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        subtitle,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
