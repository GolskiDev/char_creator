import 'package:flutter/material.dart';

class Open5eConditions {
  final String url;
  final String key;
  final String document;
  final String name;
  final String desc;

  Open5eConditions({
    required this.url,
    required this.key,
    required this.document,
    required this.name,
    required this.desc,
  });

  factory Open5eConditions.fromMap(Map<String, dynamic> map) {
    return Open5eConditions(
      url: map['url'] as String,
      key: map['key'] as String,
      document: map['document'] as String,
      name: map['name'] as String,
      desc: map['desc'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'key': key,
      'document': document,
      'name': name,
      'desc': desc,
    };
  }
}

class Open5eConditionsWidget extends StatelessWidget {
  final Open5eConditions condition;

  const Open5eConditionsWidget({Key? key, required this.condition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(condition.name, style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text('Description'),
              subtitle: Text(condition.desc),
            ),
            ListTile(
              title: Text('Document'),
              subtitle: Text(condition.document),
            ),
          ],
        ),
      ),
    );
  }
}
