part of 'field_value.dart';

class StringValue extends FieldValue {
  static const String typeId = 'string';

  final String value;
  StringValue({
    required this.value,
  });

  @override
  factory StringValue.fromJson(Map<String, dynamic> json) {
    return StringValue(value: json['value']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': typeId,
      'value': value,
    };
  }
}
