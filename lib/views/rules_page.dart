import 'package:spells_and_tools/features/5e/game_system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../features/main_menu/widgets/main_menu_default_card_widget.dart';

class RulesPage extends HookConsumerWidget {
  const RulesPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = [
      MainMenuDefaultCardWidget(
        icon: Symbols.ar_on_you,
        title: "Races",
        path: "/races",
      ),
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.characterClass.icon,
        title: GameSystemViewModel.characterClass.name,
        path: '/classes',
      ),
      // MainMenuDefaultCardWidget(
      //   icon: GameSystemViewModel.armorClass.icon,
      //   title: "Armors",
      //   path: "/armors",
      // ),
      // MainMenuDefaultCardWidget(
      //   icon: GameSystemViewModel.conditions.icon,
      //   title: "Conditions",
      //   path: "/conditions",
      // ),
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
        icon: Symbols.swords,
        title: "Weapons",
        path: "/weapons",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(GameSystemViewModel.rules.name),
      ),
      body: ListView.separated(
        itemCount: widgets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return widgets[index];
        },
      ),
    );
  }
}
