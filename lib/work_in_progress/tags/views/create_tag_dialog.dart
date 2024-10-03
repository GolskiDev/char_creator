import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateTagDialog extends HookConsumerWidget {
  const CreateTagDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    const titleText = "Add New Tag";
    const submitText = 'Save';
    return Dialog(
      shape: const RoundedRectangleBorder(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(titleText),
          TextField(
            controller: textController,
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(submitText),
          ),
        ]
            .map(
              (element) => Padding(
                padding: EdgeInsets.all(8),
                child: element,
              ),
            )
            .toList(),
      ),
    );
  }
}
