import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/common/widgets/small_square_widget.dart';
import 'package:spells_and_tools/features/show_under/edit_property_page.dart';
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

    abilityScoreBuilder({
      required String tag,
      required IconData icon,
      required String title,
      required String subtitle,
      Function()? onTap,
    }) {
      return Hero(
        tag: tag,
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: Icon(icon),
            onTap: onTap,
            subtitle: Text(
              subtitle,
            ),
            title: Text(
              title,
            ),
          ),
        ),
      );
    }

    tileBuilder() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.fitness_center),
              titleAlignment: ListTileTitleAlignment.center,
              title: const Text(
                'Ability Scores',
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
                                child: abilityScoreBuilder(
                                  tag: 'ability_${entry.key}',
                                  icon: Icons.fitness_center,
                                  title: entry.value.toString(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ShowUnderDataProvider(
                                            data: selectedTraits.value
                                                .map(
                                                  (traitId) => exampleItems
                                                      .firstWhereOrNull(
                                                    (item) =>
                                                        item.id == traitId,
                                                  ),
                                                )
                                                .nonNulls
                                                .toList(),
                                            child: EditPropertyPage(
                                              propertyIcon:
                                                  Icons.fitness_center,
                                              propertyId:
                                                  'character.abilityScores.${entry.key.toLowerCase()}',
                                              propertyName: entry.key,
                                              propertyDescription: null,
                                              initialValue: entry.value,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  subtitle: entry.key
                                      .substring(
                                        0,
                                        min(3, entry.key.length),
                                      )
                                      .toUpperCase(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        );

    final items = [
      selectTraitsListTile,
      tileBuilder(),
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
