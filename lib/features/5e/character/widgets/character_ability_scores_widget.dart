import 'dart:developer' as dev;

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
        return null;
      },
      [abilityScores],
    );

    updateAbilityScore(
      Character5eAbilityScoreType abilityScoreType,
      int? abilityScore,
    ) async {
      final updatedAbilityScores = abilityScoresState.value.copyWith(
        abilityScores: {
          ...abilityScoresState.value.abilityScores,
          abilityScoreType: abilityScoresState
              .value.abilityScores[abilityScoreType]!
              .copyWith(
            value: () => abilityScore,
          ),
        },
      );

      await onChanged?.call(updatedAbilityScores);
    }

    updateModifier(
      Character5eAbilityScoreType abilityScoreType,
      int? modifier,
    ) async {
      final abilityScore =
          abilityScoresState.value.abilityScores[abilityScoreType]!;
      if (modifier == abilityScore.modifier ||
          modifier == abilityScore.modifierFromValue) {
        return;
      }
      final updatedAbilityScores = abilityScoresState.value.copyWith(
        abilityScores: {
          ...abilityScoresState.value.abilityScores,
          abilityScoreType: abilityScore.copyWith(
            manuallySetModifier: () => modifier,
          )
        },
      );

      await onChanged?.call(updatedAbilityScores);
    }

    updateSavingThrowModifier(
      Character5eAbilityScoreType abilityScoreType,
      int? savingThrowModifier,
    ) async {
      final abilityScore =
          abilityScoresState.value.abilityScores[abilityScoreType]!;
      if (savingThrowModifier == abilityScore.savingThrowModifier) {
        return;
      }
      final updatedAbilityScores = abilityScoresState.value.copyWith(
        abilityScores: {
          ...abilityScoresState.value.abilityScores,
          abilityScoreType: abilityScore.copyWith(
            manuallySetSavingThrowModifier: () => savingThrowModifier,
          )
        },
      );

      await onChanged?.call(updatedAbilityScores);
    }

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

                            updateAbilityScore(
                              abilityScoreType,
                              intValue,
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

                  final modifierEditingController = useTextEditingController();

                  updateModifierTextField() {
                    modifierEditingController.text = Modifier.display(
                      abilityScore.modifier.toString(),
                    );
                  }

                  useEffect(
                    () {
                      updateModifierTextField();
                      return null;
                    },
                    [
                      abilityScore.value,
                      abilityScore.modifier,
                      abilityScore.isModifierCustom,
                    ],
                  );

                  useEffect(
                    () {
                      focusNode.addListener(
                        () async {
                          dev.log('focusChanged');
                          if (!focusNode.hasFocus) {
                            final currentValue = modifierEditingController.text;
                            final intValue = int.tryParse(currentValue);

                            await updateModifier(
                              abilityScoreType,
                              intValue,
                            );

                            if (intValue == null &&
                                !abilityScore.isModifierCustom) {
                              updateModifierTextField();
                            }
                          }
                        },
                      );
                      return null;
                    },
                    [focusNode],
                  );

                  return Stack(
                    children: [
                      TextField(
                        focusNode: focusNode,
                        controller: modifierEditingController,
                        textAlign: TextAlign.center,
                        keyboardType: Modifier.textInputType,
                        inputFormatters: [Modifier.inputFormatter],
                        onChanged: (value) {
                          modifierEditingController.text =
                              Modifier.display(value);
                        },
                      ),
                      if (abilityScore.isModifierCustom)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              GameSystemViewModel.customValue.icon,
                              size: 10,
                            ),
                          ),
                        )
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

                  final savingThrowModifierEditingController =
                      useTextEditingController();

                  updateSavingThrowModifierText() {
                    savingThrowModifierEditingController.text =
                        Modifier.display(
                      abilityScore.savingThrowModifier.toString(),
                    );
                  }

                  useEffect(
                    () {
                      updateSavingThrowModifierText();
                      return null;
                    },
                    [
                      abilityScore.value,
                      abilityScore.modifier,
                      abilityScore.savingThrowModifier,
                      abilityScore.isSavingThrowModifierCustom,
                    ],
                  );

                  useEffect(
                    () {
                      focusNode.addListener(
                        () async {
                          if (!focusNode.hasFocus) {
                            final currentValue =
                                savingThrowModifierEditingController.text;
                            final intValue = int.tryParse(currentValue);

                            await updateSavingThrowModifier(
                              abilityScoreType,
                              intValue,
                            );

                            if (intValue == null &&
                                !abilityScore.isSavingThrowModifierCustom) {
                              updateSavingThrowModifierText();
                              return;
                            }
                          }
                        },
                      );
                      return null;
                    },
                    [focusNode],
                  );

                  return Stack(
                    children: [
                      TextField(
                        focusNode: focusNode,
                        controller: savingThrowModifierEditingController,
                        textAlign: TextAlign.center,
                        keyboardType: Modifier.textInputType,
                        inputFormatters: [Modifier.inputFormatter],
                        onChanged: (value) {
                          savingThrowModifierEditingController.text =
                              Modifier.display(value);
                        },
                      ),
                      if (abilityScore.isSavingThrowModifierCustom)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              GameSystemViewModel.customValue.icon,
                              size: 10,
                            ),
                          ),
                        )
                    ],
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
            verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  GameSystemViewModel.abilityScores.name,
                  textAlign: TextAlign.center,
                ),
                Icon(
                  GameSystemViewModel.abilityScores.icon,
                ),
              ],
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  GameSystemViewModel.modifier.name,
                  textAlign: TextAlign.center,
                ),
                Icon(
                  GameSystemViewModel.modifier.icon,
                ),
              ],
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  GameSystemViewModel.savingThrowModifier.name,
                  textAlign: TextAlign.center,
                ),
                Icon(
                  GameSystemViewModel.savingThrowModifier.icon,
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
