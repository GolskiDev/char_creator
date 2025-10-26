import 'package:char_creator/features/5e/spells/models/spell_casting_time.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../game_system_view_model.dart';
import '../../spells/spell_card_page.dart';
import '../../spells/utils/spell_utils.dart';
import '../../spells/view_models/spell_view_model.dart';
import '../../tags.dart';
import '../character_provider.dart';

class GroupedSpellsWidget extends HookConsumerWidget {
  final List<SpellViewModel> characterSpells;
  const GroupedSpellsWidget({
    required this.characterSpells,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGrouping = useState(GameSystemViewModel.spellLevel.name);

    final groupedSpells = _groupSpells(characterSpells, selectedGrouping.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGroupingSelector(selectedGrouping),
        ListView(
          shrinkWrap: true,
          primary: false,
          children: groupedSpells.entries.sorted(
            (a, b) {
              switch ((a.key, b.key)) {
                case (SpellType a, SpellType b):
                  return a.title.compareTo(b.title);
                case (int levelA, int levelB):
                  return levelA.compareTo(levelB);
                case (String castTimeA, String castTimeB):
                  return castTimeA.compareTo(castTimeB);
                default:
                  return 0;
              }
            },
          ).map(
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
                      int level => Text(
                          SpellUtils.spellLevelString(level),
                          style: Theme.of(context).textTheme.titleLarge,
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
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: smallSpellWidget(
                                  groupedSpells, context, spell),
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
              Expanded(
                child: Hero(
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
            value: GameSystemViewModel.spellType.name,
            tooltip: GameSystemViewModel.spellType.name,
            icon: Icon(GameSystemViewModel.spellType.icon),
            label: Text(GameSystemViewModel.spellType.name),
          ),
          ButtonSegment(
            value: GameSystemViewModel.spellLevel.name,
            tooltip: GameSystemViewModel.spellLevel.name,
            icon: Icon(GameSystemViewModel.spellLevel.icon),
            label: Text(GameSystemViewModel.spellLevel.name),
          ),
          ButtonSegment(
            value: GameSystemViewModel.castingTime.name,
            tooltip: GameSystemViewModel.castingTime.name,
            icon: Icon(GameSystemViewModel.castingTime.icon),
            label: Text(GameSystemViewModel.castingTime.name),
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
      case 'Spell Type':
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

  Map<SpellCastingTime, List<SpellViewModel>> _groupByCastingTime(
      List<SpellViewModel> spells) {
    return groupBy(
      spells,
      (spell) => spell.castingTime ?? SpellCastingTime.fromString('Unknown'),
    );
  }

  Map<int, List<SpellViewModel>> _groupByLevel(List<SpellViewModel> spells) {
    return groupBy(spells, (spell) => spell.spellLevel);
  }

  showSpell({
    required BuildContext context,
    required String spellId,
    required List<SpellViewModel> spells,
  }) {
    final selectedCharacterId = SelectedCharacterIdProvider.maybeOf(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedCharacterIdProvider(
          selectedCharacterId: selectedCharacterId,
          child: SpellCardPage(
            id: spellId,
            spellsFuture: Future.value(spells),
          ),
        ),
      ),
    );
  }
}
