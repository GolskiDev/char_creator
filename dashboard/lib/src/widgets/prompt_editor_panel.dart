import 'package:flutter/material.dart';

import '../models/prompt_template.dart';
import '../services/prompt_history_service.dart';

class PromptEditorPanel extends StatefulWidget {
  final PromptHistoryService promptHistory;
  final void Function(String promptText) onGenerate;
  final int count;
  final void Function(int count) onCountChanged;

  const PromptEditorPanel({
    super.key,
    required this.promptHistory,
    required this.onGenerate,
    required this.count,
    required this.onCountChanged,
  });

  @override
  State<PromptEditorPanel> createState() => _PromptEditorPanelState();
}

class _PromptEditorPanelState extends State<PromptEditorPanel> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.promptHistory.latest?.text ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showHistory(BuildContext context) {
    final history = widget.promptHistory.history;
    if (history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No prompt history yet.')),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _HistorySheet(
        history: history,
        onSelect: (template) {
          setState(() => _controller.text = template.text);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Prompt template', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            IconButton(
              tooltip: 'History',
              icon: const Icon(Icons.history),
              onPressed: () => _showHistory(context),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          maxLines: 5,
          minLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText:
                'e.g. Write a joke about {{title}}.\nDescription: {{description}}',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Count:', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 8),
            _CountStepper(
              value: widget.count,
              min: 1,
              max: 5,
              onChanged: widget.onCountChanged,
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => widget.onGenerate(_controller.text.trim()),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CountStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final void Function(int) onChanged;

  const _CountStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.remove),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        Text('$value', style: Theme.of(context).textTheme.bodyLarge),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.add),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _HistorySheet extends StatelessWidget {
  final List<PromptTemplate> history;
  final void Function(PromptTemplate) onSelect;

  const _HistorySheet({required this.history, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Prompt history',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: history.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final t = history[index];
                return ListTile(
                  title: Text(t.preview),
                  subtitle: Text(
                    _formatDate(t.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () => onSelect(t),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
