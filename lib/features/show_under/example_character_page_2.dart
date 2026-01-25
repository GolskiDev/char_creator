import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/character_widgets.dart';

class ExampleCharacterPage2 extends HookConsumerWidget {
  const ExampleCharacterPage2({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example usage of the widgets
    final abilityScores = useState<Map<String, int>>({
      'Strength': 15,
      'Dexterity': 14,
      'Constitution': 13,
      'Intelligence': 12,
      'Wisdom': 10,
      'Charisma': 8,
    });

    Widget listTileThemeWrapper({required Widget child}) =>
        ListTileThemeWrapper(child: child);

    Widget traitBuilder({
      required String tag,
      required IconData icon,
      required String title,
      required String subtitle,
      Function()? onTap,
    }) =>
        TraitBuilder(
          tag: tag,
          icon: icon,
          title: title,
          subtitle: subtitle,
          onTap: onTap,
        );

    Widget groupBuilder({
      IconData? grupIcon,
      required String groupTitle,
      required List<Widget> children,
      double? preferredWidth,
    }) =>
        GroupBuilder(
          grupIcon: grupIcon,
          groupTitle: groupTitle,
          children: children,
          abilityScoresLength: abilityScores.value.length,
          listTileThemeWrapper: listTileThemeWrapper,
          preferredWidth: preferredWidth,
        );

    Widget othersBuilder() => OthersBuilder(
          ageBuilder: () => traitBuilder(
            tag: 'character.age',
            icon: Icons.cake,
            title: '30',
            subtitle: 'Age',
          ),
          alignmentBuilder: () => traitBuilder(
            tag: 'character.alignment',
            icon: Icons.balance,
            title: 'Lawful Good',
            subtitle: 'Alignment',
          ),
          sizeBuilder: () => traitBuilder(
            tag: 'character.size',
            icon: Icons.height,
            title: 'Medium',
            subtitle: 'Size',
          ),
          speedBuilder: () => traitBuilder(
            tag: 'character.speed',
            icon: Icons.directions_walk,
            title: '30 ft.',
            subtitle: 'Speed',
          ),
          visionBuilder: () => traitBuilder(
            tag: 'character.vision',
            icon: Icons.remove_red_eye,
            title: 'Darkvision 60 ft.',
            subtitle: 'Vision',
          ),
          proficienciesBuilder: () => traitBuilder(
            tag: 'character.proficiencies',
            icon: Icons.build,
            title: 'Proficiencies',
            subtitle: 'Various Proficiencies',
          ),
          languagesBuilder: () => traitBuilder(
            tag: 'character.languages',
            icon: Icons.language,
            title: 'Languages',
            subtitle: 'Known Languages',
          ),
          listTileThemeWrapper: listTileThemeWrapper,
        );

    final items = [
      groupBuilder(
        groupTitle: 'Ability Scores',
        grupIcon: Icons.fitness_center,
        children: abilityScores.value.entries
            .map((entry) => Card(
                  clipBehavior: Clip.antiAlias,
                  child: traitBuilder(
                    tag: 'ability_${entry.key}',
                    icon: Icons.fitness_center,
                    title: entry.value.toString(),
                    subtitle: entry.key.substring(0, 3).toUpperCase(),
                  ),
                ))
            .toList(),
        preferredWidth: 100.0,
      ),
      othersBuilder(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Example Character Page 2')),
      body: SafeArea(
        child: ListView.separated(
          itemCount: items.length,
          padding: const EdgeInsets.all(4.0),
          itemBuilder: (context, index) => items[index],
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }
}
