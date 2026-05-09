import 'package:flutter/material.dart';

import '../models/spell.dart';
import '../services/llm_provider.dart';
import '../services/prompt_history_service.dart';
import '../services/snippet_service.dart';
import '../services/spell_text_service.dart';
import 'prompt_editor_panel.dart';
import 'spell_selector.dart';

/// Tab 1 — spell selection + prompt editor + generate button.
/// Returns the temperature range [min, max, default] for a given provider.
({double min, double max, double defaultValue}) temperatureRangeFor(
    LlmProvider provider) {
  return switch (provider) {
    LlmProvider.openAI => (min: 0.0, max: 2.0, defaultValue: 1.0),
    LlmProvider.anthropic => (min: 0.0, max: 1.0, defaultValue: 1.0),
    LlmProvider.ollama => (min: 0.0, max: 1.0, defaultValue: 0.8),
  };
}

class GenerateTab extends StatefulWidget {
  final List<Spell> spells;
  final SpellTextService service;
  final PromptHistoryService promptHistory;
  final SnippetService snippetService;
  final LlmProvider provider;
  final Map<String, int>? firestoreCountBySpellId;

  const GenerateTab({
    super.key,
    required this.spells,
    required this.service,
    required this.promptHistory,
    required this.snippetService,
    required this.provider,
    this.firestoreCountBySpellId,
  });

  @override
  State<GenerateTab> createState() => _GenerateTabState();
}

class _GenerateTabState extends State<GenerateTab> {
  late List<Spell> _selectedSpells;
  int _count = 1;
  late double _temperature;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _selectedSpells = List.of(widget.spells);
    _temperature = temperatureRangeFor(widget.provider).defaultValue;
  }

  @override
  void didUpdateWidget(GenerateTab old) {
    super.didUpdateWidget(old);
    // Keep selection in sync when the spell list changes.
    if (old.spells != widget.spells) {
      final ids = widget.spells.map((s) => s.id).toSet();
      _selectedSpells = _selectedSpells.where((s) => ids.contains(s.id)).toList();
      for (final s in widget.spells) {
        if (!_selectedSpells.any((sel) => sel.id == s.id)) {
          _selectedSpells.add(s);
        }
      }
    }
    // Clamp temperature when provider changes (different max).
    if (old.provider != widget.provider) {
      final range = temperatureRangeFor(widget.provider);
      setState(() => _temperature = _temperature.clamp(range.min, range.max));
    }
  }

  Future<void> _generate(String promptText) async {
    if (_selectedSpells.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one spell.')),
      );
      return;
    }
    if (promptText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a prompt template.')),
      );
      return;
    }

    // Warn about unresolved snippet references.
    final snippetNames =
        widget.snippetService.snippets.map((s) => s.name).toSet();
    final refs =
        RegExp(r'\{\{snippet:([^}]+)\}\}').allMatches(promptText);
    final unresolved = refs
        .map((m) => m.group(1)!)
        .where((name) => !snippetNames.contains(name))
        .toSet();
    if (unresolved.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Warning: unknown snippet(s): ${unresolved.join(', ')}'),
          duration: const Duration(seconds: 4),
        ),
      );
    }

    setState(() => _generating = true);
    try {
      final template = await widget.promptHistory.save(promptText);
      await widget.service.generateBatch(
        spells: _selectedSpells,
        promptTemplate: template,
        count: _count,
        temperature: _temperature,
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                'Spells (${_selectedSpells.length}/${widget.spells.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              initiallyExpanded: false,
              children: [
                SpellSelector(
                  spells: widget.spells,
                  selected: _selectedSpells,
                  firestoreCount: widget.firestoreCountBySpellId,
                  onSelectionChanged: (s) =>
                      setState(() => _selectedSpells = s),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PromptEditorPanel(
            promptHistory: widget.promptHistory,
            snippetService: widget.snippetService,
            count: _count,
            onCountChanged: (v) => setState(() => _count = v),
            temperature: _temperature,
            temperatureMax: temperatureRangeFor(widget.provider).max,
            onTemperatureChanged: (v) => setState(() => _temperature = v),
            onGenerate: _generating ? (_) {} : _generate,
          ),
          if (_generating) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }
}
