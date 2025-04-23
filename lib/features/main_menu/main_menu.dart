import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:char_creator/features/main_menu/widgets/main_menu_default_card_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.characterClass.icon,
        title: GameSystemViewModel.characterClass.name,
        path: '/classes',
      ),
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.armorClass.icon,
        title: "Armors",
        path: "/armors",
      ),
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.conditions.icon,
        title: "Conditions",
        path: "/conditions",
      ),
      MainMenuDefaultCardWidget(
        icon: Symbols.money_bag,
        title: "Magic Items",
        path: "/magic-items",
      ),
      MainMenuDefaultCardWidget(
        icon: Symbols.pets,
        title: "Monsters",
        path: "/monsters",
      ),
      MainMenuDefaultCardWidget(
        icon: Symbols.ar_on_you,
        title: "Races",
        path: "/races",
      ),
      MainMenuDefaultCardWidget(
        icon: Symbols.swords,
        title: "Weapons",
        path: "/weapons",
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }
}
