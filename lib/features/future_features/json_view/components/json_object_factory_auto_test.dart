import 'package:char_creator/features/future_features/json_view/components/json_object.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should get value from string', () {
    const String string = 'Hello World';
    final JsonObject jsonObject = JsonObject.from(string);

    expect(jsonObject.value, string);
  });

  test('Should get value from int', () {
    const int number = 42;
    final JsonObject jsonObject = JsonObject.from(number);

    expect(jsonObject.value, number);
  });

  test('Should get value from double', () {
    const double number = 42.0;
    final JsonObject jsonObject = JsonObject.from(number);

    expect(jsonObject.value, number);
  });

  test('Should get value from bool', () {
    const bool boolean = true;
    final JsonObject jsonObject = JsonObject.from(boolean);

    expect(jsonObject.value, boolean);
  });

  test('Should get value from num', () {
    const num number = 42;
    final JsonObject jsonObject = JsonObject.from(number);

    expect(jsonObject.value, number);
  });

  test('Should get value from list', () {
    final List<dynamic> list = ['Hello', 42, 42.0, true];
    final JsonObject jsonObject = JsonObject.from(list);

    expect(jsonObject.value, isA<List<JsonObject>>());
    expect((jsonObject.value as List<JsonObject>).length, list.length);
    expect(jsonObject.value[0].value, JsonObject.from('Hello').value);
    expect(jsonObject.value[1].value, JsonObject.from(42).value);
    expect(jsonObject.value[2].value, JsonObject.from(42.0).value);
    expect(jsonObject.value[3].value, JsonObject.from(true).value);
  });

  test('Should get value from map', () {
    final Map<String, dynamic> map = {
      'string': 'Hello',
      'int': 42,
      'double': 42.0,
      'bool': true,
    };
    final JsonObject jsonObject = JsonObject.from(map);

    expect(jsonObject.value, isA<List<JsonObject>>());
    expect((jsonObject.value as List<JsonObject>).length, map.length);
    expect(jsonObject.value[0].value, JsonObject.from('Hello').value);
    expect(jsonObject.value[0].key, 'string');
    expect(jsonObject.value[1].value, JsonObject.from(42).value);
    expect(jsonObject.value[1].key, 'int');
    expect(jsonObject.value[2].value, JsonObject.from(42.0).value);
    expect(jsonObject.value[2].key, 'double');
    expect(jsonObject.value[3].value, JsonObject.from(true).value);
    expect(jsonObject.value[3].key, 'bool');
  });

  test('Should get value from map 2', () {
    final Map<String, dynamic> map = {
      'value': 'Hello',
    };
    final JsonObject jsonObject = JsonObject.from(map);

    expect(jsonObject.value, JsonObject.from(map['value']).value);
  });

  test('Should get value from map 3', () {
    final Map<String, dynamic> map = {
      "character": {
        "value": "Hello",
      },
    };
    final JsonObject jsonObject = JsonObject.from(map);

    expect(jsonObject.value, isA<List<JsonObject>>());
    expect((jsonObject.value as List<JsonObject>).length, map.length);
    expect(jsonObject.value[0].value,
        JsonObject.from(map['character']['value']).value);
    expect(jsonObject.value[0].key, 'character');
  });

  test('Should get value from map 4', () {
    final Map<String, dynamic> map = {
      "character": {
        "value": "Hello",
      },
      "hello": "World",
    };
    final JsonObject jsonObject = JsonObject.from(map);

    expect(jsonObject.value, isA<List<JsonObject>>());
    expect((jsonObject.value as List<JsonObject>).length, map.length);
    expect(jsonObject.value[0].value,
        JsonObject.from(map['character']['value']).value);
    expect(jsonObject.value[0].key, 'character');
    expect(jsonObject.value[1].value, JsonObject.from(map['hello']).value);
    expect(jsonObject.value[1].key, 'hello');
  });
}
