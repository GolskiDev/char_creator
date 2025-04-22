import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../game_system_view_model.dart';
import '../models/character_5e_others.dart';

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
    return Column(
      children: [
        ListTile(
          title: Text(GameSystemViewModel.maxHp.name),
          leading: Icon(GameSystemViewModel.maxHp.icon),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: useTextEditingController(
                text: otherPropsState.value.maxHP?.toString() ?? '',
              ),
              onChanged: (value) {
                final intValue = int.tryParse(value);
                otherPropsState.value = otherPropsState.value.copyWith(
                  maxHP: () => intValue,
                );
              },
              onSubmitted: (_) {
                onChanged?.call(otherPropsState.value);
              },
            ),
          ),
        ),
        ListTile(
          title: Text(GameSystemViewModel.temporaryHp.name),
          leading: Icon(GameSystemViewModel.temporaryHp.icon),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: useTextEditingController(
                text: otherPropsState.value.temporaryHP?.toString() ?? '',
              ),
              onChanged: (value) {
                final intValue = int.tryParse(value);
                otherPropsState.value = otherPropsState.value.copyWith(
                  temporaryHP: () => intValue,
                );
              },
              onSubmitted: (_) {
                onChanged?.call(otherPropsState.value);
              },
            ),
          ),
        ),
        ListTile(
          title: Text(GameSystemViewModel.currentHp.name),
          leading: Icon(GameSystemViewModel.currentHp.icon),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: useTextEditingController(
                text: otherPropsState.value.currentHP?.toString() ?? '',
              ),
              onChanged: (value) {
                final intValue = int.tryParse(value);
                otherPropsState.value = otherPropsState.value.copyWith(
                  currentHP: () => intValue,
                );
              },
              onSubmitted: (_) {
                onChanged?.call(otherPropsState.value);
              },
            ),
          ),
        ),
        ListTile(
          title: Text(GameSystemViewModel.armorClass.name),
          leading: Icon(GameSystemViewModel.armorClass.icon),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: useTextEditingController(
                text: otherPropsState.value.ac?.toString() ?? '',
              ),
              onChanged: (value) {
                final intValue = int.tryParse(value);
                otherPropsState.value = otherPropsState.value.copyWith(
                  ac: () => intValue,
                );
              },
              onSubmitted: (_) {
                onChanged?.call(otherPropsState.value);
              },
            ),
          ),
        ),
        ListTile(
          title: Text(GameSystemViewModel.speed.name),
          leading: Icon(GameSystemViewModel.speed.icon),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: useTextEditingController(
                text: otherPropsState.value.currentSpeed?.toString() ?? '',
              ),
              onChanged: (value) {
                final intValue = int.tryParse(value);
                otherPropsState.value = otherPropsState.value.copyWith(
                  currentSpeed: () => intValue,
                );
              },
              onSubmitted: (_) {
                onChanged?.call(otherPropsState.value);
              },
            ),
          ),
        ),
        ListTile(
          title: Text(GameSystemViewModel.initiative.name),
          leading: Icon(GameSystemViewModel.initiative.icon),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: useTextEditingController(
                text: otherPropsState.value.initiative?.toString() ?? '',
              ),
              onChanged: (value) {
                final intValue = int.tryParse(value);
                otherPropsState.value = otherPropsState.value.copyWith(
                  initiative: () => intValue,
                );
              },
              onSubmitted: (_) {
                onChanged?.call(otherPropsState.value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
