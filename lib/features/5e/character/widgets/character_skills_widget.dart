import 'package:char_creator/features/5e/character/models/character_5e_skills.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/character_5e_ability_scores.dart';

class CharacterSkillsWidget extends HookConsumerWidget {
  final Character5eSkills skills;
  final Character5eAbilityScores abilityScores;
  final ValueChanged<Character5eSkills>? onChanged;
  final bool isEditing;

  const CharacterSkillsWidget.editing({
    super.key,
    required this.skills,
    required this.abilityScores,
    required this.onChanged,
  }) : isEditing = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsState = useState(skills);
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: skills.skills.entries.map(
        (skillEntry) {
          final skillsType = skillEntry.key;
          final skill = skillEntry.value;
          final skillsModifier = skillEntry.value.getModifier(abilityScores);
          final modifierEditingController = useTextEditingController(
            text: Modifier.display(
              skillsModifier,
            ),
          );
          return Card(
            child: ListTile(
              title: Text(skill.gameSystemViewModel.name),
              leading: Icon(skill.gameSystemViewModel.icon),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: modifierEditingController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[-+]?[0-9]*$'),
                        ),
                      ],
                      onChanged: (value) {
                        final intValue = int.tryParse(value);
                        final updatedSkills = skillsState.value.copyWith(
                          skills: {
                            ...skillsState.value.skills,
                            skillsType: skill.copyWith(
                              manuallySetModifier: () => intValue,
                            ),
                          },
                        );
                        skillsState.value = updatedSkills;
                        if (intValue != null) {
                          modifierEditingController.text =
                              Modifier.display(intValue);
                        }
                      },
                      onSubmitted: (_) {
                        onChanged?.call(skillsState.value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
