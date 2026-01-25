import 'json_enums.dart';

class EnumFieldMultipleChoice {
  final JsonEnum options;
  final Set<JsonEnumValue> selectedValues;

  const EnumFieldMultipleChoice({
    required this.options,
    Set<JsonEnumValue>? selectedValues,
  }) : selectedValues = selectedValues ?? const {};

  EnumFieldMultipleChoice copyWith({
    Set<JsonEnumValue>? selectedValues,
  }) {
    return EnumFieldMultipleChoice(
      options: options,
      selectedValues: selectedValues ?? this.selectedValues,
    );
  }

  factory EnumFieldMultipleChoice.fromMap(Map<String, dynamic> map) {
    return EnumFieldMultipleChoice(
      options: JsonEnum.fromJson(map['options'] as Map<String, dynamic>),
      selectedValues: map['selectedValues'] != null
          ? (map['selectedValues'] as List<dynamic>)
              .map((e) => JsonEnumValue.fromJson(e as Map<String, dynamic>))
              .toSet()
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'options': options.toJson(),
      'selectedValues': selectedValues.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumFieldMultipleChoice &&
          runtimeType == other.runtimeType &&
          options == other.options &&
          selectedValues == other.selectedValues;

  @override
  int get hashCode => options.hashCode ^ selectedValues.hashCode;
}
