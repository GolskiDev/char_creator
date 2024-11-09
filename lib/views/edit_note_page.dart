import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TraitFormState {
  final String value;

  const TraitFormState({
    required this.value,
  });

  TraitFormState copyWith({
    String? value,
  }) {
    return TraitFormState(
      value: value ?? this.value,
    );
  }
}

class NoteFormPage extends HookConsumerWidget {
  const NoteFormPage({
    this.initialValue,
    this.onSavePressed,
    this.onDeletePressed,
    super.key,
  });
  final TraitFormState? initialValue;
  final Function(
          BuildContext context, WidgetRef ref, TraitFormState currentState)?
      onSavePressed;
  final Function(BuildContext context, WidgetRef ref)? onDeletePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController =
        useTextEditingController(text: initialValue?.value ?? '');

    final formState = useState(
      initialValue ??
          const TraitFormState(
            value: '',
          ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trait Value'),
        actions: [
          if (onSavePressed != null)
            if (onDeletePressed != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await onDeletePressed!.call(context, ref);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              formState.value = formState.value.copyWith(
                value: textController.text,
              );
              await onSavePressed!.call(context, ref, formState.value);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
            ),
          ),
        ],
      ),
    );
  }
}
