import 'package:char_creator/features/json_view/components/json_object.dart';
import 'package:flutter/material.dart';

class JsonObjectWidget extends StatelessWidget {
  const JsonObjectWidget({
    super.key,
    required this.jsonObject,
  });
  final JsonObject jsonObject;

  @override
  Widget build(BuildContext context) {
    final ifValueIsPrimitive = jsonObject.value is String ||
        jsonObject.value is num ||
        jsonObject.value is bool;

    Widget body;

    if (ifValueIsPrimitive) {
      body = _handlePrimitiveValue();
    } else if (jsonObject.value is List) {
      body = _handleList();
    } else {
      body = const Text('Unsupported type');
    }
    return Container(
      padding: const EdgeInsets.all(8),
      child: body,
    );
  }

  Column _handleList() {
    final listOfObjects = JsonObject.listFromList(jsonObject.value);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (jsonObject.title != null && jsonObject.title!.isNotEmpty)
        Text(jsonObject.title!),
      ...listOfObjects.map((object) {
        return JsonObjectWidget(jsonObject: object);
      }),
    ]);
  }

  Widget _handlePrimitiveValue() {
    if (jsonObject.title != null && jsonObject.title!.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(jsonObject.title!),
          Text(jsonObject.value.toString()),
        ],
      );
    } else {
      return Text(
        jsonObject.value.toString(),
      );
    }
  }
}
