import 'dart:convert';
import 'dart:developer';

import 'package:char_creator/features/5e/character/models/character_5e_spell_slots.dart';
import 'package:char_creator/features/5e/character/repository/character_classes_repository.dart';
import 'package:char_creator/features/5e/character/widgets/spell_slots/character_current_spell_slots_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UtilsPage extends HookConsumerWidget {
  const UtilsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('New Screen'),
            onTap: () {
              showNewScreen(context, ref);
            },
          ),
          ListTile(
            title: const Text('print'),
            onTap: () {
              debugPrint(context, ref);
            },
          ),
        ],
      ),
    );
  }

  showNewScreen(
    BuildContext context,
    WidgetRef ref,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewScreen(),
      ),
    );
  }

  debugPrint(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final characterClasses =
        await ref.read(characterClassesStreamProvider.future);
    characterClasses.forEach(
      (element) {
        final json = jsonEncode(element.toMap());
        log(json);
      },
    );
  }
}

class NewScreen extends HookConsumerWidget {
  const NewScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useState(
      Character5eSpellSlots(
        spellSlots: {
          Character5eSpellSlotLevel.first: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.first,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.second: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.second,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.third: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.third,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.fourth: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.fourth,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.fifth: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.fifth,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.sixth: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.sixth,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.seventh: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.seventh,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.eighth: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.eighth,
            maxSlots: 2,
            currentSlots: 2,
          ),
          Character5eSpellSlotLevel.ninth: Character5eSpellSlot(
            level: Character5eSpellSlotLevel.ninth,
            maxSlots: 2,
            currentSlots: 2,
          ),
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CharacterCurrentSpellSlotsWidget(
          spellSlots: state.value,
          onChanged: (value) {
            state.value = value;
          },
        ),
      ),
    );
  }
}
