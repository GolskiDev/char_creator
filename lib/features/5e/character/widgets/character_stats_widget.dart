import 'package:char_creator/features/5e/character/models/character_5e_model_v1.dart';
import 'package:char_creator/features/5e/character/repository/character_repository.dart';
import 'package:char_creator/features/5e/character/widgets/character_ability_scores_widget.dart';
import 'package:char_creator/features/5e/character/widgets/character_other_props_widget.dart';
import 'package:char_creator/features/5e/character/widgets/character_skills_widget.dart';
import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CharacterStatsWidget extends HookConsumerWidget {
  final Character5eModelV1 character;

  const CharacterStatsWidget({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final other = () {
      if (character.others != null) {
        return CharacterOtherPropsWidget(
          characterOtherProps: character.others!,
          onChanged: (value) {
            ref.read(characterRepositoryProvider).updateCharacter(
                  character.copyWith(
                    others: value,
                  ),
                );
          },
        );
      }
    }();

    final abilityScores = () {
      if (character.abilityScores != null) {
        return CharacterAbilityScoresWidget(
          abilityScores: character.abilityScores!,
          onChanged: (value) {
            return ref.read(characterRepositoryProvider).updateCharacter(
                  character.copyWith(
                    abilityScores: value,
                  ),
                );
          },
        );
      }
    }();

    final skills = () {
      if (character.abilityScores != null &&
          character.character5eSkills != null) {
        return Card(
          child: ExpansionTile(
            leading: Icon(
              GameSystemViewModel.skills.icon,
            ),
            title: Text(
              GameSystemViewModel.skills.name,
            ),
            childrenPadding: const EdgeInsets.all(8),
            children: [
              CharacterSkillsWidget.editing(
                abilityScores: character.abilityScores!,
                skills: character.character5eSkills!,
                onChanged: (value) {
                  ref.read(characterRepositoryProvider).updateCharacter(
                        character.copyWith(
                          character5eSkills: value,
                        ),
                      );
                },
              ),
            ],
          ),
        );
      }
    }();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            if (other != null) other,
            if (abilityScores != null) abilityScores,
            if (skills != null) skills,
          ],
        ),
      ),
    );
  }
}
