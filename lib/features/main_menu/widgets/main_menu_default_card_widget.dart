import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main_menu.dart';

class MainMenuDefaultCardWidget extends HookConsumerWidget {
  final String path;
  final IconData? icon;
  final String title;

  const MainMenuDefaultCardWidget({
    required this.icon,
    required this.title,
    required this.path,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.go(path);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: MainMenuPage.iconSize,
                ),
              Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
