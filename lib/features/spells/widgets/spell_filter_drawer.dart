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
  final Function(Set<String> selectedSchools) onSelectedSchoolsChanged;

  const SpellFilterDrawer({
    super.key,
    required this.allSpellModels,
    required this.filters,
    required this.onRequiresConcentrationChanged,
    required this.onCanBeCastAsRitualChanged,
    required this.onRequiresVerbalComponentChanged,
    required this.onRequiresSomaticComponentChanged,
    required this.onRequiresMaterialComponentChanged,
    required this.onSelectedSchoolsChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wereSchoolsExpanded = useState(false);
    final areSchoolsExpanded =
        wereSchoolsExpanded.value || filters.selectedSchools.isNotEmpty;
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
            Divider(),
            ListTile(
              leading: Tooltip(
                message: 'Requires Concentration',
                child: Icon(Symbols.mindfulness),
              ),
              title: Text(
                'Requires Concentration',
              ),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresConcentration},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(
                      'No',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresConcentrationChanged(p0.firstOrNull),
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Symbols.person_celebrate),
              title: Text(
                'Can Be Cast As Ritual',
              ),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.canBeCastAsRitual},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(
                      'No',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onCanBeCastAsRitualChanged(p0.firstOrNull),
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.record_voice_over),
              title: Text(
                'Verbal Component',
              ),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresVerbalComponent},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(
                      'No',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresVerbalComponentChanged(p0.firstOrNull),
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.waving_hand),
              title: Text(
                'Somatic Component',
              ),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresSomaticComponent},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(
                      'No',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresSomaticComponentChanged(p0.firstOrNull),
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text(
                'Material Component',
              ),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {filters.requiresMaterialComponent},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(
                      'No',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                onSelectionChanged: (p0) => {
                  onRequiresMaterialComponentChanged(p0.firstOrNull),
                },
              ),
            ),
            Divider(),
            ExpansionTile(
              initiallyExpanded: areSchoolsExpanded,
              onExpansionChanged: (expanded) {
                wereSchoolsExpanded.value = expanded;
              },
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              title: Row(
                children: [
                  Icon(Icons.book),
                  const SizedBox(width: 16),
                  Text(
                    'School',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              children: [
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.start,
                  children: allSpellModels
                      .map((spell) => spell.school)
                      .where((school) => school != null)
                      .toSet()
                      .map(
                        (school) => FilterChip(
                          visualDensity: VisualDensity.compact,
                          label: Text(school!),
                          selected: filters.selectedSchools.contains(school),
                          onSelected: (selected) {
                            final updatedSchools =
                                Set<String>.from(filters.selectedSchools);
                            if (selected) {
                              updatedSchools.add(school);
                            } else {
                              updatedSchools.remove(school);
                            }
                            onSelectedSchoolsChanged(updatedSchools);
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            Divider(),
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
