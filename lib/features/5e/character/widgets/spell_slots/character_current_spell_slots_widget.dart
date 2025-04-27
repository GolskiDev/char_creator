import 'package:char_creator/features/5e/character/models/character_5e_spell_slots.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CharacterCurrentSpellSlotsWidget extends HookConsumerWidget {
  final Character5eSpellSlots spellSlots;
  final ValueChanged<Character5eSpellSlots> onChanged;

  const CharacterCurrentSpellSlotsWidget({
    required this.spellSlots,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: spellSlots.spellSlots.entries
          .where((spellSlotEntry) => spellSlotEntry.value.maxSlots > 0)
          .map(
        (spellSlot) {
          return Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 64,
              ),
              child: Card.outlined(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    final currentSlots = spellSlot.value.currentSlots;
                    if (currentSlots > 0) {
                      onChanged.call(
                        spellSlots.copyWith(
                          spellSlots: {
                            ...spellSlots.spellSlots,
                            spellSlot.key: spellSlot.value.copyWith(
                              currentSlotsSetter: () => currentSlots - 1,
                            ),
                          },
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          spellSlot.key.level.toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card.filled(
                            clipBehavior: Clip.antiAlias,
                            child: Text(
                              spellSlot.value.currentSlots.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
