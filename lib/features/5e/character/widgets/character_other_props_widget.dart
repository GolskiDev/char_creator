import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../game_system_view_model.dart';
import '../models/character_5e_others.dart';
import 'score_widget.dart';

class CharacterOtherPropsWidget extends HookConsumerWidget {
  final Character5eOtherProps characterOtherProps;
  final ValueChanged<Character5eOtherProps>? onChanged;
  const CharacterOtherPropsWidget({
    required this.characterOtherProps,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherPropsState = useState(characterOtherProps);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 8,
        runSpacing: 8,
        children: [
          ScoreWidget(
            icon: GameSystemViewModel.maxHp.icon,
            label: GameSystemViewModel.maxHp.name,
            initialValue: otherPropsState.value.maxHP,
            onChanged: (value) {
              otherPropsState.value = otherPropsState.value.copyWith(
                maxHP: () => value,
              );
            },
          ),
          ScoreWidget(
            icon: GameSystemViewModel.temporaryHp.icon,
            label: GameSystemViewModel.temporaryHp.name,
            initialValue: otherPropsState.value.temporaryHP,
            onChanged: (value) {
              otherPropsState.value = otherPropsState.value.copyWith(
                temporaryHP: () => value,
              );
            },
          ),
          ScoreWidget(
            icon: GameSystemViewModel.currentHp.icon,
            label: GameSystemViewModel.currentHp.name,
            initialValue: otherPropsState.value.currentHP,
            onChanged: (value) {
              otherPropsState.value = otherPropsState.value.copyWith(
                currentHP: () => value,
              );
            },
          ),
          ScoreWidget(
            icon: GameSystemViewModel.armorClass.icon,
            label: GameSystemViewModel.armorClass.name,
            initialValue: otherPropsState.value.ac,
            onChanged: (value) {
              otherPropsState.value = otherPropsState.value.copyWith(
                ac: () => value,
              );
            },
          ),
          ScoreWidget(
            icon: GameSystemViewModel.speed.icon,
            label: GameSystemViewModel.speed.name,
            initialValue: otherPropsState.value.currentSpeed,
            onChanged: (value) {
              otherPropsState.value = otherPropsState.value.copyWith(
                currentSpeed: () => value,
              );
            },
          ),
          ScoreWidget(
            icon: GameSystemViewModel.initiative.icon,
            label: GameSystemViewModel.initiative.name,
            initialValue: otherPropsState.value.initiative,
            onChanged: (value) {
              otherPropsState.value = otherPropsState.value.copyWith(
                initiative: () => value,
              );
            },
          ),
        ].map((e) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 150,
            ),
            child: e,
          );
        }).toList(),
      ),
    );
  }
}
