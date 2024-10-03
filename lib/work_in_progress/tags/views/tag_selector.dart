import 'package:char_creator/work_in_progress/tags/tag_providers.dart';
import 'package:char_creator/work_in_progress/tags/views/create_tag_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../tag.dart';

class TagSelector extends HookConsumerWidget {
  final List<Tag> tags;
  final List<Tag>? selectedTags;
  final Function(
    BuildContext context,
    WidgetRef ref,
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
              onTagPressed?.call(context, ref, tag);
            },
          );
        },
      ).toList()
        ..add(
          newTagWidget(
            context,
            ref,
            onTagPressed,
          ),
        ),
    );
  }

  Widget newTagWidget(
    BuildContext context,
    WidgetRef ref,
    Function(
      BuildContext context,
      WidgetRef ref,
      Tag tag,
    )? onTagPressed,
  ) {
    return ActionChip(
      avatar: const Icon(Icons.add),
      label: const Text('Add Tag'),
      onPressed: () {
        final futureTagName = showDialog(
          context: context,
          builder: (context) => const CreateTagDialog(),
        );
        futureTagName.then(
          (value) async {
            if (value) {
              final tagRepository =
                  await ref.read(tagRepositoryProvider.future);
              final newTag = Tag.create(
                  name: value,
                );
              await tagRepository.addTag(
                newTag 
              );
              onTagPressed?.call(
                context,
                ref,
                newTag,
              );
            }
          },
        );
      },
    );
  }
}
