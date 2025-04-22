import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:char_creator/features/main_menu/widgets/main_menu_default_card_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainMenuPage extends HookConsumerWidget {
  const MainMenuPage({super.key});

  static final double iconSize = 64.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = [
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.spells.icon,
        title: GameSystemViewModel.spells.name,
        path: "/spells",
      ),
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.character.icon,
        title: GameSystemViewModel.character.name,
        path: "/characters",
      ),
      if (kDebugMode)
        MainMenuDefaultCardWidget(
          icon: Icons.extension,
          title: "Utils",
          path: "/utils",
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: widgets
                .map(
                  (widget) => widget,
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
