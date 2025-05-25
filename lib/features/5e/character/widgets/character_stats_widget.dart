import 'package:char_creator/features/5e/character/models/character_5e_model_v1.dart';
import 'package:char_creator/features/5e/character/repository/character_repository.dart';
import 'package:char_creator/features/5e/character/widgets/character_ability_scores_widget.dart';
import 'package:char_creator/features/5e/character/widgets/character_other_props_widget.dart';
import 'package:char_creator/features/5e/character/widgets/character_skills_widget.dart';
import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/character_5e_ability_scores.dart';
import '../models/character_5e_others.dart';
import '../models/character_5e_skills.dart';

class CharacterStatsWidget extends HookConsumerWidget {
  final Character5eModelV1 character;

  const CharacterStatsWidget({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCharacterState = useState(character);

    useEffect(
      () {
        currentCharacterState.value = character;
        return null;
      },
    );

    onOtherPropsChanged(Character5eOtherProps otherProps) async {
      final updatedCharacter = currentCharacterState.value.copyWith(
        others: otherProps,
      );
      final repository = await ref.read(characterRepositoryProvider.future);
      await repository.updateCharacter(updatedCharacter);
    }

    otherWidget() {
      if (character.others != null) {
        return CharacterOtherPropsWidget(
          characterOtherProps: character.others!,
          onChanged: onOtherPropsChanged,
        );
      }
    }

    onAbilityScoresChanged(
      Character5eAbilityScores abilityScores,
    ) async {
      final updatedCharacter = currentCharacterState.value.copyWith(
        abilityScores: abilityScores,
      );
      final repository = await ref.read(characterRepositoryProvider.future);
      await repository.updateCharacter(updatedCharacter);
    }

    abilityScoresWidget() {
      if (character.abilityScores != null) {
        return CharacterAbilityScoresWidget(
          abilityScores: character.abilityScores!,
          onChanged: onAbilityScoresChanged,
        );
      }
    }

    onSkillsChanged(
      Character5eSkills skills,
    ) async {
      final updatedCharacter = currentCharacterState.value.copyWith(
        character5eSkills: skills,
      );
      final repository = await ref.read(characterRepositoryProvider.future);
      await repository.updateCharacter(updatedCharacter);
    }

    skillsWidget() {
      if (character.abilityScores != null &&
          character.character5eSkills != null) {
        return Card.outlined(
          child: ExpansionTile(
            leading: Icon(
              GameSystemViewModel.skills.icon,
            ),
            title: Text(
              GameSystemViewModel.skills.name,
            ),
            childrenPadding: const EdgeInsets.all(8),
            children: [
              CharacterSkillsWidget(
                abilityScores: character.abilityScores!,
                skills: character.character5eSkills!,
                onChanged: onSkillsChanged,
              ),
            ],
          ),
        );
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            otherWidget() ?? const SizedBox(),
            abilityScoresWidget() ?? const SizedBox(),
            skillsWidget() ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
