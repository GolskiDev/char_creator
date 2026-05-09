import 'package:flutter/material.dart';

import '../../../features/spell_texts/models/prompt_template.dart';
import '../../../features/spell_texts/services/prompt_history_service.dart';
import '../../../features/spell_texts/services/snippet_service.dart';
import 'web_snippet_manager_dialog.dart';

class PromptEditorPanel extends StatefulWidget {
  final PromptHistoryService promptHistory;
  final void Function(String promptText) onGenerate;
  final int count;
  final void Function(int count) onCountChanged;
  final double temperature;
  final double temperatureMax;
  final void Function(double) onTemperatureChanged;

  /// When provided, shows a snippet insert button in the header.
  final SnippetService? snippetService;

  const PromptEditorPanel({
    super.key,
    required this.promptHistory,
    required this.onGenerate,
    required this.count,
    required this.onCountChanged,
    this.temperature = 0.7,
    this.temperatureMax = 1.0,
    required this.onTemperatureChanged,
    this.snippetService,
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

  void _showSnippetInsert(BuildContext context) {
    final snippetService = widget.snippetService;
    if (snippetService == null) return;
    SnippetInsertSheet.show(
      context,
      service: snippetService,
      onInsert: (ref) {
        final sel = _controller.selection;
        final text = _controller.text;
        final start = sel.isValid ? sel.start : text.length;
        final end = sel.isValid ? sel.end : text.length;
        final newText = text.replaceRange(start, end, ref);
        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: start + ref.length),
        );
      },
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
            if (widget.snippetService != null)
              IconButton(
                tooltip: 'Insert snippet',
                icon: const Icon(Icons.extension_outlined),
                onPressed: () => _showSnippetInsert(context),
              ),
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
        LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 480;
            if (narrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Count:', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      _CountField(value: widget.count, onChanged: widget.onCountChanged),
                      const SizedBox(width: 16),
                      Text('Temp:', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Slider(
                          value: widget.temperature,
                          min: 0.0,
                          max: widget.temperatureMax,
                          divisions: (widget.temperatureMax * 10).round(),
                          label: widget.temperature.toStringAsFixed(1),
                          onChanged: widget.onTemperatureChanged,
                        ),
                      ),
                      Text(
                        widget.temperature.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => widget.onGenerate(_controller.text.trim()),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate'),
                  ),
                ],
              );
            }
            return Row(
              children: [
                Text('Count:', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 8),
                _CountField(value: widget.count, onChanged: widget.onCountChanged),
                const SizedBox(width: 16),
                Text('Temp:', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 4),
                SizedBox(
                  width: 120,
                  child: Slider(
                    value: widget.temperature,
                    min: 0.0,
                    max: widget.temperatureMax,
                    divisions: (widget.temperatureMax * 10).round(),
                    label: widget.temperature.toStringAsFixed(1),
                    onChanged: widget.onTemperatureChanged,
                  ),
                ),
                Text(
                  '${widget.temperature.toStringAsFixed(1)}/${widget.temperatureMax.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => widget.onGenerate(_controller.text.trim()),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CountField extends StatefulWidget {
  final int value;
  final void Function(int) onChanged;

  const _CountField({required this.value, required this.onChanged});

  @override
  State<_CountField> createState() => _CountFieldState();
}

class _CountFieldState extends State<_CountField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.value}');
  }

  @override
  void didUpdateWidget(_CountField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      final pos = _ctrl.selection;
      _ctrl.text = '${widget.value}';
      // Restore cursor if still valid.
      if (pos.start <= _ctrl.text.length) _ctrl.selection = pos;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _commit(String raw) {
    final n = int.tryParse(raw.trim());
    if (n != null && n >= 1) {
      widget.onChanged(n);
    } else {
      // Revert to last valid value.
      _ctrl.text = '${widget.value}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.remove),
          onPressed: widget.value > 1
              ? () => widget.onChanged(widget.value - 1)
              : null,
        ),
        SizedBox(
          width: 40,
          child: TextField(
            controller: _ctrl,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            ),
            onSubmitted: _commit,
            onTapOutside: (_) => _commit(_ctrl.text),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.add),
          onPressed: () => widget.onChanged(widget.value + 1),
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
