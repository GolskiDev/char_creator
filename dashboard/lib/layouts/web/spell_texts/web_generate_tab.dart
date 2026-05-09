import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/models/spell.dart';
import '../../../features/spell_texts/services/llm_provider.dart';
import 'web_prompt_editor_panel.dart';
import 'web_spell_selector.dart';

({double min, double max, double defaultValue}) temperatureRangeFor(
    LlmProvider provider) {
  return switch (provider) {
    LlmProvider.openAI => (min: 0.0, max: 2.0, defaultValue: 1.0),
    LlmProvider.anthropic => (min: 0.0, max: 1.0, defaultValue: 1.0),
    LlmProvider.ollama => (min: 0.0, max: 1.0, defaultValue: 0.8),
  };
}

class WebGenerateTab extends StatefulWidget {
  final SpellTextsController ctrl;

  const WebGenerateTab({super.key, required this.ctrl});

  @override
  State<WebGenerateTab> createState() => _WebGenerateTabState();
}

class _WebGenerateTabState extends State<WebGenerateTab> {
  late List<Spell> _selectedSpells;
  int _count = 1;
  late double _temperature;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _selectedSpells = List.of(widget.ctrl.spells);
    _temperature = temperatureRangeFor(widget.ctrl.provider).defaultValue;
    widget.ctrl.addListener(_onCtrlChanged);
  }

  @override
  void dispose() {
    widget.ctrl.removeListener(_onCtrlChanged);
    super.dispose();
  }

  void _onCtrlChanged() {
    // Keep selection in sync when spell list changes.
    final ids = widget.ctrl.spells.map((s) => s.id).toSet();
    final updated = _selectedSpells.where((s) => ids.contains(s.id)).toList();
    for (final s in widget.ctrl.spells) {
      if (!updated.any((sel) => sel.id == s.id)) updated.add(s);
    }
    if (mounted) setState(() => _selectedSpells = updated);
  }

  Future<void> _generate(String promptText) async {
    final service = widget.ctrl.service;
    final promptHistory = widget.ctrl.promptHistory;
    final snippetService = widget.ctrl.snippetService;
    if (service == null || promptHistory == null || snippetService == null) {
      return;
    }
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
    final snippetNames = snippetService.snippets.map((s) => s.name).toSet();
    final refs = RegExp(r'\{\{snippet:([^}]+)\}\}').allMatches(promptText);
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
      final template = await promptHistory.save(promptText);
      await service.generateBatch(
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
            data: Theme.of(context)
                .copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                'Spells (${_selectedSpells.length}/${widget.ctrl.spells.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              initiallyExpanded: false,
              children: [
                SpellSelector(
                  spells: widget.ctrl.spells,
                  selected: _selectedSpells,
                  firestoreCount: widget.ctrl.firestoreCountBySpellId,
                  onSelectionChanged: (s) =>
                      setState(() => _selectedSpells = s),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PromptEditorPanel(
            promptHistory: widget.ctrl.promptHistory!,
            snippetService: widget.ctrl.snippetService,
            count: _count,
            onCountChanged: (v) => setState(() => _count = v),
            temperature: _temperature,
            temperatureMax: temperatureRangeFor(widget.ctrl.provider).max,
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
