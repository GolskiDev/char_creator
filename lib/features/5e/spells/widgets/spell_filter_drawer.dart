import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/spells/filters/spell_model_filters_state.dart';
import 'package:spells_and_tools/features/5e/spells/models/spell_school.dart';
import 'package:spells_and_tools/features/5e/spells/utils/spell_utils.dart';
import 'package:spells_and_tools/features/5e/tags.dart';

import '../../character/models/character_5e_class_model_v1.dart';
import '../../character/models/character_5e_model_v1.dart';
import '../../game_system_view_model.dart';
import '../view_models/spell_view_model.dart';

class SpellFilterDrawer extends HookConsumerWidget {
  final List<SpellViewModel> allSpellModels;
  final List<Character5eModelV1> characters;
  final SpellModelFiltersState filters;

  final Function(bool? requiresConcentration) onRequiresConcentrationChanged;
  final Function(bool? canBeCastAsRitual) onCanBeCastAsRitualChanged;
  final Function(bool? requiresVerbalComponent)
      onRequiresVerbalComponentChanged;
  final Function(bool? requiresSomaticComponent)
      onRequiresSomaticComponentChanged;
  final Function(bool? requiresMaterialComponent)
      onRequiresMaterialComponentChanged;
  final Function(Set<SpellSchool> selectedSchools) onSelectedSchoolsChanged;
  final Function(Set<String> castingTimeIds) onCastingTimeChanged;
  final Function(Set<String> rangeIds) onRangeChanged;
  final Function(Set<String> durationIds) onDurationChanged;
  final Function(Set<int> spellLevels) onSpellLevelChanged;
  final Function(Set<SpellType> spellTypes) onSpellTypesChanged;
  final Function(Set<ICharacter5eClassModelV1> characterClasses)
      onCharacterClassesChanged;
  final Function(Character5eModelV1? character) onCharacterChanged;

  const SpellFilterDrawer({
    super.key,
    required this.allSpellModels,
    required this.characters,
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
    required this.onCharacterClassesChanged,
    required this.onCharacterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: 350,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (characters.isNotEmpty) ...[
                Divider(),
                _buildCharacterFilter(context),
              ],
              Divider(),
              _buildSpellTypeFilter(context),
              Divider(),
              _buildSpellLevelFilter(context),
              Divider(),
              _buildClassTypeFilter(context),
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
      ),
    );
  }

  Widget _buildCharacterFilter(
    BuildContext context,
  ) {
    return ExpansionTile(
      initiallyExpanded: filters.character != null,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.character.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.character.name,
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: characters
              .map(
                (character) => FilterChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(character.name),
                  selected: filters.character == character,
                  onSelected: (selected) {
                    onCharacterChanged(selected ? character : null);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  bool get _isCharacterFilterUsed {
    return filters.character != null;
  }

  Widget _buildConcentrationFilter() {
    return ListTile(
      leading: Tooltip(
        message: GameSystemViewModel.concentration.name,
        child: Icon(GameSystemViewModel.concentration.icon),
      ),
      title: Text(
        GameSystemViewModel.concentration.name,
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
      leading: Icon(GameSystemViewModel.ritual.icon),
      title: Text(
        GameSystemViewModel.ritual.name,
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
      leading: Icon(GameSystemViewModel.verbalComponent.icon),
      title: Text(
        GameSystemViewModel.verbalComponent.name,
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
      leading: Icon(GameSystemViewModel.somaticComponent.icon),
      title: Text(
        GameSystemViewModel.somaticComponent.name,
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
      leading: Icon(GameSystemViewModel.materialComponent.icon),
      title: Text(
        GameSystemViewModel.materialComponent.name,
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
      initiallyExpanded: filters.selectedSchools.isNotEmpty,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.school.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.school.name,
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: allSpellModels
              .map((spell) => spell.school)
              .nonNulls
              .toSet()
              .map(
                (school) => FilterChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(school.name),
                  selected: filters.selectedSchools.contains(school),
                  onSelected: (selected) {
                    final updatedSchools =
                        Set<SpellSchool>.from(filters.selectedSchools);
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
      initiallyExpanded: filters.castingTimeIds.isNotEmpty,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.castingTime.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.castingTime.name,
              style: Theme.of(context).textTheme.titleMedium),
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
      initiallyExpanded: filters.rangeIds.isNotEmpty,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.range.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.range.name,
              style: Theme.of(context).textTheme.titleMedium),
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
      initiallyExpanded: filters.durationIds.isNotEmpty,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.duration.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.duration.name,
              style: Theme.of(context).textTheme.titleMedium),
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
      initiallyExpanded: filters.spellLevels.isNotEmpty,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.spellLevel.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.spellLevel.name,
              style: Theme.of(context).textTheme.titleMedium),
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

  Widget _buildSpellTypeFilter(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: filters.spellTypes.isNotEmpty,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.spellType.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.spellType.name,
              style: Theme.of(context).textTheme.titleMedium),
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

  Widget _buildClassTypeFilter(BuildContext context) {
    return ExpansionTile(
      enabled: !_isCharacterFilterUsed,
      initiallyExpanded: filters.characterClasses.isNotEmpty,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(GameSystemViewModel.characterClass.icon),
          const SizedBox(width: 16),
          Text(GameSystemViewModel.characterClass.name,
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      children: [
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: allSpellModels
              .expand((spell) => spell.characterClasses.toSet())
              .toSet()
              .map((characterClass) {
            return FilterChip(
              visualDensity: VisualDensity.compact,
              label: Text(characterClass.className.toString()),
              selected: filters.characterClasses.contains(characterClass),
              onSelected: (selected) {
                final updatedClasses = Set<ICharacter5eClassModelV1>.from(
                    filters.characterClasses);
                if (selected) {
                  updatedClasses.add(characterClass);
                } else {
                  updatedClasses.remove(characterClass);
                }
                onCharacterClassesChanged(updatedClasses);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
