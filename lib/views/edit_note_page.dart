import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/notes/note.dart';

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
    BuildContext context,
    WidgetRef ref,
    TraitFormState currentState,
  )? onSavePressed;
  final Function(BuildContext context, WidgetRef ref)? onDeletePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController =
        useTextEditingController(text: initialValue?.value ?? '');

    final formKey = useState(GlobalKey<FormState>());

    final formValidates = useState<bool>(() {
      try {
        if (initialValue?.value == null) {
          return false;
        }
        Note.create(value: initialValue!.value);
        return true;
      } catch (e) {
        return false;
      }
    }());

    final currentTraitState = useState(
      TraitFormState(
        value: textController.text,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Trait Value'),
        actions: [
          if (onDeletePressed != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await onDeletePressed!.call(context, ref);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          if (onSavePressed != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: formValidates.value
                  ? () async {
                      await onSavePressed!.call(
                        context,
                        ref,
                        currentTraitState.value,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  : null,
            ),
        ],
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey.value,
        onChanged: () {
          formValidates.value = formKey.value.currentState!.validate();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: textController,
                validator: (value) {
                  try {
                    Note.validateValue(value);
                  } on ArgumentError catch (e) {
                    return e.message;
                  }
                  return null;
                },
                onChanged: (value) {
                  currentTraitState.value =
                      currentTraitState.value.copyWith(value: value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}