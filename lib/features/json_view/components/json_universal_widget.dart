import 'package:flutter/material.dart';

class JsonUniversalWidet extends StatelessWidget {
  const JsonUniversalWidet(
      {super.key, required this.value, required this.pathInJson});
  final String pathInJson;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    if (value is String) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Text(value),
      );
    } else if (value is num) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Text(value.toString()),
      );
    } else if (value is bool) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Text(value.toString()),
      );
    } else if (value is List) {
      final List<dynamic> list = value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  JsonUniversalWidet(
                    pathInJson: pathInJson + '.' + key.toString(),
                    value: value,
                  ),
                ))
            .values
            .toList(),
      );
    } else if (value is Map<String, dynamic>) {
      final Map<String, dynamic> map = value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: map
            .map(
              (key, value) => MapEntry(
                key,
                JsonUniversalWidet(
                  pathInJson: pathInJson + '.' + key,
                  value: value,
                ),
              ),
            ).values.toList()
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Text('Unknown type'),
      );
    }
  }
}
