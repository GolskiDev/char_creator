import 'package:spells_and_tools/common/interfaces/identifiable.dart';

class JsonEnumValue {
  final String value;
  final String text;

  JsonEnumValue({
    required this.value,
    required this.text,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonEnumValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class JsonEnum implements Identifiable {
  @override
  final String id;
  final Set<JsonEnumValue> values;

  const JsonEnum({
    required this.id,
    this.values = const {},
  });
}

final types = {
  "oneOfMany",
  "multiple",
};
