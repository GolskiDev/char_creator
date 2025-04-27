import 'package:char_creator/features/5e/character/models/character_5e_spell_slots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum CharacterSpellsSlotsWidgetDisplayMode {
  maxAndCurrent,
  current,
}

class CharacterSpellsSlotsWidget extends HookConsumerWidget {
  final Character5eSpellSlots spellSlots;
  final ValueChanged<Character5eSpellSlots>? onChanged;
  final CharacterSpellsSlotsWidgetDisplayMode mode;

  const CharacterSpellsSlotsWidget({
    required this.spellSlots,
    this.onChanged,
    this.mode = CharacterSpellsSlotsWidgetDisplayMode.maxAndCurrent,
    super.key,
  });

  /// You can edit both the max and current slots.
  const CharacterSpellsSlotsWidget.maxAndCurrent({
    super.key,
    required this.spellSlots,
    required this.onChanged,
  }) : mode = CharacterSpellsSlotsWidgetDisplayMode.maxAndCurrent;

  /// You can decrease the current slots, but not the max slots.
  const CharacterSpellsSlotsWidget.current({
    super.key,
    required this.spellSlots,
    required this.onChanged,
  }) : mode = CharacterSpellsSlotsWidgetDisplayMode.current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (mode == CharacterSpellsSlotsWidgetDisplayMode.current) {
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
                child: Card(
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
                            child: InkWell(
                              onTap: () {
                                final currentSlots =
                                    spellSlot.value.currentSlots;
                                if (currentSlots > 0) {
                                  onChanged?.call(
                                    spellSlots.copyWith(
                                      spellSlots: {
                                        ...spellSlots.spellSlots,
                                        spellSlot.key: spellSlot.value.copyWith(
                                          currentSlotsSetter: () =>
                                              currentSlots - 1,
                                        ),
                                      },
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                spellSlot.value.currentSlots.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Spell Level",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Max Slots",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Current Slots",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        ...spellSlots.spellSlots.entries.map(
          (spellSlot) {
            final spellSlotState =
                useState<Character5eSpellSlot>(spellSlot.value);
            final maxSpellSlotsController = useTextEditingController(
              text: spellSlotState.value.maxSlots.toString() ?? '0',
            );
            final currentSpellSlotsController = useTextEditingController(
              text: spellSlotState.value.currentSlots.toString() ?? '0',
            );
            return Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      spellSlot.key.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: maxSpellSlotsController,
                      onChanged: (value) {
                        final intValue = int.tryParse(value);
                        spellSlotState.value = spellSlot.value.copyWith(
                          maxSlotsSetter: () => intValue,
                        );
                        // maxSpellSlotsController.text =
                        //     intValue?.toString() ?? '';
                      },
                      onSubmitted: (_) {
                        onChanged?.call(
                          spellSlots.copyWith(
                            spellSlots: {
                              ...spellSlots.spellSlots,
                              spellSlot.key: spellSlot.value.copyWith(
                                maxSlotsSetter: () => spellSlots
                                    .spellSlots[spellSlot.key]?.maxSlots,
                              ),
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: Card.filled(
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: currentSpellSlotsController,
                        onChanged: (value) {
                          final intValue = int.tryParse(value);
                          spellSlotState.value = spellSlot.value.copyWith(
                            currentSlotsSetter: () => intValue,
                          );
                        },
                        onSubmitted: (_) {
                          onChanged?.call(
                            spellSlots.copyWith(
                              spellSlots: {
                                ...spellSlots.spellSlots,
                                spellSlot.key: spellSlot.value.copyWith(
                                  currentSlotsSetter: () => spellSlots
                                      .spellSlots[spellSlot.key]?.currentSlots,
                                ),
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
