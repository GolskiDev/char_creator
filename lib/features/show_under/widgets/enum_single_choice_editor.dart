import 'package:flutter/material.dart';
import 'package:spells_and_tools/features/show_under/json_enums/json_enums.dart';

/// A reusable widget for editing a single-choice enum field.
/// Compatible with EditPropertyPageBuilder's editorWidgetBuilder.
class EnumSingleChoiceEditor extends StatelessWidget {
  final JsonEnum enumData;
  final JsonEnumValue? initialValue;
  final ValueChanged<JsonEnumValue?> onChanged;
  final String? label;
  final String? description;
  final IconData? icon;

  const EnumSingleChoiceEditor({
    super.key,
    required this.enumData,
    required this.initialValue,
    required this.onChanged,
    this.label,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final String labelText = label ?? enumData.title ?? '';
    final String? descriptionText = description ?? enumData.description;
    final IconData? iconData = icon;

    return ListTile(
      leading: iconData != null ? Icon(iconData) : null,
      title: Text(labelText),
      subtitle: descriptionText != null ? Text(descriptionText) : null,
      trailing: SizedBox(
        width: 180,
        child: DropdownButton<JsonEnumValue>(
          value: initialValue,
          isExpanded: true,
          items: enumData.values.map((e) {
            return DropdownMenuItem<JsonEnumValue>(
              value: e,
              child: Text(e.text),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
