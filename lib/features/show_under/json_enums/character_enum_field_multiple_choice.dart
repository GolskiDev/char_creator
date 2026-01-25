import 'json_enums.dart';

class CharacterEnumFieldMultipleChoice {
  final String fieldName;
  final JsonEnum options;
  final Set<JsonEnumValue> selectedValues;

  const CharacterEnumFieldMultipleChoice({
    required this.fieldName,
    required this.options,
    Set<JsonEnumValue>? selectedValues,
  }) : selectedValues = selectedValues ?? const {};

  CharacterEnumFieldMultipleChoice copyWith({
    Set<JsonEnumValue>? selectedValues,
  }) {
    return CharacterEnumFieldMultipleChoice(
      fieldName: fieldName,
      options: options,
      selectedValues: selectedValues ?? this.selectedValues,
    );
  }

  factory CharacterEnumFieldMultipleChoice.fromMap(Map<String, dynamic> map) {
    return CharacterEnumFieldMultipleChoice(
      fieldName: map['fieldName'] as String,
      options: JsonEnum.fromJson(map['options'] as Map<String, dynamic>),
      selectedValues: map['selectedValues'] != null
          ? (map['selectedValues'] as List<dynamic>)
              .map((e) => JsonEnumValue.fromJson(e as Map<String, dynamic>))
              .toSet()
          : {},
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterEnumFieldMultipleChoice &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          options == other.options &&
          selectedValues == other.selectedValues;

  @override
  int get hashCode =>
      fieldName.hashCode ^ options.hashCode ^ selectedValues.hashCode;
}
