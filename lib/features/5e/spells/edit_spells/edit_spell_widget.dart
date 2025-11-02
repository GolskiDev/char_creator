import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/game_system_view_model.dart';

import '../utils/spell_utils.dart';

class EditSpellPage extends HookConsumerWidget {
  const EditSpellPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Extracted controllers and state
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final spellLevel = useState<int?>(null);
    final materialComponentController = useTextEditingController();
    final spellDurationController = useTextEditingController();
    final spellRangeController = useTextEditingController();
    final spellCastingTimeController = useTextEditingController();
    final atHigherLevelsController = useTextEditingController();
    final spellTypeController = useTextEditingController();

    final requiresConcentration = useState(false);
    final canBeCastAsRitual = useState(false);
    final requiresVerbalComponent = useState(false);
    final requiresSomaticComponent = useState(false);
    final requiresMaterialComponent = useState(false);

    final textFieldPadding = const EdgeInsets.only(
      top: 8.0,
      bottom: 2.0,
    );

    Widget nameEditor() {
      return Padding(
        padding: textFieldPadding,
        child: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Spell Name',
          ),
        ),
      );
    }

    Widget descriptionEditor() {
      return Padding(
        padding: textFieldPadding,
        child: TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Spell Description',
          ),
          maxLines: null,
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
        padding: textFieldPadding,
        child: DropdownButtonFormField<int>(
          decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon(icon),
          ),
          initialValue: null,
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
        ),
      );
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
      return TextField(
        controller: materialComponentController,
        decoration: const InputDecoration(
          labelText: 'Material Component',
        ),
      );
    }

    Widget spellDurationEditor() {
      return TextField(
        controller: spellDurationController,
        decoration: const InputDecoration(
          labelText: 'Spell Duration',
        ),
      );
    }

    Widget spellRangeEditor() {
      return TextField(
        controller: spellRangeController,
        decoration: const InputDecoration(
          labelText: 'Spell Range',
        ),
      );
    }

    Widget spellCastingTimeEditor() {
      return TextField(
        controller: spellCastingTimeController,
        decoration: const InputDecoration(
          labelText: 'Spell Casting Time',
        ),
      );
    }

    Widget atHigherLevelsEditor() {
      return TextField(
        controller: atHigherLevelsController,
        decoration: const InputDecoration(
          labelText: 'At Higher Levels',
        ),
      );
    }

    Widget spellTypeEditor() {
      return TextField(
        controller: spellTypeController,
        decoration: const InputDecoration(
          labelText: 'Spell Type',
        ),
      );
    }

    Widget body() {
      return Column(
        children: [
          nameEditor(),
          Flexible(
            child: descriptionEditor(),
          ),
          spellLevelEditor(),
          requiresConcentrationEditor(),
          canBeCastAsRitualEditor(),
          requiresVerbalComponentEditor(),
          requiresSomaticComponentEditor(),
          requiresMaterialComponentEditor(),
          if (requiresMaterialComponent.value) materialComponentEditor(),
          spellDurationEditor(),
          spellRangeEditor(),
          spellCastingTimeEditor(),
          atHigherLevelsEditor(),
          spellTypeEditor(),
        ]
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: widget,
                ),
              ),
            )
            .toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Spell'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: body(),
        ),
      ),
    );
  }
}
