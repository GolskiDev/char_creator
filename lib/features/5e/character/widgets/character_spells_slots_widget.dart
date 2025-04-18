import 'package:char_creator/features/5e/character/models/character_5e_spell_slots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CharacterSpellsSlotsWidget extends HookConsumerWidget {
  final Character5eSpellSlots spellSlots;
  final ValueChanged<Character5eSpellSlots>? onChanged;
  final bool isEditing;

  const CharacterSpellsSlotsWidget.editing({
    super.key,
    required this.spellSlots,
    required this.onChanged,
  }) : isEditing = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spellSlotsState = useState(spellSlots);
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: spellSlots.spellSlots.entries.map(
        (spellSlotEntry) {
          final spellSlot = spellSlotEntry.value;
          final maxSpellSlotEditingController = useTextEditingController(
            text: spellSlot.maxSlots?.toString() ?? '',
          );
          final currentSlotsTextEditor = useTextEditingController(
            text: spellSlot.currentSlots?.toString() ?? '',
          );
          return ListTile(
            title: Text(spellSlot.level.level.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: maxSpellSlotEditingController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[-]?[0-9]*$'),
                      ),
                    ],
                    onChanged: (value) {
                      final intValue = int.tryParse(value);
                      if (intValue != null) {
                        final updatedAbilityScores =
                            spellSlotsState.value.copyWith(spellSlots: {
                          ...spellSlotsState.value.spellSlots,
                          spellSlot.level: spellSlot.copyWith(
                            maxSlots: intValue,
                          ),
                        });
                        spellSlotsState.value = updatedAbilityScores;
                      }
                    },
                    onSubmitted: (_) {
                      onChanged?.call(spellSlotsState.value);
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: currentSlotsTextEditor,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[-+]?[0-9]*$'),
                      ),
                    ],
                    onChanged: (value) {
                      final intValue = int.tryParse(value);
                      if (intValue != null) {
                        final updatedAbilityScores =
                            spellSlotsState.value.copyWith(
                          spellSlots: {
                            ...spellSlotsState.value.spellSlots,
                            spellSlot.level: spellSlot.copyWith(
                              currentSlots: intValue,
                            ),
                          },
                        );
                        spellSlotsState.value = updatedAbilityScores;
                      }
                    },
                    onSubmitted: (_) {
                      onChanged?.call(spellSlotsState.value);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
