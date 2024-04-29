import 'package:char_creator/features/json_view/components/json_object.dart';
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

    expect(jsonObject.value, list);
  });
}
