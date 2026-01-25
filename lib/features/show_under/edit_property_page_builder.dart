import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'show_under.dart';

class EditPropertyPageBuilder<T> extends HookConsumerWidget {
  const EditPropertyPageBuilder({
    super.key,
    required this.propertyId,
    required this.editorWidgetBuilder,
    this.onSaved,
  });

  final String? propertyId;
  final Function? onSaved;
  final Widget Function(BuildContext context) editorWidgetBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    property() => Card(
          child: Hero(
            tag: propertyId ?? 'property_hero',
            child: Material(
              color: Colors.transparent,
              child: editorWidgetBuilder(context),
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
              if (onSaved != null) {
                onSaved!();
              }
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
