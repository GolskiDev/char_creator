class JsonObject {
  final dynamic value;
  final String? title;
  final String? key;

  JsonObject({
    required this.value,
    this.title,
    this.key,
  });

  factory JsonObject.from(dynamic value, {String? key}) {
    if (value is List) {
      return JsonObject.listFromList(value, key: key);
    } else if (value is Map<String, dynamic>) {
      if (value.containsKey('value')) {
        return JsonObject.from(value['value'], key: key);
      }
      return JsonObject.mapFromMap(value);
    } else {
      return JsonObject(value: value, key: key);
    }
  }

  factory JsonObject.mapFromMap(Map<String, dynamic> map) {
    final List<JsonObject> list = map.entries
        .map((entry) => JsonObject.from(entry.value, key: entry.key))
        .toList();
    return JsonObject(value: list);
  }

  factory JsonObject.listFromList(List<dynamic> list, {String? key}) {
    final List<JsonObject> listOfObjects =
        list.map((value) => JsonObject.from(value)).toList();
    return JsonObject(value: listOfObjects, key: key);
  }
}
