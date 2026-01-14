import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/game_system_view_model.dart';
import 'package:spells_and_tools/features/5e/spells/models/spell_casting_time.dart';
import 'package:spells_and_tools/features/5e/spells/models/spell_duration.dart';
import 'package:spells_and_tools/features/5e/spells/models/spell_range.dart';
import 'package:spells_and_tools/features/5e/tags.dart';

import '../models/base_spell_model.dart';
import '../user_spells_repository.dart/user_spells_repository.dart';
import '../utils/spell_utils.dart';

class EditSpellPage extends HookConsumerWidget {
  const EditSpellPage({
    this.spellId,
    super.key,
  });
  final String? spellId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spells = ref.watch(userSpellsProvider).asData?.value ?? [];
    final theSpell = spells.firstWhereOrNull((spell) => spell.id == spellId);
    final isEditing = theSpell != null;

    final spell = theSpell?.spell;

    final formState = useState(
      GlobalKey<FormState>(),
    );
    final nameController = useTextEditingController(
      text: spell?.name,
    );
    final descriptionController = useTextEditingController(
      text: spell?.description,
    );
    final spellLevel = useState<int?>(
      spell?.spellLevel,
    );
    final materialComponentController = useTextEditingController(
      text: spell?.material ?? ' ',
    );
    final spellDurationController = useState<SpellDuration?>(
      spell?.duration,
    );
    final spellRangeController = useState<SpellRange?>(
      spell?.range,
    );
    final spellCastingTimeController = useState<SpellCastingTime?>(
      spell?.castingTime,
    );
    final atHigherLevelsController = useTextEditingController(
      text: spell?.atHigherLevels,
    );
    final spellTypeController = useState<Set<SpellType>>(
      <SpellType>{
        if (spell != null) ...spell.spellTypes,
      },
    );

    final requiresConcentration = useState(
      spell?.requiresConcentration ?? false,
    );
    final canBeCastAsRitual = useState(
      spell?.canBeCastAsRitual ?? false,
    );
    final requiresVerbalComponent = useState(
      spell?.requiresVerbalComponent ?? false,
    );
    final requiresSomaticComponent = useState(
      spell?.requiresSomaticComponent ?? false,
    );
    final requiresMaterialComponent = useState(
      spell?.requiresMaterialComponent ?? false,
    );

    final padding = const EdgeInsets.only(
      top: 8.0,
      bottom: 2.0,
    );

    Widget nameEditor() {
      final viewModel = GameSystemViewModel.name;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return ListTile(
        leading: Icon(icon),
        title: TextFormField(
          validator: BaseSpellModel.validateName,
          controller: nameController,
          decoration: InputDecoration(
            labelText: title,
          ),
        ),
      );
    }

    Widget descriptionEditor() {
      final viewModel = GameSystemViewModel.description;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return ListTile(
        leading: Icon(icon),
        title: TextFormField(
          minLines: 1,
          validator: BaseSpellModel.validateDescription,
          maxLines: 50,
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: title,
          ),
        ),
      );
    }

    Widget spellLevelEditor() {
      final availableSpellLevels = List<int>.generate(10, (index) => index);
      final viewModel = GameSystemViewModel.spellLevel;
      final title = viewModel.name;
      final icon = viewModel.icon;
      levelFormatter(int level) => SpellUtils.spellLevelString(level);
      return Padding(
          padding: padding,
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: title,
              prefixIcon: Icon(icon),
            ),
            validator: BaseSpellModel.validateSpellLevel,
            initialValue: spellLevel.value,
            items: availableSpellLevels
                .map(
                  (level) => DropdownMenuItem<int>(
                    value: level,
                    child: Text(levelFormatter(level)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              spellLevel.value = value;
            },
          ));
    }

    Widget requiresConcentrationEditor() {
      final viewModel = GameSystemViewModel.concentration;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return SwitchListTile(
        thumbIcon: WidgetStateProperty.all(
          Icon(icon),
        ),
        title: Text(title),
        value: requiresConcentration.value,
        onChanged: (value) {
          requiresConcentration.value = value;
        },
      );
    }

    Widget canBeCastAsRitualEditor() {
      final viewModel = GameSystemViewModel.ritual;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return SwitchListTile(
        thumbIcon: WidgetStateProperty.all(
          Icon(icon),
        ),
        title: Text(title),
        value: canBeCastAsRitual.value,
        onChanged: (value) {
          canBeCastAsRitual.value = value;
        },
      );
    }

    Widget requiresVerbalComponentEditor() {
      final viewModel = GameSystemViewModel.verbalComponent;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return SwitchListTile(
        title: Text(title),
        thumbIcon: WidgetStateProperty.all(
          Icon(icon),
        ),
        value: requiresVerbalComponent.value,
        onChanged: (value) {
          requiresVerbalComponent.value = value;
        },
      );
    }

    Widget requiresSomaticComponentEditor() {
      final viewModel = GameSystemViewModel.somaticComponent;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return SwitchListTile(
        title: Text(title),
        thumbIcon: WidgetStateProperty.all(
          Icon(icon),
        ),
        value: requiresSomaticComponent.value,
        onChanged: (value) {
          requiresSomaticComponent.value = value;
        },
      );
    }

    Widget requiresMaterialComponentEditor() {
      final viewModel = GameSystemViewModel.materialComponent;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return SwitchListTile(
        title: Text(title),
        thumbIcon: WidgetStateProperty.all(
          Icon(icon),
        ),
        value: requiresMaterialComponent.value,
        onChanged: (value) {
          requiresMaterialComponent.value = value;
        },
      );
    }

    Widget materialComponentEditor() {
      final viewModel = GameSystemViewModel.materialComponent;
      final title = viewModel.name;
      final icon = viewModel.icon;

      return ListTile(
        leading: Icon(icon),
        title: TextField(
          controller: materialComponentController,
          maxLength: BaseSpellModel.maxMaterialLength,
          decoration: InputDecoration(
            labelText: title,
          ),
        ),
      );
    }

    Widget spellDurationEditor() {
      final viewModel = GameSystemViewModel.duration;
      final availableDurations =
          SpellDuration.all.sorted((a, b) => a.compareTo(b));
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
            spellDurationController.value == null ? EdgeInsets.zero : padding,
        child: DropdownButtonFormField<SpellDuration>(
          decoration: InputDecoration(
            labelText: viewModel.name,
            prefixIcon: Icon(viewModel.icon),
          ),
          initialValue: spellDurationController.value,
          items: availableDurations
              .map(
                (duration) => DropdownMenuItem<SpellDuration>(
                  value: duration,
                  child: Text(duration.toString()),
                ),
              )
              .toList(),
          onChanged: (value) {
            spellDurationController.value = value;
          },
        ),
      );
    }

    Widget spellRangeEditor() {
      final viewModel = GameSystemViewModel.range;
      final title = viewModel.name;
      final icon = viewModel.icon;
      final availableRanges = SpellRange.all.sorted((a, b) => a.compareTo(b));
      return Padding(
        padding: padding,
        child: DropdownButtonFormField<SpellRange>(
          decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon(icon),
          ),
          initialValue: spellRangeController.value,
          items: availableRanges
              .map(
                (range) => DropdownMenuItem<SpellRange>(
                  value: range,
                  child: Text(range.toString()),
                ),
              )
              .toList(),
          onChanged: (value) {
            spellRangeController.value = value;
          },
        ),
      );
    }

    Widget spellCastingTimeEditor() {
      final viewModel = GameSystemViewModel.castingTime;
      final title = viewModel.name;
      final icon = viewModel.icon;
      final availableSpellingTimes =
          SpellCastingTime.all.sorted((a, b) => a.compareTo(b));
      return Padding(
        padding: padding,
        child: DropdownButtonFormField<SpellCastingTime>(
          decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon(icon),
          ),
          initialValue: spellCastingTimeController.value,
          items: availableSpellingTimes
              .map(
                (castingTime) => DropdownMenuItem<SpellCastingTime>(
                  value: castingTime,
                  child: Text(
                    castingTime.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            spellCastingTimeController.value = value;
          },
        ),
      );
    }

    Widget atHigherLevelsEditor() {
      final viewModel = GameSystemViewModel.atHigherLevels;
      final title = viewModel.name;
      final icon = viewModel.icon;
      return ListTile(
        leading: Icon(icon),
        title: TextField(
          controller: atHigherLevelsController,
          decoration: InputDecoration(
            labelText: title,
          ),
        ),
      );
    }

    Widget spellTypeEditor() {
      final viewModel = GameSystemViewModel.spellType;
      final title = viewModel.name;
      final icon = viewModel.icon;
      final availableSpellTypes = SpellType.values;
      spellTypeFormatter(SpellType type) => type.title;
      return Padding(
        padding: padding,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon(icon),
          ),
          child: Wrap(
            spacing: 8.0,
            children: availableSpellTypes.map((type) {
              final isSelected = spellTypeController.value.contains(type);
              return FilterChip(
                avatar: Icon(type.icon),
                label: Text(spellTypeFormatter(type)),
                selected: isSelected,
                onSelected: (selected) {
                  final newSet = Set<SpellType>.from(spellTypeController.value);
                  if (selected) {
                    newSet.add(type);
                  } else {
                    newSet.remove(type);
                  }
                  spellTypeController.value = newSet;
                },
              );
            }).toList(),
          ),
        ),
      );
    }

    Widget body() {
      final children = [
        nameEditor(),
        descriptionEditor(),
        spellLevelEditor(),
        spellCastingTimeEditor(),
        requiresConcentrationEditor(),
        canBeCastAsRitualEditor(),
        requiresVerbalComponentEditor(),
        requiresSomaticComponentEditor(),
        requiresMaterialComponentEditor(),
        if (requiresMaterialComponent.value) materialComponentEditor(),
        spellDurationEditor(),
        spellRangeEditor(),
        atHigherLevelsEditor(),
        spellTypeEditor(),
      ];
      return Form(
        key: formState.value,
        child: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          itemCount: children.length,
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: children[index],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 4.0,
            );
          },
        ),
      );
    }

    final save = GameSystemViewModel.save;

    saveSpell() async {
      if (formState.value.currentState?.validate() ?? false) {
        final repository = await ref.watch(userSpellsRepositoryProvider.future);
        if (repository == null) {
          return;
        }
        final name = nameController.text;
        final description = descriptionController.text;
        final lvl = spellLevel.value;
        final material = materialComponentController.text.isEmpty
            ? null
            : materialComponentController.text;
        final atHigherLevels = atHigherLevelsController.text.isEmpty
            ? null
            : atHigherLevelsController.text;
        if (lvl == null) {
          return;
        }

        final newSpell = BaseSpellModel(
          name: name,
          description: description,
          spellLevel: lvl,
          canBeCastAsRitual: canBeCastAsRitual.value,
          requiresConcentration: requiresConcentration.value,
          requiresVerbalComponent: requiresVerbalComponent.value,
          requiresSomaticComponent: requiresSomaticComponent.value,
          requiresMaterialComponent: requiresMaterialComponent.value,
          material: requiresMaterialComponent.value ? material : null,
          duration: spellDurationController.value,
          range: spellRangeController.value,
          castingTime: spellCastingTimeController.value,
          atHigherLevels: atHigherLevels,
          spellTypes: spellTypeController.value,
        );

        if (isEditing) {
          final userSpell = theSpell.copyWith(
            spell: spell,
          );
          await repository.updateSpell(userSpell);
          if (context.mounted) {
            context.pop();
          }
        } else {
          final id = await repository.addSpell(newSpell);
          if (context.mounted) {
            context.go('/spells/$id');
          }
        }
      }
    }

    deleteSpell() async {
      if (isEditing) {
        final repository = await ref.watch(userSpellsRepositoryProvider.future);
        if (repository == null) {
          return;
        }
        await repository.deleteSpell(theSpell.id);
        if (context.mounted) {
          context.go('/spells');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Spell' : 'New Spell',
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await deleteSpell();
              },
            ),
          IconButton(
            icon: Icon(save.icon),
            tooltip: save.name,
            onPressed: () async {
              await saveSpell();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: body(),
      ),
    );
  }
}
