import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/character_5e_ability_scores.dart';

class CharacterAbilityScoresWidget extends HookConsumerWidget {
  final Character5eAbilityScores abilityScores;
  final AsyncValueSetter<Character5eAbilityScores>? onChanged;
  final bool isEditing;

  const CharacterAbilityScoresWidget({
    super.key,
    required this.abilityScores,
    required this.onChanged,
  }) : isEditing = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abilityScoresState = useState(abilityScores);

    useEffect(
      () {
        abilityScoresState.value = abilityScores;
      },
      [abilityScores],
    );

    TableRow abilityScoreRow({
      required Character5eAbilityScore abilityScore,
    }) {
      final abilityScoreType = abilityScore.abilityScoreType;

      return TableRow(
        children: [
          ListTile(
            title: Text(abilityScore.gameSystemViewModel.name),
            leading: Icon(abilityScore.gameSystemViewModel.icon),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              child: HookBuilder(
                builder: (context) {
                  final abilityScoreEditingController =
                      useTextEditingController(
                    text: abilityScore.value?.toString() ?? '',
                  );

                  final focusNode = useFocusNode();

                  useEffect(
                    () {
                      focusNode.addListener(
                        () async {
                          if (!focusNode.hasFocus) {
                            final currentValue =
                                abilityScoreEditingController.text;

                            final intValue = int.tryParse(currentValue);

                            final updatedAbilityScores =
                                abilityScoresState.value.copyWith(
                              abilityScores: {
                                ...abilityScoresState.value.abilityScores,
                                abilityScoreType: abilityScore.copyWith(
                                  value: () => intValue,
                                ),
                              },
                            );

                            await onChanged?.call(
                              updatedAbilityScores,
                            );
                          }
                        },
                      );
                      return null;
                    },
                    [focusNode],
                  );

                  return TextField(
                    focusNode: focusNode,
                    controller: abilityScoreEditingController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[-]?[0-9]*$'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Card(
              child: HookBuilder(
                builder: (context) {
                  final focusNode = useFocusNode();

                  final modifierEditingController = useTextEditingController(
                    text: Modifier.display(
                      abilityScore.modifier,
                    ),
                  );

                  updateModifierTextField() {
                    modifierEditingController.text = Modifier.display(
                      abilityScore.modifier,
                    );
                  }

                  useEffect(
                    () {
                      updateModifierTextField();
                      return null;
                    },
                    [abilityScore.value, abilityScore.modifier],
                  );

                  useEffect(
                    () {
                      focusNode.addListener(() async {
                        if (!focusNode.hasFocus) {
                          final currentValue = modifierEditingController.text;
                          final intValue = int.tryParse(currentValue);
                          final updatedAbilityScores =
                              abilityScoresState.value.copyWith(
                            abilityScores: {
                              ...abilityScoresState.value.abilityScores,
                              abilityScoreType: abilityScore.copyWith(
                                manuallySetModifier: () => intValue,
                              ),
                            },
                          );

                          await onChanged?.call(updatedAbilityScores);
                        }
                      });
                      return null;
                    },
                    [focusNode],
                  );

                  return TextField(
                    focusNode: focusNode,
                    controller: modifierEditingController,
                    textAlign: TextAlign.center,
                    keyboardType: Modifier.textInputType,
                    inputFormatters: [Modifier.inputFormatter],
                    onChanged: (value) {
                      final intValue = int.tryParse(value);
                      if (intValue == null) {
                        // text will be updated in updateModifierTextField
                      } else {
                        // we want to update the text field with the display value
                        modifierEditingController.text =
                            Modifier.display(intValue);
                      }
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Card(
              child: HookBuilder(
                builder: (context) {
                  final focusNode = useFocusNode();

                  final savingThrowModifierEditingController =
                      useTextEditingController(
                    text: Modifier.display(
                      abilityScore.savingThrowModifier,
                    ),
                  );

                  updateModifierTextField() {
                    savingThrowModifierEditingController.text =
                        Modifier.display(
                      abilityScore.savingThrowModifier,
                    );
                  }

                  useEffect(
                    () {
                      updateModifierTextField();
                      return null;
                    },
                    [abilityScore.modifier, abilityScore.savingThrowModifier],
                  );

                  useEffect(
                    () {
                      focusNode.addListener(() async {
                        if (!focusNode.hasFocus) {
                          final currentValue =
                              savingThrowModifierEditingController.text;
                          final intValue = int.tryParse(currentValue);
                          final updatedAbilityScores =
                              abilityScoresState.value.copyWith(
                            abilityScores: {
                              ...abilityScoresState.value.abilityScores,
                              abilityScoreType: abilityScore.copyWith(
                                manuallySetSavingThrowModifier: () => intValue,
                              ),
                            },
                          );

                          await onChanged?.call(updatedAbilityScores);
                        }
                      });
                      return null;
                    },
                    [focusNode],
                  );

                  return TextField(
                    focusNode: focusNode,
                    controller: savingThrowModifierEditingController,
                    textAlign: TextAlign.center,
                    keyboardType: Modifier.textInputType,
                    inputFormatters: [Modifier.inputFormatter],
                    onChanged: (value) {
                      final intValue = int.tryParse(value);
                      if (intValue == null) {
                        // text will be updated in updateModifierTextField
                      } else {
                        savingThrowModifierEditingController.text =
                            Modifier.display(intValue);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    final legend = [
      TableRow(
        children: [
          SizedBox.shrink(),
          TableCell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      GameSystemViewModel.abilityScores.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Icon(
                      GameSystemViewModel.abilityScores.icon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      GameSystemViewModel.modifier.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Icon(
                      GameSystemViewModel.modifier.icon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Flexible(
                    child: Text(
                      GameSystemViewModel.savingThrowModifier.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Flexible(
                    child: Icon(
                      GameSystemViewModel.savingThrowModifier.icon,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    ];

    return Table(
      columnWidths: {
        0: const IntrinsicColumnWidth(),
        1: const FlexColumnWidth(1),
        2: const FlexColumnWidth(1),
        3: const FlexColumnWidth(1),
      },
      children: [
        ...legend,
        ...abilityScoresState.value.abilityScores.entries.map(
          (entry) => abilityScoreRow(abilityScore: entry.value),
        )
      ].toList(),
    );
  }
}
