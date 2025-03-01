import 'package:char_creator/features/spells/models/spell_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../open5e/open_5e_spell_model.dart';
import '../spell_images/spell_images_repository.dart';

class SpellCardWidget extends ConsumerWidget {
  const SpellCardWidget({
    super.key,
    required this.spell,
  });

  final Open5eSpellModelV1 spell;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final spellImagePathAsync = ref.watch(spellImagePathProvider(spell.slug));

    final String? spellImagePath;
    switch (spellImagePathAsync) {
      case AsyncValue(value: final String? path, hasValue: true):
        spellImagePath = path;
        break;
      default:
        return Center(
          child: CircularProgressIndicator(),
        );
    }

    final spellModel = spell.toSpellModel();

    var components = Center(
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          'Components',
          textAlign: TextAlign.center,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            children: [
              TableRow(
                  children: [
                if (spellModel.requiresVerbalComponent != null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.record_voice_over,
                      ),
                      Text(
                        'Verbal',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  )
                else
                  SizedBox.shrink(),
                if (spellModel.requiresSomaticComponent != null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.waving_hand,
                      ),
                      Text(
                        'Somatic',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  )
                else
                  SizedBox.shrink(),
                if (spellModel.requiresMaterialComponent != null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category,
                      ),
                      FittedBox(
                        child: Text(
                          'Material',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox.shrink(),
              ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          child: e,
                        ),
                      )
                      .toList()),
            ],
          ),
        ),
      ),
    );

    List<Widget> spellTraits = [
      ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(Icons.star),
        title: Text(spellModel.spellLevelString),
        subtitle: Text('Spell Level'),
      ),
      if (spellModel.castingTime != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Icons.schedule),
          title: Text(spellModel.castingTime.toString()),
          subtitle: Text('Casting Time'),
        ),
        if (spellModel.range != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Symbols.target),
          title: Text(spellModel.range.toString()),
          subtitle: Text('Range'),
        ),
      if (spellModel.duration != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Icons.timer),
          title: Text(spellModel.duration.toString()),
          subtitle: Text('Duration'),
        ),
      if (spellModel.requiresConcentration != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Symbols.mindfulness),
          title: Text(spellModel.requiresConcentration! ? 'Yes' : 'No'),
          subtitle: Text('Requires Concentration'),
        ),
      if (spellModel.canBeCastAsRitual != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Symbols.person_celebrate),
          title: Text(spellModel.canBeCastAsRitual! ? 'Yes' : 'No'),
          subtitle: Text('Can be Cast as Ritual'),
        ),
      if (spellModel.requiresMaterialComponent != null ||
          spellModel.requiresSomaticComponent != null ||
          spellModel.requiresVerbalComponent != null)
        components,
      if (spellModel.material != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(
            'Material',
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            spellModel.material!,
            textAlign: TextAlign.center,
          ),
        ),
      if (spellModel.school != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Icons.book),
          title: Text(spellModel.school!),
          subtitle: Text('School'),
        ),
    ]
        .map(
          (e) => Card(
            child: Center(child: e),
          ),
        )
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        child: Scrollbar(
          thumbVisibility: false,
          trackVisibility: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (spellImagePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      spellImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        spellModel.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.intrinsicHeight,
                        children: List<TableRow>.generate(
                          (spellTraits.length / 2).ceil(),
                          (index) => TableRow(
                            children: [
                              spellTraits[index * 2],
                              if (index * 2 + 1 < spellTraits.length)
                                spellTraits[index * 2 + 1]
                              else
                                SizedBox.shrink(),
                            ]
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: e,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        spellModel.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
