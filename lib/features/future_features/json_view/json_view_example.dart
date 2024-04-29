import 'dart:convert';
import 'package:char_creator/features/future_features/json_view/components/json_object_widget.dart';
import 'package:flutter/material.dart';

import 'components/json_object.dart';

class JsonViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String jsonString = "{\"value\": \"Hi there\"}";

    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic JSON Display'),
      ),
      body: JsonObjectWidget(
        jsonObject: JsonObject.from(jsonData),
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
