import 'json_enums.dart';

class EnumFieldSingleChoice {
  final JsonEnum options;
  final JsonEnumValue? selectedValue;

  EnumFieldSingleChoice({
    required this.options,
    this.selectedValue,
  });

  EnumFieldSingleChoice copyWith({
    JsonEnumValue? selectedValue,
  }) {
    return EnumFieldSingleChoice(
      options: options,
      selectedValue: selectedValue ?? this.selectedValue,
    );
  }

  factory EnumFieldSingleChoice.fromJson(Map<String, dynamic> map) {
    return EnumFieldSingleChoice(
      options: JsonEnum.fromJson(map['options'] as Map<String, dynamic>),
      selectedValue: map['selectedValue'] != null
          ? JsonEnumValue.fromJson(
              map['selectedValue'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'options': options.toJson(),
      'selectedValue': selectedValue?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumFieldSingleChoice &&
          runtimeType == other.runtimeType &&
          options == other.options &&
          selectedValue == other.selectedValue;

  @override
  int get hashCode => options.hashCode ^ selectedValue.hashCode;
}
