import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../view_models/spell_view_model.dart';

class SpellCardWidget extends ConsumerWidget {
  const SpellCardWidget({
    super.key,
    required this.spell,
  });

  final SpellViewModel spell;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
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
                if (spell.requiresVerbalComponent == true)
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
                  ),
                if (spell.requiresSomaticComponent == true)
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
                  ),
                if (spell.requiresMaterialComponent == true)
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
                  ),
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
        title: Text(spell.spellLevelString),
        subtitle: Text('Spell Level'),
      ),
      if (spell.castingTime != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Icons.schedule),
          title: Text(spell.castingTime.toString()),
          subtitle: Text('Casting Time'),
        ),
      if (spell.range != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Symbols.target),
          title: Text(spell.range.toString()),
          subtitle: Text('Range'),
        ),
      if (spell.duration != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Icons.timer),
          title: Text(spell.duration.toString()),
          subtitle: Text('Duration'),
        ),
      if (spell.requiresConcentration != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Symbols.mindfulness),
          title: Text(spell.requiresConcentration! ? 'Yes' : 'No'),
          subtitle: Text('Requires Concentration'),
        ),
      if (spell.canBeCastAsRitual != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Symbols.person_celebrate),
          title: Text(spell.canBeCastAsRitual! ? 'Yes' : 'No'),
          subtitle: Text('Can be Cast as Ritual'),
        ),
      if (spell.requiresMaterialComponent != null ||
          spell.requiresSomaticComponent != null ||
          spell.requiresVerbalComponent != null)
        components,
      if (spell.material != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(
            'Material',
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            spell.material!,
            textAlign: TextAlign.center,
          ),
        ),
      if (spell.school != null)
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: Icon(Icons.book),
          title: Text(spell.school!),
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
              if (spell.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Hero(
                        tag: spell.imageUrl!,
                        child: Image.asset(
                          spell.imageUrl!,
                          fit: BoxFit.cover,
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
                        spell.name,
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
                        spell.description,
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
