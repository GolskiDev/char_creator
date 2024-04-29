import 'package:collection/collection.dart';

class JsonObject {
  final dynamic value;
  final String? title;
  final String? key;

  JsonObject({
    required this.value,
    this.title,
    this.key,
  });

  factory JsonObject.from(something) {
    if (something is String ||
        something is int ||
        something is double ||
        something is bool) {
      return JsonObject(value: something);
    } else if (something is List<dynamic>) {
      return JsonObject(
        value: listFromList(something),
      );
    } else if (something is Map<String, dynamic>) {
      final value = fromJson(map: something);
      if (value is JsonObject) {
        return value;
      } else if (value is List<JsonObject>) {
        return JsonObject(value: value);
      } else {
        throw Exception('Unsupported type');
      }
    } else {
      throw Exception('Unsupported type');
    }
  }

  static List<JsonObject> listFromList(List<dynamic> list) {
    return list
        .map((item) {
          try {
            return JsonObject.from(item);
          } catch (e) {
            return null;
          }
        })
        .whereNotNull()
        .toList();
  }

  /// either JsonObject or List<JsonObject>
  static dynamic fromJson({
    required Map<String, dynamic> map,
    String? sourceKey,
  }) {
    if (map.containsKey('value')) {
      return JsonObject(
        value: map['value'],
        title: map['title'],
        key: sourceKey,
      );
    }
    return map.keys
        .map((key) {
          try {
            return fromJson(map: map[key], sourceKey: key);
          } catch (e) {
            return null;
          }
        })
        .whereNotNull()
        .toList();
  }
}
