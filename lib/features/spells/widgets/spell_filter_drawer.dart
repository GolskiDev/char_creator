import 'package:char_creator/features/spells/filters/spell_model_filters_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../models/spell_model.dart';

class SpellFilterDrawer extends HookConsumerWidget {
  final List<SpellModel> allSpellModels;
  final SpellModelFiltersState filters;

  final Function(bool? requiresConcentration) onRequiresConcentrationChanged;
  final Function(bool? canBeCastAsRitual) onCanBeCastAsRitualChanged;
  final Function(bool? requiresVerbalComponent)
      onRequiresVerbalComponentChanged;
  final Function(bool? requiresSomaticComponent)
      onRequiresSomaticComponentChanged;
  final Function(bool? requiresMaterialComponent)
      onRequiresMaterialComponentChanged;

  const SpellFilterDrawer({
    super.key,
    required this.allSpellModels,
    required this.filters,
    required this.onRequiresConcentrationChanged,
    required this.onCanBeCastAsRitualChanged,
    required this.onRequiresVerbalComponentChanged,
    required this.onRequiresSomaticComponentChanged,
    required this.onRequiresMaterialComponentChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final schools = allSpellModels
    //     .map((spell) => spell.school)
    //     .where((school) => school != null)
    //     .toSet();

    return Drawer(
      width: 350,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,

                ),
                child: Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const Divider(),
            // ListTile(
            //   title: Text(
            //     'School',
            //     style: Theme.of(context).textTheme.titleMedium,
            //   ),
            //   subtitle: Wrap(
            //     spacing: 8,
            //     runAlignment: WrapAlignment.center,
            //     children: schools
            //         .map(
            //           (school) => FilterChip(
            //             label: Text(school!),
            //             onSelected: (selected) {},
            //           ),
            //         )
            //         .toList(),
            //   ),
            // ),
            ListTile(
              title: const Text('Requires Concentration'),
              leading: Icon(Symbols.mindfulness),
              subtitle: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresConcentration},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresConcentrationChanged(p0.firstOrNull),
                },
              ),
            ),
            ListTile(
              title: const Text('Can Be Cast As Ritual'),
              leading: Icon(Symbols.person_celebrate),
              subtitle: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.canBeCastAsRitual},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onCanBeCastAsRitualChanged(p0.firstOrNull),
                },
              ),
            ),
            ListTile(
              title: const Text('Requires Verbal Component'),
              leading: Icon(Icons.record_voice_over),
              subtitle: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresVerbalComponent},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresVerbalComponentChanged(p0.firstOrNull),
                },
              ),
            ),
            ListTile(
              title: const Text('Requires Somatic Component'),
              leading: Icon(Icons.waving_hand),
              subtitle: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresSomaticComponent},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresSomaticComponentChanged(p0.firstOrNull),
                },
              ),
            ),
            ListTile(
              title: const Text('Requires Material Component'),
              leading: Icon(Icons.category),
              subtitle: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresMaterialComponent},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresMaterialComponentChanged(p0.firstOrNull),
                },
              ),
            ),
            // ListTile(
            //   title: const Text('Material'),
            //   subtitle: Wrap(
            //     spacing: 8,
            //     runAlignment: WrapAlignment.center,
            //     children: allSpellModels
            //         .map((spell) => spell.material)
            //         .where((material) => material != null)
            //         .toSet()
            //         .map(
            //           (material) => FilterChip(
            //             label: Expanded(
            //               child: Text(
            //                 material!,
            //               ),
            //             ),
            //             onSelected: (selected) {},
            //           ),
            //         )
            //         .toList(),
            //   ),
            // ),
            // ListTile(
            //   title: const Text('Duration'),
            //   subtitle: Wrap(
            //     spacing: 8,
            //     runAlignment: WrapAlignment.center,
            //     children: allSpellModels
            //         .map((spell) => spell.duration)
            //         .where((duration) => duration != null)
            //         .map((duration) => duration.toString())
            //         .toSet()
            //         .map(
            //           (duration) => FilterChip(
            //             label: Text(duration.toString()),
            //             onSelected: (selected) {},
            //           ),
            //         )
            //         .toList(),
            //   ),
            // ),
            // ListTile(
            //   title: const Text('Range'),
            //   subtitle: Wrap(
            //     spacing: 8,
            //     runAlignment: WrapAlignment.center,
            //     children: allSpellModels
            //         .map((spell) => spell.range)
            //         .where((range) => range != null)
            //         .map((range) => range!.toString())
            //         .toSet()
            //         .map(
            //           (range) => FilterChip(
            //             label: Text(range.toString()),
            //             onSelected: (selected) {},
            //           ),
            //         )
            //         .toList(),
            //   ),
            // ),
            // ListTile(
            //   title: const Text('Casting Time'),
            //   subtitle: Wrap(
            //     spacing: 8,
            //     runAlignment: WrapAlignment.center,
            //     children: allSpellModels
            //         .map((spell) => spell.castingTime)
            //         .where((castingTime) => castingTime != null)
            //         .map((castingTime) => castingTime!.toString())
            //         .toSet()
            //         .map(
            //           (castingTime) => FilterChip(
            //             label: Text(castingTime),
            //             onSelected: (selected) {},
            //           ),
            //         )
            //         .toList(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
