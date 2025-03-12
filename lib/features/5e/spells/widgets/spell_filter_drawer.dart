import 'package:char_creator/features/5e/spell_tags/tags.dart';
import 'package:char_creator/features/5e/spells/filters/spell_model_filters_state.dart';
import 'package:char_creator/features/5e/spells/utils/spell_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../view_models/spell_view_model.dart';

class SpellFilterDrawer extends HookConsumerWidget {
  final List<SpellViewModel> allSpellModels;
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
  final Function(Set<String> castingTimeIds) onCastingTimeChanged;
  final Function(Set<String> rangeIds) onRangeChanged;
  final Function(Set<String> durationIds) onDurationChanged;
  final Function(Set<int> spellLevels) onSpellLevelChanged;
  final Function(Set<SpellType> spellTypes) onSpellTypesChanged;

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
    required this.onCastingTimeChanged,
    required this.onRangeChanged,
    required this.onDurationChanged,
    required this.onSpellLevelChanged,
    required this.onSpellTypesChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            _buildSpellTypeFilter(context),
            Divider(),
            _buildSpellLevelFilter(context),
            Divider(),
            _buildCastingTimeFilter(context),
            Divider(),
            _buildRangeFilter(context),
            Divider(),
            _buildDurationFilter(context),
            Divider(),
            _buildConcentrationFilter(),
            Divider(),
            _buildVerbalComponentFilter(),
            Divider(),
            _buildSomaticComponentFilter(),
            Divider(),
            _buildMaterialComponentFilter(),
            Divider(),
            _buildRitualFilter(),
            Divider(),
            _buildSchoolFilter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConcentrationFilter() {
    return ListTile(
      leading: Tooltip(
        message: 'Requires Concentration',
        child: Icon(Symbols.mindfulness),
      ),
      title: Text(
        'Requires Concentration',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SegmentedButton<bool?>(
        emptySelectionAllowed: true,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        selected: {filters.requiresConcentration},
        segments: [
          ButtonSegment(
            value: true,
            label: Text(
              'Yes',
            ),
          ),
          ButtonSegment(
            value: false,
            label: Text(
              'No',
            ),
          ),
        ],
        onSelectionChanged: (p0) =>
            onRequiresConcentrationChanged(p0.firstOrNull),
      ),
    );
  }

  Widget _buildRitualFilter() {
    return ListTile(
      leading: Icon(Symbols.person_celebrate),
      title: Text(
        'Can Be Cast As Ritual',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SegmentedButton<bool?>(
        emptySelectionAllowed: true,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        selected: {filters.canBeCastAsRitual},
        segments: [
          ButtonSegment(
            value: true,
            label: Text(
              'Yes',
            ),
          ),
          ButtonSegment(
            value: false,
            label: Text(
              'No',
            ),
          ),
        ],
        onSelectionChanged: (p0) => onCanBeCastAsRitualChanged(p0.firstOrNull),
      ),
    );
  }

  Widget _buildVerbalComponentFilter() {
    return ListTile(
      leading: Icon(Icons.record_voice_over),
      title: Text(
        'Verbal Component',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SegmentedButton<bool?>(
        emptySelectionAllowed: true,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        selected: {filters.requiresVerbalComponent},
        segments: [
          ButtonSegment(
            value: true,
            label: Text(
              'Yes',
            ),
          ),
          ButtonSegment(
            value: false,
            label: Text(
              'No',
            ),
          ),
        ],
        onSelectionChanged: (p0) =>
            onRequiresVerbalComponentChanged(p0.firstOrNull),
      ),
    );
  }

  Widget _buildSomaticComponentFilter() {
    return ListTile(
      leading: Icon(Icons.waving_hand),
      title: Text(
        'Somatic Component',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SegmentedButton<bool?>(
        emptySelectionAllowed: true,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        selected: {filters.requiresSomaticComponent},
        segments: [
          ButtonSegment(
            value: true,
            label: Text(
              'Yes',
            ),
          ),
          ButtonSegment(
            value: false,
            label: Text(
              'No',
            ),
          ),
        ],
        onSelectionChanged: (p0) =>
            onRequiresSomaticComponentChanged(p0.firstOrNull),
      ),
    );
  }

  Widget _buildMaterialComponentFilter() {
    return ListTile(
      leading: Icon(Icons.category),
      title: Text(
        'Material Component',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SegmentedButton<bool?>(
        emptySelectionAllowed: true,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        selected: {filters.requiresMaterialComponent},
        segments: [
          ButtonSegment(
            value: true,
            label: Text(
              'Yes',
            ),
          ),
          ButtonSegment(
            value: false,
            label: Text(
              'No',
            ),
          ),
        ],
        onSelectionChanged: (p0) =>
            onRequiresMaterialComponentChanged(p0.firstOrNull),
      ),
    );
  }

  Widget _buildSchoolFilter(
    BuildContext context,
  ) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(Icons.book),
          const SizedBox(width: 16),
          Text('School', style: Theme.of(context).textTheme.titleMedium),
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
    );
  }

  Widget _buildCastingTimeFilter(
    BuildContext context,
  ) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(Icons.timer),
          const SizedBox(width: 16),
          Text('Casting Time', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: allSpellModels
              .map((e) => e.castingTime)
              .where((castingTime) => castingTime != null)
              .toSet()
              .map((castingTime) {
            return FilterChip(
              visualDensity: VisualDensity.compact,
              label: Text(castingTime!.toString()),
              selected: filters.castingTimeIds.contains(castingTime.id),
              onSelected: (selected) {
                final updatedCastingTimeIds =
                    Set<String>.from(filters.castingTimeIds);
                if (selected) {
                  updatedCastingTimeIds.add(castingTime.id);
                } else {
                  updatedCastingTimeIds.remove(castingTime.id);
                }
                onCastingTimeChanged(updatedCastingTimeIds);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRangeFilter(
    BuildContext context,
  ) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(Icons.swap_calls),
          const SizedBox(width: 16),
          Text('Range', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: allSpellModels
              .map((e) => e.range)
              .where((range) => range != null)
              .toSet()
              .map((range) {
            return FilterChip(
              visualDensity: VisualDensity.compact,
              label: Text(range!.toString()),
              selected: filters.rangeIds.contains(range.id),
              onSelected: (selected) {
                final updatedRangeIds = Set<String>.from(filters.rangeIds);
                if (selected) {
                  updatedRangeIds.add(range.id);
                } else {
                  updatedRangeIds.remove(range.id);
                }
                onRangeChanged(updatedRangeIds);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationFilter(
    BuildContext context,
  ) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(Icons.timelapse),
          const SizedBox(width: 16),
          Text('Duration', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: allSpellModels
              .map((e) => e.duration)
              .where((duration) => duration != null)
              .toSet()
              .map((duration) {
            return FilterChip(
              visualDensity: VisualDensity.compact,
              label: Text(duration!.toString()),
              selected: filters.durationIds.contains(duration.id),
              onSelected: (selected) {
                final updatedDurationIds =
                    Set<String>.from(filters.durationIds);
                if (selected) {
                  updatedDurationIds.add(duration.id);
                } else {
                  updatedDurationIds.remove(duration.id);
                }
                onDurationChanged(updatedDurationIds);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSpellLevelFilter(
    BuildContext context,
  ) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(Icons.star),
          const SizedBox(width: 16),
          Text('Spell Level', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(10, (index) => index).map((level) {
            return FilterChip(
              visualDensity: VisualDensity.compact,
              label: Text(SpellUtils.spellLevelString(level)),
              selected: filters.spellLevels.contains(level),
              onSelected: (selected) {
                final updatedSpellLevels = Set<int>.from(filters.spellLevels);
                if (selected) {
                  updatedSpellLevels.add(level);
                } else {
                  updatedSpellLevels.remove(level);
                }
                onSpellLevelChanged(updatedSpellLevels);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  _buildSpellTypeFilter(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(Symbols.emoji_symbols),
          const SizedBox(width: 16),
          Text('Spell Type', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: SpellType.values.map((type) {
            return FilterChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(type.icon),
              label: Text(type.title),
              selected: filters.spellTypes.contains(type),
              onSelected: (selected) {
                final updatedSpellTypes =
                    Set<SpellType>.from(filters.spellTypes);
                if (selected) {
                  updatedSpellTypes.add(type);
                } else {
                  updatedSpellTypes.remove(type);
                }
                onSpellTypesChanged(updatedSpellTypes);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
