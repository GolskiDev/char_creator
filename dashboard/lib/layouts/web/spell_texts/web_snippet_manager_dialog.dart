import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../features/spell_texts/models/prompt_snippet.dart';
import '../../../features/spell_texts/services/snippet_service.dart';

/// Full CRUD dialog for managing prompt snippets.
class SnippetManagerDialog extends StatefulWidget {
  final SnippetService service;

  const SnippetManagerDialog({super.key, required this.service});

  static Future<void> show(BuildContext context, SnippetService service) {
    return showDialog<void>(
      context: context,
      builder: (_) => SnippetManagerDialog(service: service),
    );
  }

  @override
  State<SnippetManagerDialog> createState() => _SnippetManagerDialogState();
}

class _SnippetManagerDialogState extends State<SnippetManagerDialog> {
  final _nameCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  String? _nameError;
  PromptSnippet? _editing; // non-null when editing an existing snippet

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _startEdit(PromptSnippet snippet) {
    setState(() {
      _editing = snippet;
      _nameCtrl.text = snippet.name;
      _contentCtrl.text = snippet.content;
      _nameError = null;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editing = null;
      _nameCtrl.clear();
      _contentCtrl.clear();
      _nameError = null;
    });
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final content = _contentCtrl.text.trim();

    if (!PromptSnippet.isValidName(name)) {
      setState(() => _nameError = 'Only lowercase letters, digits, _ and - allowed');
      return;
    }
    if (content.isEmpty) return;

    try {
      if (_editing == null) {
        await widget.service.add(name, content);
      } else {
        final editing = _editing;
        if (editing != null) {
          await widget.service.update(
            PromptSnippet(
              id: editing.id,
              name: name,
              content: content,
              createdAt: editing.createdAt,
            ),
          );
        }
      }
      if (mounted) {
        setState(() {
          _editing = null;
          _nameCtrl.clear();
          _contentCtrl.clear();
          _nameError = null;
        });
      }
    } on ArgumentError catch (e) {
      setState(() => _nameError = e.message as String);
    }
  }

  Future<void> _delete(PromptSnippet snippet) async {
    await widget.service.delete(snippet.id);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final snippets = widget.service.snippets;
    return AlertDialog(
      title: const Text('Prompt Snippets'),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Use {{snippet:name}} in any prompt template to insert a snippet.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 12),
            // Add / edit form
            _buildForm(),
            const Divider(height: 20),
            // Snippet list
            if (snippets.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No snippets yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snippets.length,
                  itemBuilder: (context, index) {
                    final s = snippets[index];
                    final isEditing = _editing?.id == s.id;
                    return ListTile(
                      dense: true,
                      selected: isEditing,
                      title: Text(
                        '{{snippet:${s.name}}}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        s.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, size: 16),
                            tooltip: 'Copy reference',
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: '{{snippet:${s.name}}}'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Copied {{snippet:${s.name}}}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            tooltip: 'Edit',
                            onPressed: () => _startEdit(s),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 16),
                            tooltip: 'Delete',
                            onPressed: () => _delete(s),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final isEditing = _editing != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? 'Edit snippet' : 'Add snippet',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        if (isEditing)
          Text(
            'Renaming does not update existing prompt templates.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              child: TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'json_format',
                  isDense: true,
                  errorText: _nameError,
                ),
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  isDense: true,
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            FilledButton(
              onPressed: _save,
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
            if (isEditing) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: _cancelEdit,
                child: const Text('Cancel'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// A bottom sheet for inserting a snippet reference into a text field.
class SnippetInsertSheet extends StatelessWidget {
  final SnippetService service;
  final void Function(String reference) onInsert;

  const SnippetInsertSheet({
    super.key,
    required this.service,
    required this.onInsert,
  });

  static Future<void> show(
    BuildContext context, {
    required SnippetService service,
    required void Function(String reference) onInsert,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          SnippetInsertSheet(service: service, onInsert: onInsert),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snippets = service.snippets;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.75,
      builder: (context, scrollCtrl) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Text(
                  'Insert snippet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (snippets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No snippets defined yet. Open the snippet manager to add one.'),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                itemCount: snippets.length,
                itemBuilder: (context, index) {
                  final s = snippets[index];
                  return ListTile(
                    title: Text(
                      '{{snippet:${s.name}}}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      s.preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      onInsert('{{snippet:${s.name}}}');
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
