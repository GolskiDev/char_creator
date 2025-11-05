import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/game_system_view_model.dart';

class EditSpellWidget extends HookConsumerWidget {
  final String spellId;

  EditSpellWidget({
    super.key,
    required this.spellId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = GameSystemViewModel.edit;
    return IconButton.outlined(
      icon: Icon(edit.icon),
      tooltip: edit.name,
      onPressed: () async {
        context.push('/spells/$spellId/edit');
      },
    );
  }
}
