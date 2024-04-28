import 'dart:convert';
import 'package:flutter/material.dart';

class JsonViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String jsonString = '''{"name":"John Doe","age":30,"isAlive":true,"abilities":["Super strength","Flight"],"attributes":{"strength":85,"agility":70,"intelligence":60}}''';

    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    return Scaffold(
        appBar: AppBar(
          title: Text('Dynamic JSON Display'),
        ),
        body: ListView(
          children: jsonData.keys.map((key) {
            return ListTile(
              title: Text(key),
              subtitle: buildValueWidget(jsonData[key]),
            );
          }).toList(),
        ),
      );
  }

  Widget buildValueWidget(dynamic value) {
    if (value is String || value is int || value is double || value is bool) {
      return Text(value.toString());
    } else if (value is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value.map((item) {
          return buildValueWidget(item);
        }).toList(),
      );
    } else if (value is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value.keys.map((key) {
          return ListTile(
            title: Text(key),
            subtitle: buildValueWidget(value[key]),
          );
        }).toList(),
      );
    } else {
      return Text('Unsupported type');
    }
  }
}
