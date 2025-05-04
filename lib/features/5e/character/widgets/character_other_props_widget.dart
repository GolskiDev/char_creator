import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    final inputType = TextInputType.numberWithOptions(
      signed: true,
      decimal: false,
    );
    final inputFormatters = [
      FilteringTextInputFormatter.digitsOnly,
    ];

    final widgets = [
      ScoreWidget(
        inputFormatters: inputFormatters,
        textInputType: inputType,
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
        inputFormatters: inputFormatters,
        textInputType: inputType,
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
        inputFormatters: inputFormatters,
        textInputType: inputType,
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
        inputFormatters: inputFormatters,
        textInputType: inputType,
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
        inputFormatters: inputFormatters,
        textInputType: inputType,
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
        inputFormatters: inputFormatters,
        textInputType: inputType,
        icon: GameSystemViewModel.initiative.icon,
        label: GameSystemViewModel.initiative.name,
        initialValue: otherPropsState.value.initiative,
        onChanged: (value) {
          otherPropsState.value = otherPropsState.value.copyWith(
            initiative: () => value,
          );
        },
      ),
    ];

    final numberOfColumns = MediaQuery.of(context).size.width ~/ 150;

    final rows = () {
      final rows = List<Widget>.empty(growable: true);
      List<Widget> widgetsCopy = List<Widget>.from(widgets);
      while (widgetsCopy.isNotEmpty) {
        final rowWidgets = widgetsCopy.take(numberOfColumns).toList();
        rows.add(
          Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: rowWidgets.map(
              (widget) {
                return Expanded(
                  child: widget,
                );
              },
            ).toList(),
          ),
        );
        widgetsCopy.removeRange(0, numberOfColumns);
      }
      return rows;
    }();

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: rows,
    );
  }
}
