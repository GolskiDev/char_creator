import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditStringPage extends HookConsumerWidget {
  const EditStringPage({
    this.initialValue,
    super.key,
  });
  final String? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(text: initialValue ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trait Value'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.of(context).pop(
                textController.text,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textController,
        ),
      ),
    );
  }
}
