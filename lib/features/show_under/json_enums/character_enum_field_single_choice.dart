import 'json_enums.dart';

class CharacterEnumFieldSingleChoice {
  final String fieldName;
  final JsonEnum options;
  final JsonEnumValue? selectedValue;

  CharacterEnumFieldSingleChoice({
    required this.fieldName,
    required this.options,
    this.selectedValue,
  });

  CharacterEnumFieldSingleChoice copyWith({
    JsonEnumValue? selectedValue,
  }) {
    return CharacterEnumFieldSingleChoice(
      fieldName: fieldName,
      options: options,
      selectedValue: selectedValue ?? this.selectedValue,
    );
  }

  factory CharacterEnumFieldSingleChoice.fromMap(Map<String, dynamic> map) {
    return CharacterEnumFieldSingleChoice(
      fieldName: map['fieldName'] as String,
      options: JsonEnum.fromJson(map['options'] as Map<String, dynamic>),
      selectedValue: map['selectedValue'] != null
          ? JsonEnumValue.fromJson(
              map['selectedValue'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fieldName': fieldName,
      'options': {
        'id': options.id,
        'title': options.title,
        'description': options.description,
        'values': options.values.map((e) => e.toJson()).toList(),
      },
      'selectedValue': selectedValue?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterEnumFieldSingleChoice &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          options == other.options &&
          selectedValue == other.selectedValue;

  @override
  int get hashCode =>
      fieldName.hashCode ^ options.hashCode ^ selectedValue.hashCode;
}
