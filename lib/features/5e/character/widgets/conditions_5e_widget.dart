import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/conditions_5e.dart';

class Conditions5eWidget extends HookConsumerWidget {
  final Conditions5e conditions;
  final ValueChanged<Conditions5e>? onChanged;

  const Conditions5eWidget({
    super.key,
    required this.conditions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionsWidget = Wrap(
      spacing: 8.0,
      children: [
        ...Condition5eType.values.map((condition) {
          return ChoiceChip(
            showCheckmark: false,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  condition.gameSystemViewModel.icon,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(condition.gameSystemViewModel.name),
              ],
            ),
            selected: conditions.conditions.contains(condition),
            onSelected: (selected) {
              final newConditions = conditions.copyWith(
                conditions: selected
                    ? conditions.conditions.union({condition})
                    : conditions.conditions.difference({condition}),
              );
              onChanged?.call(newConditions);
            },
          );
        }).toList(),
      ],
    );

    final exhaustionLevelWidget = ListTile(
      trailing: DropdownButton<ExhaustionLevel5e>(
        value: conditions.exhaustionLevel,
        items: ExhaustionLevel5e.values
            .map((level) => DropdownMenuItem(
                  value: level,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        level.gameSystemViewModel.icon,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(level.gameSystemViewModel.name),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (level) {
          if (level != null) {
            final newConditions = conditions.copyWith(
              exhaustionLevel: level,
            );
            onChanged?.call(newConditions);
          }
        },
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(
        16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          conditionsWidget,
          exhaustionLevelWidget,
        ],
      ),
    );
  }
}
