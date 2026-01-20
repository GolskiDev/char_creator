import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'show_under.dart';

class EditPropertyPageInt extends HookConsumerWidget {
  const EditPropertyPageInt({
    super.key,
    required this.propertyIcon,
    required this.propertyId,
    required this.propertyName,
    required this.propertyDescription,
    required this.initialValue,
  });

  final IconData? propertyIcon;
  final String? propertyId;
  final String propertyName;
  final String? propertyDescription;
  final int? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valueController = TextEditingController(
      text: initialValue?.toString() ?? '',
    );

    listTile() => ListTile(
          leading: propertyIcon != null ? Icon(propertyIcon) : null,
          title: Text(propertyName),
          subtitle:
              propertyDescription != null ? Text(propertyDescription!) : null,
          trailing: SizedBox(
            width: 100,
            child: TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
              ),
            ),
          ),
        );

    property() => Card(
          child: Hero(
            tag: propertyId ?? 'property_hero',
            child: Material(
              color: Colors.transparent,
              child: listTile(),
            ),
          ),
        );

    showUnderBuilder(String propertyId) {
      final items =
          ShowUnderDataProvider.maybeOf(context)?.dataForTarget(propertyId) ??
              [];
      if (items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.list),
              title: Text('Related Traits'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...items.map(
                    (trait) {
                      final description = trait.description;
                      return ListTile(
                        title: Text(trait.title),
                        subtitle:
                            description != null ? Text(description) : null,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final items = [
      property(),
      if (propertyId != null) ...[
        showUnderBuilder(propertyId!),
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(
                int.tryParse(valueController.text),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(4.0),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
        separatorBuilder: (context, index) => const SizedBox(
          height: 4.0,
        ),
      ),
    );
  }
}
