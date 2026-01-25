import 'package:flutter/material.dart';
import 'package:spells_and_tools/features/show_under/json_enums/json_enums.dart';

/// A reusable widget for editing a single-choice enum field.
/// Compatible with EditPropertyPageBuilder's editorWidgetBuilder.
class EnumSingleChoiceEditor extends StatelessWidget {
  final JsonEnum enumData;
  final JsonEnumValue? selectedValue;
  final ValueChanged<JsonEnumValue?> onChanged;
  final String? label;

  const EnumSingleChoiceEditor({
    super.key,
    required this.enumData,
    required this.selectedValue,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<JsonEnumValue>(
      initialValue: selectedValue,
      items: enumData.values.map((e) {
        return DropdownMenuItem<JsonEnumValue>(
          value: e,
          child: Text(e.text),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
