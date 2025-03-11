import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../spells/view_models/spell_view_model.dart';

class GroupedSpellsWidget extends HookConsumerWidget {
  final List<SpellViewModel> characterSpells;
  const GroupedSpellsWidget({
    required this.characterSpells,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGrouping = useState('All');

    final groupedSpells = _groupSpells(characterSpells, selectedGrouping.value);

    return Column(
      children: [
        _buildGroupingSelector(selectedGrouping),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: groupedSpells.entries.map(
              (entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (entry.key == 'All Spells')
                      GridView.builder(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          final spell = entry.value[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                context.push('/spells/${spell.id}');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (spell.imageUrl != null)
                                    Flexible(
                                      child: Hero(
                                        tag: spell.imageUrl!,
                                        child: Image.asset(
                                          spell.imageUrl!,
                                          fit: BoxFit.cover,
                                          frameBuilder: (context, child, frame,
                                              wasSynchronouslyLoaded) {
                                            if (wasSynchronouslyLoaded) {
                                              return child;
                                            }
                                            return AnimatedOpacity(
                                              duration: Durations.long1,
                                              curve: Curves.easeIn,
                                              opacity: frame == null ? 0 : 1,
                                              child: child,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      spell.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: entry.value.map(
                            (spell) {
                              return Container(
                                width: 200,
                                margin: const EdgeInsets.all(8.0),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      context.push('/spells/${spell.id}');
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (spell.imageUrl != null)
                                          Hero(
                                            tag: spell.imageUrl!,
                                            child: Image.asset(
                                              spell.imageUrl!,
                                              fit: BoxFit.fitWidth,
                                              frameBuilder: (context,
                                                  child,
                                                  frame,
                                                  wasSynchronouslyLoaded) {
                                                if (wasSynchronouslyLoaded) {
                                                  return child;
                                                }
                                                return AnimatedOpacity(
                                                  duration: Durations.long1,
                                                  curve: Curves.easeIn,
                                                  opacity:
                                                      frame == null ? 0 : 1,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            spell.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupingSelector(ValueNotifier<String> selectedGrouping) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: 'All',
            label: Text('All Spells'),
            icon: Icon(Icons.all_inclusive),
          ),
          ButtonSegment(
            value: 'Type',
            label: Text('Spell Type'),
            icon: Icon(Symbols.emoji_symbols),
          ),
          ButtonSegment(
            value: 'Casting Time',
            label: Text('Casting Time'),
            icon: Icon(Icons.timer),
          ),
          ButtonSegment(
            value: 'Level',
            label: Text('Level'),
            icon: Icon(Icons.star),
          ),
        ],
        selected: {selectedGrouping.value},
        onSelectionChanged: (newSelection) {
          if (newSelection.isNotEmpty) {
            selectedGrouping.value = newSelection.first;
          }
        },
      ),
    );
  }

  Map<String, List<SpellViewModel>> _groupSpells(
    List<SpellViewModel> spells,
    String grouping,
  ) {
    switch (grouping) {
      case 'Type':
        return _groupByType(spells);
      case 'Casting Time':
        return _groupByCastingTime(spells);
      case 'Level':
        return _groupByLevel(spells);
      default:
        return {'All Spells': spells};
    }
  }

  Map<String, List<SpellViewModel>> _groupByType(List<SpellViewModel> spells) {
    final Map<String, List<SpellViewModel>> groupedSpells = {};
    for (final spell in spells) {
      final types = spell.spellTypes?.map((type) => type.name).toList() ?? [];
      for (final type in types) {
        if (!groupedSpells.containsKey(type)) {
          groupedSpells[type] = [];
        }
        groupedSpells[type]!.add(spell);
      }
    }
    return groupedSpells;
  }

  Map<String, List<SpellViewModel>> _groupByCastingTime(
      List<SpellViewModel> spells) {
    final Map<String, List<SpellViewModel>> groupedSpells = {};
    for (final spell in spells) {
      final castingTime = spell.castingTime?.id ?? 'Unknown';
      if (!groupedSpells.containsKey(castingTime)) {
        groupedSpells[castingTime] = [];
      }
      groupedSpells[castingTime]!.add(spell);
    }
    return groupedSpells;
  }

  Map<String, List<SpellViewModel>> _groupByLevel(List<SpellViewModel> spells) {
    final Map<String, List<SpellViewModel>> groupedSpells = {};
    for (final spell in spells) {
      final level = spell.spellLevelString;
      if (!groupedSpells.containsKey(level)) {
        groupedSpells[level] = [];
      }
      groupedSpells[level]!.add(spell);
    }
    return groupedSpells;
  }
}
