import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../tag.dart';

class TagSelector extends HookConsumerWidget {
  final List<Tag> tags;
  final List<Tag>? selectedTags;
  final Function(
    Tag tag,
  )? onTagPressed;

  const TagSelector({
    super.key,
    required this.tags,
    this.selectedTags,
    this.onTagPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map<Widget>(
        (tag) {
          final isSelected = selectedTags!.contains(tag);
          return FilterChip(
            label: Text(tag.name),
            selected: isSelected,
            onSelected: (_) {
              onTagPressed?.call(tag);
            },
          );
        },
      ).toList()
        ..add(
          newTagWidget(context, ref),
        ),
    );
  }

  Widget newTagWidget(BuildContext context, WidgetRef ref) {
    return ActionChip(
      avatar: const Icon(Icons.add),
      label: const Text('Add Tag'),
      onPressed: () {},
    );
  }
}
