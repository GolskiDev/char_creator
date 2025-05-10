import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../game_system_view_model.dart';
import '../models/character_5e_others.dart';
import 'score_widget.dart';

class CharacterOtherPropsWidget extends HookConsumerWidget {
  final Character5eOtherProps characterOtherProps;
  final AsyncValueSetter<Character5eOtherProps>? onChanged;
  const CharacterOtherPropsWidget({
    required this.characterOtherProps,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputType = TextInputType.numberWithOptions(
      signed: true,
      decimal: false,
    );

    final inputFormatters = [
      FilteringTextInputFormatter.allow(
        RegExp(r'^[-]?[0-9]*$'),
      ),
      LengthLimitingTextInputFormatter(3),
    ];

    final widgets = [
      ScoreWidget(
        inputFormatters: inputFormatters,
        textInputType: inputType,
        icon: GameSystemViewModel.maxHp.icon,
        label: GameSystemViewModel.maxHp.name,
        initialValue: characterOtherProps.maxHP,
        onChanged: (value) async {
          await onChanged?.call(
            characterOtherProps.copyWith(
              maxHP: () => value,
            ),
          );
        },
      ),
      ScoreWidget(
        inputFormatters: inputFormatters,
        textInputType: inputType,
        icon: GameSystemViewModel.currentHp.icon,
        label: GameSystemViewModel.currentHp.name,
        initialValue: characterOtherProps.currentHP,
        onChanged: (value) async {
          await onChanged?.call(characterOtherProps.copyWith(
            currentHP: () => value,
          ));
        },
      ),
      ScoreWidget(
        inputFormatters: inputFormatters,
        textInputType: inputType,
        icon: GameSystemViewModel.temporaryHp.icon,
        label: GameSystemViewModel.temporaryHp.name,
        initialValue: characterOtherProps.temporaryHP,
        onChanged: (value) async {
          await onChanged?.call(characterOtherProps.copyWith(
            temporaryHP: () => value,
          ));
        },
      ),
      ScoreWidget(
        inputFormatters: inputFormatters,
        textInputType: inputType,
        icon: GameSystemViewModel.armorClass.icon,
        label: GameSystemViewModel.armorClass.name,
        initialValue: characterOtherProps.ac,
        onChanged: (value) async {
          await onChanged?.call(characterOtherProps.copyWith(
            ac: () => value,
          ));
        },
      ),
      ScoreWidget(
        inputFormatters: inputFormatters,
        textInputType: inputType,
        icon: GameSystemViewModel.speed.icon,
        label: GameSystemViewModel.speed.name,
        initialValue: characterOtherProps.currentSpeed,
        onChanged: (value) async {
          await onChanged?.call(characterOtherProps.copyWith(
            currentSpeed: () => value,
          ));
        },
      ),
      ScoreWidget(
        inputFormatters: inputFormatters,
        textInputType: inputType,
        icon: GameSystemViewModel.initiative.icon,
        label: GameSystemViewModel.initiative.name,
        initialValue: characterOtherProps.initiative,
        onChanged: (value) async {
          await onChanged?.call(characterOtherProps.copyWith(
            initiative: () => value,
          ));
        },
      ),
    ].map(
      (e) {
        return Card(
          child: e,
        );
      },
    );

    return LayoutBuilder(builder: (context, constraints) {
      final numberOfColumns = constraints.maxWidth ~/ 150;

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
    });
  }
}
