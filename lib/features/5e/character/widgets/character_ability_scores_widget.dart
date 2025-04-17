import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/character_5e_ability_scores.dart';

class CharacterAbilityScoresWidget extends HookConsumerWidget {
  final Character5eAbilityScores abilityScores;
  final ValueChanged<Character5eAbilityScores>? onChanged;
  final bool isEditing;

  const CharacterAbilityScoresWidget.editing({
    super.key,
    required this.abilityScores,
    required this.onChanged,
  }) : isEditing = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abilityScoresState = useState(abilityScores);
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: abilityScores.abilityScores.entries.map(
        (abilityScoreEntry) {
          final abilityScoreType = abilityScoreEntry.key;
          final abilityScore = abilityScoreEntry.value;
          final textEditingController = useTextEditingController(
            text: abilityScore.value?.toString() ?? '',
          );
          return ListTile(
            title: Text(abilityScore.gameSystemViewModel.name),
            leading: Icon(abilityScore.gameSystemViewModel.icon),
            trailing: SizedBox(
              width: 50,
              height: 50,
              child: TextField(
                controller: textEditingController,
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
                        abilityScoresState.value.copyWith(abilityScores: {
                      ...abilityScoresState.value.abilityScores,
                      abilityScoreType: abilityScore.copyWith(value: intValue),
                    });
                    abilityScoresState.value = updatedAbilityScores;
                  }
                },
                onSubmitted: (_) {
                  onChanged?.call(abilityScoresState.value);
                },
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
