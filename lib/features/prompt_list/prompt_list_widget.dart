import 'package:flutter/material.dart';

import 'prompt_model.dart';
import 'prompt_repository.dart';

class PromptListWidget extends StatefulWidget {
  const PromptListWidget({
    this.onPromptSelected,
    super.key,
  });
  final Function(PromptModel prompt)? onPromptSelected;

  @override
  State<PromptListWidget> createState() => _PromptListWidgetState();
}

class _PromptListWidgetState extends State<PromptListWidget> {
  final _promptsListFuture = PromptDataSource().get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _promptsListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final prompts = snapshot.data as List<PromptModel>;
          return ListView.builder(
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return ListTile(
                title: Text(prompt.prompt),
                onTap: () => widget.onPromptSelected?.call(prompt),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
