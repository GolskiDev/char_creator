import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'example_character_data.dart';
import 'widgets/character_widgets.dart';

class ExampleCharacterPage2 extends HookConsumerWidget {
  const ExampleCharacterPage2({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example usage of the widgets
    final characterState = useState(exampleCharacter5e);
    final character = characterState.value;
    final abilityScores = character.abilityScores;

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
          abilityScoresLength: abilityScores?.abilityScores.length ?? 0,
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

    Widget raceBuilder() => ListTile(
          leading: const Icon(Icons.groups),
          title: const Text('Click here to add the race'),
          subtitle: const Text('No race selected'),
          onTap: () {
            // TODO: Implement navigation to race selection page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Race selection coming soon!')),
            );
          },
        );

    final items = [
      raceBuilder(),
      groupBuilder(
        groupTitle: 'Ability Scores',
        grupIcon: Icons.fitness_center,
        children: (abilityScores?.abilityScores.entries ?? const {})
            .map((entry) => Card(
                  clipBehavior: Clip.antiAlias,
                  child: traitBuilder(
                    tag: 'ability_${entry.key.name}',
                    icon: Icons.fitness_center,
                    title: (entry.value.value ?? '-').toString(),
                    subtitle: entry.key.name.substring(0, 3).toUpperCase(),
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
