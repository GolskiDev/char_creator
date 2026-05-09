import 'package:flutter/material.dart';

import '../models/spell.dart';
import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';
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
  final Map<String, int>? firestoreCountBySpellId;
  final bool showExportButton;
  final void Function(String json)? onExport;
  final VoidCallback? onUploadToFirestore;

  const SpellTextsPage({
    super.key,
    required this.spells,
    required this.service,
    required this.promptHistory,
    this.firestoreCountBySpellId,
    this.showExportButton = true,
    this.onExport,
    this.onUploadToFirestore,
  });

  @override
  State<SpellTextsPage> createState() => _SpellTextsPageState();
}

class _SpellTextsPageState extends State<SpellTextsPage> {
  List<Spell> _selectedSpells = [];
  final Set<String> _filterSpellIds = {}; // empty = show all
  final Set<SpellTextStatus> _visibleStatuses = {SpellTextStatus.pending};
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
    return widget.service.results.where((r) {
      if (_filterSpellIds.isNotEmpty && !_filterSpellIds.contains(r.spellId)) return false;
      return _visibleStatuses.contains(r.status);
    }).toList();
  }

  void _toggleStatus(SpellTextStatus status) {
    setState(() {
      if (_visibleStatuses.contains(status)) {
        _visibleStatuses.remove(status);
      } else {
        _visibleStatuses.add(status);
      }
    });
  }

  Widget _buildControls() => SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collapsible spell selector
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
                    onSelectionChanged: (s) => setState(() => _selectedSpells = s),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
          _ResultsFilterBar(
            spells: widget.spells,
            selectedSpells: _filterSpellIds,
            firestoreCount: widget.firestoreCountBySpellId,
            onSpellToggle: (id) => setState(() {
              if (_filterSpellIds.contains(id)) {
                _filterSpellIds.remove(id);
              } else {
                _filterSpellIds.add(id);
              }
            }),
            visibleStatuses: _visibleStatuses,
            onStatusToggle: _toggleStatus,
            statusCounts: {
              for (final s in SpellTextStatus.values)
                s: widget.service.results
                    .where((r) => r.status == s)
                    .length,
            },
          ),
          Expanded(
            child: _filteredResults.isEmpty
                ? const Center(child: Text('No results for the current filters.'))
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

class _ResultsFilterBar extends StatelessWidget {
  final List<Spell> spells;
  final Set<String> selectedSpells;
  final Map<String, int>? firestoreCount;
  final void Function(String) onSpellToggle;
  final Set<SpellTextStatus> visibleStatuses;
  final void Function(SpellTextStatus) onStatusToggle;
  final Map<SpellTextStatus, int> statusCounts;

  const _ResultsFilterBar({
    required this.spells,
    required this.selectedSpells,
    required this.onSpellToggle,
    required this.visibleStatuses,
    required this.onStatusToggle,
    required this.statusCounts,
    this.firestoreCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Spell chips — scrollable
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: spells.map((s) {
                  final count = firestoreCount?[s.id] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(count > 0 ? '${s.title} ($count)' : s.title),
                      selected: selectedSpells.contains(s.id),
                      onSelected: (_) => onSpellToggle(s.id),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Status chips — fixed on the right
          const VerticalDivider(width: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: SpellTextStatus.values.map((s) {
                final (tooltip, icon) = switch (s) {
                  SpellTextStatus.pending   => ('New', Icons.hourglass_empty),
                  SpellTextStatus.accepted  => ('Accepted', Icons.check_circle_outline),
                  SpellTextStatus.dismissed => ('Dismissed', Icons.cancel_outlined),
                };
                final count = statusCounts[s] ?? 0;
                final selected = visibleStatuses.contains(s);
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Tooltip(
                    message: '$tooltip ($count)',
                    child: FilterChip(
                      label: Icon(
                        icon,
                        size: 16,
                        color: selected ? null : Colors.grey,
                      ),
                      selected: selected,
                      onSelected: (_) => onStatusToggle(s),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

