import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/character_5e_class_model_v1.dart';
import '../repository/character_classes_repository.dart';

class CharacterClassesWidget extends HookConsumerWidget {
  final Set<ICharacter5eClassModelV1> selectedClasses;
  final ValueChanged<Set<ICharacter5eClassModelV1>>? onSelectionChanged;
  final bool isEditing;

  const CharacterClassesWidget.editing({
    super.key,
    required this.selectedClasses,
    required this.onSelectionChanged,
  }) : isEditing = true;

  const CharacterClassesWidget.viewing({
    super.key,
    required this.selectedClasses,
  })  : isEditing = false,
        onSelectionChanged = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableClassesAsync = ref.watch(characterClassesStreamProvider);
    final List<ICharacter5eClassModelV1> availableClasses;
    switch (availableClassesAsync) {
      case AsyncValue(value: final List<ICharacter5eClassModelV1> data):
        availableClasses = data;
        break;
      case AsyncError(
          error: final Object _,
          stackTrace: final StackTrace? _,
        ):
        return Text('Error loading classes');
      default:
        return CircularProgressIndicator();
    }

    final spacing = 4.0;

    wrapBuilder({required List<Widget> children}) {
      return Wrap(
        spacing: spacing,
        children: children,
      );
    }

    final editingClassesWidget = wrapBuilder(
      children: availableClasses.map((classModel) {
        final isSelected = selectedClasses.contains(classModel);
        return FilterChip(
          label: Text(classModel.className ?? 'Unnamed Class'),
          selected: isSelected,
          onSelected: (selected) {
            final updatedSelection =
                Set<ICharacter5eClassModelV1>.from(selectedClasses);
            if (selected) {
              updatedSelection.add(classModel);
            } else {
              updatedSelection.remove(classModel);
            }
            onSelectionChanged?.call(updatedSelection);
          },
        );
      }).toList(),
    );

    final viewingClassesWidget = wrapBuilder(
      children: selectedClasses.map((classModel) {
        return Chip(
          label: Text(classModel.className ?? 'Unnamed Class'),
        );
      }).toList(),
    );

    if (isEditing) {
      return editingClassesWidget;
    } else {
      return viewingClassesWidget;
    }
  }
}
