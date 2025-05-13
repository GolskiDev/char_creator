import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../spells/spell_card_page.dart';
import '../../spells/view_models/spell_view_model.dart';
import '../../tags.dart';

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGroupingSelector(selectedGrouping),
        ListView(
          shrinkWrap: true,
          primary: false,
          children: groupedSpells.entries.map(
            (entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: switch (entry.key) {
                      SpellType type => Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Icon(type.icon),
                            Text(
                              type.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      Object something => Text(
                          something.toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                    },
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: entry.value.map(
                        (spell) {
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.all(8.0),
                            child:
                                smallSpellWidget(groupedSpells, context, spell),
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
      ],
    );
  }

  Card smallSpellWidget(
    Map<Object, List<SpellViewModel>> groupedSpells,
    BuildContext context,
    SpellViewModel spell,
  ) {
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final spellsInGrouped =
              groupedSpells.entries.expand((e) => e.value).toList();
          showSpell(
            context: context,
            spellId: spell.id,
            spells: spellsInGrouped,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (spell.imageUrl != null)
              Hero(
                tag: spell.imageUrl!,
                child: Image.asset(
                  spell.imageUrl!,
                  fit: BoxFit.fitWidth,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                spell.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupingSelector(ValueNotifier<String> selectedGrouping) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: 'Type',
            tooltip: 'Spell Type',
            icon: Icon(Symbols.emoji_symbols),
          ),
          ButtonSegment(
            value: 'Level',
            tooltip: 'Level',
            icon: Icon(Icons.star),
          ),
          ButtonSegment(
            value: 'Casting Time',
            tooltip: 'Casting Time',
            icon: Icon(Icons.timer),
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

  Map<Object, List<SpellViewModel>> _groupSpells(
    List<SpellViewModel> spells,
    String grouping,
  ) {
    switch (grouping) {
      case 'Type':
        return _groupByType(spells);
      case 'Casting Time':
        return _groupByCastingTime(spells);
      default:
        return _groupByLevel(spells);
    }
  }

  Map<SpellType, List<SpellViewModel>> _groupByType(
      List<SpellViewModel> spells) {
    final Map<SpellType, List<SpellViewModel>> groupedSpells = {};
    for (final spell in spells) {
      final types = spell.spellTypes.toList();
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

  showSpell({
    required BuildContext context,
    required String spellId,
    required List<SpellViewModel> spells,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpellCardPage(
          id: spellId,
          spellsFuture: Future.value(spells),
        ),
      ),
    );
  }
}
