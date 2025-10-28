import 'package:spells_and_tools/features/5e/game_system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/character_5e_spell_slots.dart';

class CharacterEditSpellSlotsWidget extends HookConsumerWidget {
  final Character5eSpellSlots spellSlots;
  final ValueChanged<Character5eSpellSlots> onChanged;

  const CharacterEditSpellSlotsWidget({
    required this.spellSlots,
    required this.onChanged,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spellSlotsState = useState<Character5eSpellSlots>(spellSlots);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onChanged.call(spellSlotsState.value);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(GameSystemViewModel.spellSlots.name),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Icon(
                      GameSystemViewModel.spellSlots.icon,
                    ),
                    title: Text(
                      "Restore Spell Slots",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    trailing: Icon(
                      Icons.refresh,
                    ),
                    onTap: () {
                      spellSlotsState.value = spellSlotsState.value.copyWith(
                        spellSlots: {
                          for (var entry
                              in spellSlotsState.value.spellSlots.entries)
                            entry.key: entry.value.copyWith(
                              currentSlotsSetter: () => entry.value.maxSlots,
                            ),
                        },
                      );
                      onChanged.call(spellSlotsState.value);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Card.outlined(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Spell Level",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...spellSlotsState.value.spellSlots.entries.map(
                          (spellSlot) {
                            final maxSpellSlotsController =
                                useTextEditingController(
                              text: spellSlot.value.maxSlots.toString(),
                            );
                            final currentSpellSlotsController =
                                useTextEditingController(
                              text: spellSlot.value.currentSlots.toString(),
                            );
                            return Card.outlined(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      spellSlot.key.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
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
                                        spellSlotsState.value =
                                            spellSlotsState.value.copyWith(
                                          spellSlots: {
                                            ...spellSlotsState.value.spellSlots,
                                            spellSlot.key:
                                                spellSlot.value.copyWith(
                                              maxSlotsSetter: () => intValue,
                                            ),
                                          },
                                        );
                                      },
                                      onSubmitted: (_) {
                                        onChanged.call(
                                          spellSlots.copyWith(
                                            spellSlots: spellSlotsState
                                                .value.spellSlots,
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
                                          spellSlotsState.value =
                                              spellSlotsState.value.copyWith(
                                            spellSlots: {
                                              ...spellSlotsState
                                                  .value.spellSlots,
                                              spellSlot.key:
                                                  spellSlot.value.copyWith(
                                                currentSlotsSetter: () =>
                                                    intValue,
                                              ),
                                            },
                                          );
                                        },
                                        onSubmitted: (_) {
                                          onChanged.call(
                                            spellSlots.copyWith(
                                              spellSlots: spellSlotsState
                                                  .value.spellSlots,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
