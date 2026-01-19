import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/common/widgets/small_square_widget.dart';
import 'package:spells_and_tools/features/show_under/show_under.dart';

import 'trait_model.dart';

class ExampleCharacterPage extends HookConsumerWidget {
  const ExampleCharacterPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = dwarf;
    final traits = data['traits'] as List<Map<String, dynamic>>;
    final selectedTraits = useState<List<String>>([]);

    final abilityScores = useState<Map<String, int>>(
      {
        'Strength': 16,
        'Dexterity': 122,
        'Constitution': 14,
        'Intelligence': 10,
        'Wisdom': 13,
        'Charisma': 8,
      },
    );

    final exampleItems = traits
        .map((trait) => TraitModel.fromMap(trait))
        .where(
          (item) => selectedTraits.value.contains(item.id),
        )
        .toList();

    Widget listTileThemeWrapper({
      required Widget child,
    }) =>
        Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: ListTileThemeData(
              titleTextStyle:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
              subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          child: child,
        );

    openTraitSelector() async {
      final selectedTraitIds = await Navigator.of(context).push<List<String>>(
        MaterialPageRoute(
          builder: (context) {
            return HookBuilder(builder: (context) {
              final previouslySelectedTraits = useState<List<String>>(
                List<String>.from(selectedTraits.value),
              );
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Select Traits'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        final selectedIds = previouslySelectedTraits.value;
                        Navigator.of(context).pop(selectedIds);
                      },
                    ),
                  ],
                ),
                body: ListView(
                  children: traits.map((trait) {
                    final traitId = trait['id'] as String;
                    final isSelected =
                        previouslySelectedTraits.value.contains(traitId);
                    return CheckboxListTile(
                      title: Text(trait['title'] as String),
                      subtitle: Text(trait['description'] as String),
                      value: isSelected,
                      onChanged: (value) {
                        if (value == true) {
                          previouslySelectedTraits.value = [
                            ...previouslySelectedTraits.value,
                            traitId
                          ];
                        } else {
                          previouslySelectedTraits.value =
                              previouslySelectedTraits.value
                                  .where((id) => id != traitId)
                                  .toList();
                        }
                      },
                    );
                  }).toList(),
                ),
              );
            });
          },
        ),
      );
      if (selectedTraitIds != null) {
        selectedTraits.value = selectedTraitIds;
      }
    }

    final selectTraitsListTile = ListTile(
      onTap: openTraitSelector,
      title: const Text('Select Traits'),
      subtitle: Text(
        selectedTraits.value.isEmpty
            ? 'No traits selected'
            : '${selectedTraits.value.length} traits selected',
      ),
      trailing: const Icon(Icons.edit),
    );

    abilityPageBuilder(
      BuildContext context,
      WidgetRef ref,
      MapEntry<String, int> abilityEntry,
    ) {
      return HookBuilder(
        builder: (context) {
          final textFieldController = useTextEditingController(
            text: abilityEntry.value.toString(),
          );
          abilityScoreWidget() => Hero(
                tag: 'ability_${abilityEntry.key}',
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text(abilityEntry.key),
                    trailing: SizedBox(
                      width: 60,
                      child: TextField(
                        controller: textFieldController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
              );

          showUnderAbilityScoreBuilder() {
            return ShowUnderDataProvider(
              targetName:
                  'character.abilityScores.${abilityEntry.key.toLowerCase()}',
              data: exampleItems,
              child: Builder(builder: (context) {
                final showUnderItems =
                    ShowUnderDataProvider.maybeOf(context)?.dataForTarget ?? [];
                if (showUnderItems.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    if (showUnderItems.isNotEmpty)
                      ListTile(
                        title: Text(
                          'Related Traits',
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Builder(
                        builder: (context) {
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
                  ],
                );
              }),
            );
          }

          final itmes = [
            abilityScoreWidget(),
            showUnderAbilityScoreBuilder(),
          ];

          return ShowUnderDataProvider(
            targetName:
                'character.abilityScores.${abilityEntry.key.toLowerCase()}',
            data: exampleItems,
            child: Scaffold(
              appBar: AppBar(),
              body: ListView.separated(
                itemBuilder: (context, index) => itmes[index],
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 4.0),
                itemCount: itmes.length,
              ),
            ),
          );
        },
      );
    }

    abilityScoreBuilder(MapEntry<String, int> entry) {
      return Hero(
        tag: 'ability_${entry.key}',
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => abilityPageBuilder(context, ref, entry),
                ),
              );
            },
            subtitle: Text(
              entry.key.substring(0, min(3, entry.key.length)).toUpperCase(),
            ),
            title: Text(
              entry.value.toString(),
            ),
          ),
        ),
      );
    }

    abilityScoresBuilder() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.fitness_center),
              titleAlignment: ListTileTitleAlignment.center,
              title: const Text(
                'Ability Scores',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Logic to edit ability scores
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final prefferedSize =
                      SmallSquareWidget.preferredSize(context);
                  var maxItemsInRow = 6;
                  // make the same amount of items fit in each row if possible
                  final crossAxisCount = () {
                    if (abilityScores.value.length % 2 != 0) {
                      return (constraints.maxWidth / prefferedSize.width)
                          .floor()
                          .clamp(1, maxItemsInRow);
                    } else {
                      maxItemsInRow =
                          (constraints.maxWidth / prefferedSize.width)
                              .floor()
                              .clamp(1, maxItemsInRow);
                      for (var i = maxItemsInRow; i >= 1; i--) {
                        if (abilityScores.value.length % i == 0) {
                          return i;
                        }
                      }
                      return 1;
                    }
                  }();

                  return listTileThemeWrapper(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 16 / 9,
                      physics: const NeverScrollableScrollPhysics(),
                      children: abilityScores.value.entries
                          .map(
                            (entry) => Center(
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: abilityScoreBuilder(entry),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
            // child: LayoutBuilder(
            //   builder: (context, constraints) {
            //     final entries = abilityScores.value.entries.map(
            //       (entry) => AspectRatio(
            //         aspectRatio: 1,
            //         child: Center(
            //           child: Card.outlined(
            //             clipBehavior: Clip.hardEdge,
            //             child: abilityScoreBuilder(entry),
            //           ),
            //         ),
            //       ),
            //     );
            //     final minItemWidth = 120.0;
            //     //make the same amount of items fit in each row
            //     final crossAxisCount =
            //         (constraints.maxWidth / minItemWidth).floor().clamp(1, 6);
            //     final tableRows = List.generate(
            //       entries.length ~/ crossAxisCount + 1,
            //       (index) => TableRow(
            //         children: List.generate(crossAxisCount, (colIndex) {
            //           final itemIndex = index * crossAxisCount + colIndex;
            //           if (itemIndex < entries.length) {
            //             return Padding(
            //               padding: const EdgeInsets.all(4.0),
            //               child: entries.elementAt(itemIndex),
            //             );
            //           } else {
            //             return const SizedBox.shrink();
            //           }
            //         }),
            //       ),
            //     );
            //     return Table(
            //       children: tableRows,
            //     );
            //   },
            // ),
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
        SmallSquareWidget(
          icon: Icons.height,
          shortLabel: 'Size',
          content: 'Medium',
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
      selectTraitsListTile,
      abilityScoresBuilder(),
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
            return items[index];
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
    );
  }
}
