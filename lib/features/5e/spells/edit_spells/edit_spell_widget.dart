import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    Widget decriptionEditor() {
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

    Widget body() {
      return Column(
        children: [
          nameEditor(),
          decriptionEditor(),
          spellLevelEditor(),
        ],
      );
    }

    return body();
  }
}
