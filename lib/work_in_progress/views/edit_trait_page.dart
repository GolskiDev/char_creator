import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../tags/tag.dart';
import '../tags/tag_providers.dart';
import '../tags/views/tag_selector.dart';

class TraitFormPage extends HookConsumerWidget {
  const TraitFormPage({
    this.initialValue,
    this.onSavePressed,
    super.key,
  });
  final TraitFormState? initialValue;
  final Function(TraitFormState currentState)? onSavePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController =
        useTextEditingController(text: initialValue?.value ?? '');

    final allTags = ref.watch(tagsProvider).asData?.value ?? [];

    final formState = useState(
      TraitFormState(
        value: initialValue?.value ?? '',
        tags: [],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trait Value'),
        actions: [
          if (onSavePressed != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                onSavePressed!.call(formState.value);
                Navigator.of(context).pop();
              },
            )
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tags",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TagSelector(
              tags: allTags,
              selectedTags: formState.value.tags,
              onTagPressed: (tag) {
                onTagPressed(
                  formState,
                  tag,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onTagPressed(
    ValueNotifier<TraitFormState> formState,
    Tag tag,
  ) {
    final tags = List<Tag>.from(formState.value.tags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    formState.value = formState.value.copyWith(tags: tags);
  }
}

class TraitFormState {
  final String value;
  final List<Tag> tags;

  const TraitFormState({
    required this.value,
    required this.tags,
  });

  TraitFormState copyWith({
    String? value,
    List<Tag>? tags,
  }) {
    return TraitFormState(
      value: value ?? this.value,
      tags: tags ?? this.tags,
    );
  }
}
