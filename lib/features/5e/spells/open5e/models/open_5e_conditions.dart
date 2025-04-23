import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../views/default_page_wrapper.dart';
import '../open_5e_collection_repository.dart';

class Open5eConditions {
  final String document;
  final String name;
  final String desc;

  Open5eConditions({
    required this.document,
    required this.name,
    required this.desc,
  });

  factory Open5eConditions.fromMap(Map<String, dynamic> map) {
    return Open5eConditions(
      document: map['document'] as String,
      name: map['name'] as String,
      desc: map['desc'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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

class Open5eConditionsPage extends ConsumerWidget {
  const Open5eConditionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditions = ref.watch(open5eConditionsProvider.future);
    return Scaffold(
      appBar: AppBar(
        title: Text("Conditions"),
      ),
      body: DefaultPageWrapper(
        future: conditions,
        builder: (context, data) => ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 4,
          ),
          itemBuilder: (context, index) {
            final conditionModel = data[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(conditionModel.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(conditionModel.name),
                        ),
                        body: SafeArea(
                          child: SingleChildScrollView(
                            child: Open5eConditionsWidget(
                              condition: conditionModel,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
