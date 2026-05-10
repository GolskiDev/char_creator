import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/models/spell.dart';
import '../../web/spell_texts/web_generate_tab.dart'
    show temperatureRangeFor;
import '../../web/spell_texts/web_prompt_editor_panel.dart';
import '../../web/spell_texts/web_spell_selector.dart';
import '../../web/spell_texts/web_spell_picker_dialog.dart';
import '../../web/spell_texts/web_snippet_manager_dialog.dart';

/// Mobile generate page — reuses the same form widgets as web.
/// Layout is single-column with full-width fields.
class MobileGeneratePage extends StatefulWidget {
  final SpellTextsController ctrl;
  final VoidCallback? onOpenSettings;

  const MobileGeneratePage({super.key, required this.ctrl, this.onOpenSettings});

  @override
  State<MobileGeneratePage> createState() => _MobileGeneratePageState();
}

class _MobileGeneratePageState extends State<MobileGeneratePage> {
  late List<Spell> _selectedSpells;
  late Set<String> _lastSpellIds;
  int _count = 1;
  late double _temperature;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _selectedSpells = List.of(widget.ctrl.spells);
    _lastSpellIds = widget.ctrl.spells.map((s) => s.id).toSet();
    _temperature = temperatureRangeFor(widget.ctrl.provider).defaultValue;
    widget.ctrl.addListener(_onCtrlChanged);
  }

  @override
  void dispose() {
    widget.ctrl.removeListener(_onCtrlChanged);
    super.dispose();
  }

  void _onCtrlChanged() {
    final newIds = widget.ctrl.spells.map((s) => s.id).toSet();
    if (newIds.length == _lastSpellIds.length &&
        _lastSpellIds.containsAll(newIds)) {
      return;
    }
    _lastSpellIds = newIds;
    final updated =
        _selectedSpells.where((s) => newIds.contains(s.id)).toList();
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

  void _openSpellManager() {
    showDialog<void>(
      context: context,
      builder: (_) => _SpellManagerDialog(
        spells: widget.ctrl.spells,
        onSave: widget.ctrl.saveSpells,
        firestoreCount: widget.ctrl.firestoreCountBySpellId,
      ),
    );
  }

  void _openSnippetManager() {
    final snippetService = widget.ctrl.snippetService;
    if (snippetService == null) return;
    SnippetManagerDialog.show(context, snippetService);
  }

  @override
  Widget build(BuildContext context) {
    final promptHistory = widget.ctrl.promptHistory;
    if (promptHistory == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Spells',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              TextButton.icon(
                onPressed: _openSpellManager,
                icon: const Icon(Icons.list, size: 16),
                label:
                    Text('Manage (${widget.ctrl.spells.length})'),
              ),
              if (widget.ctrl.snippetService != null)
                IconButton(
                  icon: const Icon(Icons.extension_outlined),
                  onPressed: _openSnippetManager,
                ),
              IconButton(
                tooltip: 'LLM settings',
                icon: const Icon(Icons.settings),
                onPressed: widget.onOpenSettings,
              ),
            ],
          ),
          SpellSelector(
            spells: widget.ctrl.spells,
            selected: _selectedSpells,
            firestoreCount: widget.ctrl.firestoreCountBySpellId,
            onSelectionChanged: (s) => setState(() => _selectedSpells = s),
          ),
          const SizedBox(height: 16),
          PromptEditorPanel(
            promptHistory: promptHistory,
            snippetService: widget.ctrl.snippetService,
            count: _count,
            onCountChanged: (v) => setState(() => _count = v),
            temperature: _temperature,
            temperatureMax:
                temperatureRangeFor(widget.ctrl.provider).max,
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

// Inline spell manager dialog for mobile (same logic as web)
class _SpellManagerDialog extends StatefulWidget {
  final List<Spell> spells;
  final Future<void> Function(List<Spell>) onSave;
  final Map<String, int> firestoreCount;

  const _SpellManagerDialog({
    required this.spells,
    required this.onSave,
    required this.firestoreCount,
  });

  @override
  State<_SpellManagerDialog> createState() => _SpellManagerDialogState();
}

class _SpellManagerDialogState extends State<_SpellManagerDialog> {
  late final List<Spell> _spells;

  @override
  void initState() {
    super.initState();
    _spells = List.of(widget.spells);
  }

  Future<void> _pickFromSrd() async {
    final picked = await SpellPickerDialog.show(context,
        firestoreCount: widget.firestoreCount);
    if (picked == null || picked.isEmpty) return;
    setState(() {
      for (final spell in picked) {
        if (!_spells.any((s) => s.id == spell.id)) _spells.add(spell);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Spells'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              onPressed: _pickFromSrd,
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('Browse SRD spells'),
            ),
            if (_spells.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _spells.length,
                  itemBuilder: (context, index) {
                    final spell = _spells[index];
                    return ListTile(
                      dense: true,
                      title: Text(spell.title),
                      subtitle: Text(spell.id),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () =>
                            setState(() => _spells.removeAt(index)),
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
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            await widget.onSave(_spells);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
