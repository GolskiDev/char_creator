import 'dart:async';

import 'package:collection/collection.dart';
import 'package:spells_and_tools/common/interfaces/identifiable.dart';

class JsonEnumValue {
  final String value;
  final String text;

  const JsonEnumValue({
    required this.value,
    required this.text,
  });

  factory JsonEnumValue.fromJson(Map<String, dynamic> json) {
    return JsonEnumValue(
      value: json['value'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'text': text,
    };
  }

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
  final String? title;
  final String? description;
  final Set<JsonEnumValue> values;

  const JsonEnum({
    this.title,
    this.description,
    required this.id,
    this.values = const {},
  });

  factory JsonEnum.fromJson(Map<String, dynamic> json) {
    return JsonEnum(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => JsonEnumValue(
                    value: e['value'] as String,
                    text: e['text'] as String,
                  ))
              .toSet() ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'values': values.map((e) => e.toJson()).toList(),
    };
  }

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
