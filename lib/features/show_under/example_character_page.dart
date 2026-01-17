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

    // AlignmentBuilder: editable alignment field and trait display
    final alignmentController = useTextEditingController(text: 'Lawful Good');

    final alignmentBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.balance),
          title: const Text('Alignment'),
          subtitle: TextField(
            controller: alignmentController,
            decoration: const InputDecoration(
              labelText: 'Enter Alignment',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.alignment',
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

    // SizeBuilder: editable size field and trait display
    final sizeController = useTextEditingController(text: 'Medium');

    final sizeBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.height),
          title: const Text('Size'),
          subtitle: TextField(
            controller: sizeController,
            decoration: const InputDecoration(
              labelText: 'Enter Size',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.size',
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

    // SpeedBuilder: editable speed field and trait display
    final speedController = useTextEditingController(text: '25');

    final speedBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.directions_run),
          title: const Text('Speed'),
          subtitle: TextField(
            controller: speedController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter Speed',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.speed',
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

    // VisionBuilder: editable vision field and trait display
    final visionController = useTextEditingController(text: 'Darkvision 60 ft');

    final visionBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.visibility),
          title: const Text('Vision'),
          subtitle: TextField(
            controller: visionController,
            decoration: const InputDecoration(
              labelText: 'Enter Vision',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.vision',
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

    // ResistancesBuilder: editable resistances field and trait display
    final resistancesController = useTextEditingController(text: 'Poison');

    final resistancesBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.shield),
          title: const Text('Resistances'),
          subtitle: TextField(
            controller: resistancesController,
            decoration: const InputDecoration(
              labelText: 'Enter Resistances',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.resistances',
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

    // SavingThrowsBuilder: editable saving throws field and trait display
    final savingThrowsController = useTextEditingController(text: 'Poison');

    final savingThrowsBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Saving Throws'),
          subtitle: TextField(
            controller: savingThrowsController,
            decoration: const InputDecoration(
              labelText: 'Enter Saving Throws',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.savingThrows',
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

    // SkillsBuilder: editable skills field and trait display
    final skillsController = useTextEditingController(text: 'History');

    final skillsBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.psychology),
          title: const Text('Skills'),
          subtitle: TextField(
            controller: skillsController,
            decoration: const InputDecoration(
              labelText: 'Enter Skills',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.skills.history',
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

    // LanguagesBuilder: editable languages field and trait display
    final languagesController =
        useTextEditingController(text: 'Common, Dwarvish');

    final languagesBuilder = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Languages'),
          subtitle: TextField(
            controller: languagesController,
            decoration: const InputDecoration(
              labelText: 'Enter Languages',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShowUnderDataProvider(
            targetName: 'character.languages',
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
      alignmentBuilder,
      sizeBuilder,
      speedBuilder,
      visionBuilder,
      resistancesBuilder,
      savingThrowsBuilder,
      skillsBuilder,
      languagesBuilder,
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
