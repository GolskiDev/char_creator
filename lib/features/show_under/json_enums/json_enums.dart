import 'dart:async';

import 'package:collection/collection.dart';
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonEnum &&
          DeepCollectionEquality().equals(values, other.values) &&
          id == other.id;

  @override
  int get hashCode => DeepCollectionEquality().hash(values) ^ id.hashCode;
}

final types = {
  "oneOfMany",
  "multiple",
};

class EnumsRepository {
  final List<JsonEnum> _enums;

  final StreamController<List<JsonEnum>> _controller =
      StreamController<List<JsonEnum>>.broadcast();

  Stream<List<JsonEnum>> get stream => _controller.stream;

  EnumsRepository() : _enums = [];

  void addEnum(JsonEnum jsonEnum) {
    _enums.add(jsonEnum);
    _controller.add(_enums);
  }

  List<JsonEnum> getAllEnums() {
    return List.unmodifiable(_enums);
  }

  void dispose() {
    _controller.close();
  }
}
