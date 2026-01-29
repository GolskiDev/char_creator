import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/show_under/json_enums/json_enums.dart';

/// A reusable widget for editing a multiple-choice enum field.
/// Compatible with EditPropertyPageBuilder's editorWidgetBuilder.

class EnumMultipleChoiceEditor extends HookConsumerWidget {
  final JsonEnum enumData;
  final Set<JsonEnumValue> initialValues;
  final ValueChanged<Set<JsonEnumValue>> onChanged;
  final String? label;
  final String? description;
  final IconData? icon;

  const EnumMultipleChoiceEditor({
    super.key,
    required this.enumData,
    required this.initialValues,
    required this.onChanged,
    this.label,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String labelText = label ?? enumData.title ?? '';
    final String? descriptionText = description ?? enumData.description;
    final IconData? iconData = icon;

    final valuesState = useState(initialValues);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: iconData != null ? Icon(iconData) : null,
              title: Text(labelText),
              subtitle: descriptionText != null ? Text(descriptionText) : null,
            ),
            Wrap(
              spacing: 8.0,
              children: enumData.values.map((e) {
                final isSelected = valuesState.value.contains(e);
                return FilterChip(
                  label: Text(e.text),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      valuesState.value = {...valuesState.value, e};
                    } else {
                      valuesState.value = {
                        ...valuesState.value.where((element) => element != e)
                      };
                    }
                    onChanged(valuesState.value);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
