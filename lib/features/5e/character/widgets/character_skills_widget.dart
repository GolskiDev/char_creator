import 'package:char_creator/features/5e/character/models/character_5e_skills.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../game_system_view_model.dart';
import '../models/character_5e_ability_scores.dart';

class CharacterSkillsWidget extends HookConsumerWidget {
  final Character5eSkills skills;
  final Character5eAbilityScores abilityScores;
  final AsyncValueSetter<Character5eSkills>? onChanged;
  final bool isEditing;

  const CharacterSkillsWidget({
    super.key,
    required this.skills,
    required this.abilityScores,
    required this.onChanged,
  }) : isEditing = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...skills.skills.values.sorted(
          (a, b) {
            return a.skillType.name.compareTo(b.skillType.name);
          },
        ).map(
          (skillEntry) {
            final skill = skillEntry;

            final skillsModifier = skill.getModifier(abilityScores);
            final initialText = Modifier.display(skillsModifier.toString());

            return HookBuilder(
              builder: (context) {
                final skillState = useState(skill);

                final modifierEditingController = useTextEditingController(
                  text: initialText,
                );

                updateModifierTextField() {
                  final modifier = skill.getModifier(abilityScores);
                  modifierEditingController.text = Modifier.display(
                    modifier.toString(),
                  );
                }

                useEffect(
                  () => updateModifierTextField(),
                  [skillsModifier],
                );

                final focusNode = useFocusNode();

                useEffect(
                  () {
                    focusNode.addListener(
                      () async {
                        if (!focusNode.hasFocus) {
                          final updatedSkills = skills.copyWith(
                            skills: {
                              ...skills.skills,
                              skill.skillType: skillState.value,
                            },
                          );
                          await onChanged?.call(
                            updatedSkills,
                          );
                        }
                      },
                    );
                    return null;
                  },
                  [focusNode],
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: Text(skill.gameSystemViewModel.name),
                      leading: Icon(skill.gameSystemViewModel.icon),
                      trailing: SizedBox(
                        width: 70,
                        height: 50,
                        child: Card.filled(
                          child: Stack(
                            children: [
                              TextField(
                                focusNode: focusNode,
                                controller: modifierEditingController,
                                textAlign: TextAlign.center,
                                keyboardType: Modifier.textInputType,
                                inputFormatters: [Modifier.inputFormatter],
                                onChanged: (value) {
                                  final intValue = int.tryParse(value);
                                  skillState.value = skill.copyWith(
                                    manuallySetModifier: () => intValue,
                                  );
                                },
                              ),
                              if (skill.isCustomModifierUsed)
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
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
