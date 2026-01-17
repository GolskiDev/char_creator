import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/show_under/show_under.dart';

class ExampleCharacterPage extends HookConsumerWidget {
  const ExampleCharacterPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTraits = useState<List<String>>([]);

    final abilityScores = useState<Map<String, int>>({
      'Strength': 16,
      'Dexterity': 12,
      'Constitution': 14,
      'Intelligence': 10,
      'Wisdom': 13,
      'Charisma': 8,
    });

    final data = dwarf;
    final traits = data['traits'] as List<Map<String, dynamic>>;
    final exampleItems =
        traits.map((trait) => ExampleItem.fromMap(trait)).toList();

    final abilityScoresBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.fitness_center),
          title: const Text('Ability Scores'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Logic to edit ability scores
            },
          ),
        ),
        ...abilityScores.value.entries.map(
          (entry) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(entry.key),
                trailing: Text(entry.value.toString()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ShowUnderDataProvider(
                  targetName:
                      'character.abilityScores.${entry.key.toLowerCase()}',
                  data: exampleItems,
                  child: Builder(
                    builder: (context) {
                      final showUnderItems =
                          ShowUnderDataProvider.maybeOf(context)
                                  ?.dataForTarget ??
                              [];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: showUnderItems
                            .map<Widget>(
                              (item) => ListTile(
                                title: Text(item.title),
                                subtitle: Text(item.description),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // AgeBuilder: editable age field and trait display
    final ageController = useTextEditingController(text: '50');

    final ageBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.cake),
          title: const Text('Age'),
          subtitle: TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter Age',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.age',
            data: exampleItems,
            child: Builder(
              builder: (context) {
                final showUnderItems =
                    ShowUnderDataProvider.maybeOf(context)?.dataForTarget ?? [];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: showUnderItems
                      .map<Widget>((item) => ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.description),
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ],
    );

    final items = [
      abilityScoresBuilder,
      ageBuilder,
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          itemCount: items.length,
          padding: const EdgeInsets.all(4.0),
          itemBuilder: (context, index) {
            return Card(
              child: items[index],
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 4.0,
          ),
        ),
      ),
    );
  }
}
