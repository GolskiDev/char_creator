import 'package:flutter/material.dart';

import '../models/spell.dart';
import '../models/spell_text_result.dart';
import '../services/prompt_history_service.dart';
import '../services/spell_text_service.dart';
import 'prompt_editor_panel.dart';
import 'spell_selector.dart';
import 'spell_text_card.dart';

/// A self-contained, responsive page for generating and reviewing spell texts.
///
/// Embed this inside a [Scaffold] body or use as a route widget.
class SpellTextsPage extends StatefulWidget {
  final List<Spell> spells;
  final SpellTextService service;
  final PromptHistoryService promptHistory;
  final bool showExportButton;
  final void Function(String json)? onExport;
  final VoidCallback? onUploadToFirestore;

  const SpellTextsPage({
    super.key,
    required this.spells,
    required this.service,
    required this.promptHistory,
    this.showExportButton = true,
    this.onExport,
    this.onUploadToFirestore,
  });

  @override
  State<SpellTextsPage> createState() => _SpellTextsPageState();
}

class _SpellTextsPageState extends State<SpellTextsPage> {
  List<Spell> _selectedSpells = [];
  String? _filterSpellId; // null = show all
  int _count = 1;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _selectedSpells = List.of(widget.spells);
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

    setState(() => _generating = true);
    try {
      final template = await widget.promptHistory.save(promptText);
      await widget.service.generateBatch(
        spells: _selectedSpells,
        promptTemplate: template,
        count: _count,
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  List<SpellTextResult> get _filteredResults {
    if (_filterSpellId == null) return widget.service.results;
    return widget.service.resultsForSpell(_filterSpellId!);
  }

  Widget _buildControls() => SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpellSelector(
              spells: widget.spells,
              selected: _selectedSpells,
              onSelectionChanged: (s) => setState(() => _selectedSpells = s),
            ),
            const SizedBox(height: 16),
            PromptEditorPanel(
              promptHistory: widget.promptHistory,
              count: _count,
              onCountChanged: (v) => setState(() => _count = v),
              onGenerate: _generating ? (_) {} : _generate,
            ),
            if (_generating) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      );

  Widget _buildResults() => Column(
        children: [
          _FilterChips(
            spells: widget.spells,
            selected: _filterSpellId,
            onSelected: (id) => setState(() => _filterSpellId = id),
          ),
          Expanded(
            child: _filteredResults.isEmpty
                ? const Center(child: Text('No generated texts yet.'))
                : ListView.builder(
                    itemCount: _filteredResults.length,
                    itemBuilder: (context, index) {
                      final result = _filteredResults[index];
                      return SpellTextCard(
                        key: ValueKey(result.id),
                        result: result,
                        onAccept: () async {
                          await widget.service.accept(result.id);
                          setState(() {});
                        },
                        onDismiss: () async {
                          await widget.service.dismiss(result.id);
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
          if (widget.showExportButton || widget.onUploadToFirestore != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.showExportButton)
                    OutlinedButton.icon(
                      onPressed: () =>
                          widget.onExport?.call(widget.service.exportAcceptedToJson()),
                      icon: const Icon(Icons.download),
                      label: const Text('Export accepted'),
                    ),
                  if (widget.onUploadToFirestore != null) ...[
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: widget.onUploadToFirestore,
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Upload to Firestore'),
                    ),
                  ],
                ],
              ),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          // Wide layout: side-by-side
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 260,
                child: _buildControls(),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _buildResults()),
            ],
          );
        }
        // Narrow layout: stacked
        return Column(
          children: [
            ExpansionTile(
              title: Text(
                'Spells & Prompt (${_selectedSpells.length}/${widget.spells.length} selected)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              children: [_buildControls()],
            ),
            const Divider(height: 1),
            Expanded(child: _buildResults()),
          ],
        );
      },
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<Spell> spells;
  final String? selected;
  final void Function(String? spellId) onSelected;

  const _FilterChips({
    required this.spells,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          ...spells.map(
            (s) => Padding(
              padding: const EdgeInsets.only(left: 6),
              child: FilterChip(
                label: Text(s.title),
                selected: selected == s.id,
                onSelected: (_) =>
                    onSelected(selected == s.id ? null : s.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
