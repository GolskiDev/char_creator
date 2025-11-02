import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/game_system_view_model.dart';

class EditSpellPage extends HookConsumerWidget {
  const EditSpellPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget nameEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Spell Name',
        ),
      );
    }

    Widget descriptionEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Spell Description',
        ),
        maxLines: null,
      );
    }

    Widget spellLevelEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Spell Level',
        ),
        keyboardType: TextInputType.number,
      );
    }

    Widget requiresConcentrationEditor() {
      final requiresConcentration = useState(false);
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
      final canBeCastAsRitual = useState(false);
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
      final requiresMaterialComponent = useState(false);
      final viewModel = GameSystemViewModel.verbalComponent;
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

    Widget requiresSomaticComponentEditor() {
      final requiresSomaticComponent = useState(false);
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
      final requiresMaterialComponent = useState(false);
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
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Material Component',
        ),
      );
    }

    Widget spellDurationEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Spell Duration',
        ),
      );
    }

    Widget spellRangeEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Spell Range',
        ),
      );
    }

    Widget SpellCastingTimeEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Spell Casting Time',
        ),
      );
    }

    Widget atHigherLevelsEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'At Higher Levels',
        ),
      );
    }

    Widget spellTypeEditor() {
      final textController = useTextEditingController();
      return TextField(
        controller: textController,
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
          materialComponentEditor(),
          spellDurationEditor(),
          spellRangeEditor(),
          SpellCastingTimeEditor(),
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
