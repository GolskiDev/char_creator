sealed class FieldValue {
  static FieldValue fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      StringValue.typeId => StringValue.fromJson(json),
      _ => throw ArgumentError('Invalid field value type'),
    };
  }

  Map<String, dynamic> toJson();
}

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
