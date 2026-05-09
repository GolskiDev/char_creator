import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/daily_text.dart';
import '../models/spell.dart';
import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';
import '../services/spell_text_service.dart';
import '../services/srd_loader.dart';
import 'spell_preview_dialog.dart';
import 'spell_sort_dropdown.dart';
import 'spell_text_card.dart';

/// Tab 2 — all generated SpellTextResults with filter/sort, JSON import,
/// and a "Push accepted to Firestore" action.
class StagingTab extends StatefulWidget {
  final SpellTextService service;
  final List<Spell> spells;
  final Map<String, int>? firestoreCountBySpellId;
  final VoidCallback onPushAccepted;

  const StagingTab({
    super.key,
    required this.service,
    required this.spells,
    required this.onPushAccepted,
    this.firestoreCountBySpellId,
  });

  @override
  State<StagingTab> createState() => _StagingTabState();
}

class _StagingTabState extends State<StagingTab> {
  final Set<String> _filterSpellIds = {};
  final Set<SpellTextStatus> _visibleStatuses = {
    SpellTextStatus.pending,
    SpellTextStatus.accepted,
    SpellTextStatus.dismissed,
  };
  SpellSortBy _sort = SpellSortBy.levelThenName;
  Map<String, SrdSpell> _srdSpells = {};

  @override
  void initState() {
    super.initState();
    _loadSrd();
  }

  Future<void> _loadSrd() async {
    final spells = await SrdLoader.loadSpells();
    if (mounted) {
      setState(() => _srdSpells = {for (final s in spells) s.id: s});
    }
  }

  List<SpellTextResult> get _filteredResults {
    return widget.service.results.where((r) {
      if (_filterSpellIds.isNotEmpty &&
          !_filterSpellIds.contains(r.spellId)) { return false; }
      return _visibleStatuses.contains(r.status);
    }).toList();
  }

  List<Object> _sortedItems(List<SpellTextResult> results) {
    final sorted = List<SpellTextResult>.from(results);
    switch (_sort) {
      case SpellSortBy.levelThenName:
        sorted.sort((a, b) {
          final sa = _srdSpells[a.spellId];
          final sb = _srdSpells[b.spellId];
          if (sa == null && sb == null) return 0;
          if (sa == null) { return 1; }
          if (sb == null) { return -1; }
          final c = sa.level.compareTo(sb.level);
          return c != 0 ? c : sa.name.compareTo(sb.name);
        });
      case SpellSortBy.name:
        sorted.sort((a, b) => a.spellTitle.compareTo(b.spellTitle));
      case SpellSortBy.schoolThenName:
        sorted.sort((a, b) {
          final sa = _srdSpells[a.spellId]?.school ?? '';
          final sb = _srdSpells[b.spellId]?.school ?? '';
          final c = sa.compareTo(sb);
          return c != 0 ? c : a.spellTitle.compareTo(b.spellTitle);
        });
    }

    if (_sort != SpellSortBy.levelThenName) return sorted;

    // Interleave level headers.
    final items = <Object>[];
    int? lastLevel;
    for (final r in sorted) {
      final spell = _srdSpells[r.spellId];
      final level = spell?.level;
      if (level != lastLevel) {
        items.add(spell?.levelLabel ?? 'Unknown');
        lastLevel = level;
      }
      items.add(r);
    }
    return items;
  }

  void _openPreview(int startIndex, List<SpellTextResult> list) {
    SpellPreviewDialog.show(
      context,
      results: list,
      initialIndex: startIndex,
      onAccept: (id) async {
        await widget.service.accept(id);
        if (mounted) setState(() {});
      },
      onDismiss: (id) async {
        await widget.service.dismiss(id);
        if (mounted) setState(() {});
      },
    );
  }

  Future<void> _importJson() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (picked == null || picked.files.single.bytes == null) return;

    final jsonString = utf8.decode(picked.files.single.bytes!);
    late final List<dynamic> jsonList;
    try {
      jsonList = json.decode(jsonString) as List<dynamic>;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not parse JSON file.')),
        );
      }
      return;
    }

    final spellMap = {for (final s in widget.spells) s.id: s};
    final incoming = jsonList.map((e) {
      final dt = DailyText.fromJson(e as Map<String, dynamic>);
      final spell = spellMap[dt.spellId];
      return SpellTextResult(
        id: dt.id,
        spellId: dt.spellId,
        spellTitle: spell?.title ?? dt.spellId,
        spellDescription: spell?.description ?? '',
        generatedText: dt.subtitle,
        createdAt: DateTime.now(),
        status: SpellTextStatus.accepted,
      );
    }).toList();

    final skipped = await widget.service.importResults(incoming);
    if (mounted) {
      final added = incoming.length - skipped;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported $added item${added == 1 ? '' : 's'}'
            '${skipped > 0 ? ', skipped $skipped duplicate${skipped == 1 ? '' : 's'}' : ''}.',
          ),
        ),
      );
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    final results = widget.service.results;
    final statusCounts = {
      for (final s in SpellTextStatus.values)
        s: results.where((r) => r.status == s).length,
    };
    final pendingCount = statusCounts[SpellTextStatus.pending] ?? 0;
    final filtered = _filteredResults;
    final items = _sortedItems(filtered);
    // Filtered results as a flat list (no level headers) for preview index math.
    final filteredFlat = filtered;

    return Column(
      children: [
        // Toolbar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 160,
                child: SpellSortDropdown(
                  value: _sort,
                  onChanged: (v) => setState(() => _sort = v),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: pendingCount > 0
                    ? () {
                        final pending = filteredFlat
                            .where((r) =>
                                r.status == SpellTextStatus.pending)
                            .toList();
                        _openPreview(0, pending);
                      }
                    : null,
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: Text('Review ($pendingCount)'),
              ),
              TextButton.icon(
                onPressed: _importJson,
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Import JSON'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Filter bar
        _StagingFilterBar(
          spells: widget.spells,
          selectedSpellIds: _filterSpellIds,
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
          statusCounts: statusCounts,
        ),
        const Divider(height: 1),
        // Results list
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text('No results for the current filters.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    if (item is String) return _LevelHeader(label: item);
                    final result = item as SpellTextResult;
                    final flatIndex = filteredFlat.indexOf(result);
                    return SpellTextCard(
                      key: ValueKey(result.id),
                      result: result,
                      onPreview: () => _openPreview(
                          flatIndex < 0 ? 0 : flatIndex, filteredFlat),
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
        // Bottom actions
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: statusCounts[SpellTextStatus.accepted]! > 0
                    ? widget.onPushAccepted
                    : null,
                icon: const Icon(Icons.cloud_upload, size: 18),
                label: Text(
                  'Push accepted (${statusCounts[SpellTextStatus.accepted]!})',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bar
// ---------------------------------------------------------------------------

class _StagingFilterBar extends StatelessWidget {
  final List<Spell> spells;
  final Set<String> selectedSpellIds;
  final Map<String, int>? firestoreCount;
  final void Function(String) onSpellToggle;
  final Set<SpellTextStatus> visibleStatuses;
  final void Function(SpellTextStatus) onStatusToggle;
  final Map<SpellTextStatus, int> statusCounts;

  const _StagingFilterBar({
    required this.spells,
    required this.selectedSpellIds,
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: spells.map((s) {
                  final count = firestoreCount?[s.id] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label:
                          Text(count > 0 ? '${s.title} ($count)' : s.title),
                      selected: selectedSpellIds.contains(s.id),
                      onSelected: (_) => onSpellToggle(s.id),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: SpellTextStatus.values.map((s) {
                final (tooltip, icon) = switch (s) {
                  SpellTextStatus.pending =>
                    ('New', Icons.hourglass_empty),
                  SpellTextStatus.accepted =>
                    ('Accepted', Icons.check_circle_outline),
                  SpellTextStatus.dismissed =>
                    ('Dismissed', Icons.cancel_outlined),
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
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
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

// ---------------------------------------------------------------------------
// Shared level header (used in both staging and firestore tabs)
// ---------------------------------------------------------------------------

class _LevelHeader extends StatelessWidget {
  final String label;
  const _LevelHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 4),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
