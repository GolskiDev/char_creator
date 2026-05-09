import 'package:flutter/material.dart';

import '../models/daily_text.dart';
import '../models/spell_text_result.dart';
import '../services/srd_loader.dart';
import 'spell_sort_dropdown.dart';
import 'spell_text_card.dart';

enum _SourceFilter { firestoreItems, readyToPush }

/// Tab 3 — shows Firestore items AND accepted-but-not-yet-pushed results,
/// with filter chips to toggle each source.
class FirestoreTab extends StatefulWidget {
  final List<DailyText> firestoreTexts;
  final bool loadingFirestore;

  /// Accepted SpellTextResults whose ID is not yet in Firestore.
  final List<SpellTextResult> readyToPush;

  /// IDs of [readyToPush] items whose text content already exists in Firestore
  /// for the same spell (content-level duplicate, different ID).
  final Set<String> textDuplicateIds;

  final Map<String, SrdSpell> srdSpells;
  final SpellSortBy sort;
  final ValueChanged<SpellSortBy> onSortChanged;
  final VoidCallback onRefresh;
  final void Function(DailyText) onEdit;
  final void Function(DailyText) onDelete;
  final Future<void> Function(SpellTextResult) onPushSingle;
  final VoidCallback onPushAll;

  const FirestoreTab({
    super.key,
    required this.firestoreTexts,
    required this.loadingFirestore,
    required this.readyToPush,
    this.textDuplicateIds = const {},
    required this.srdSpells,
    required this.sort,
    required this.onSortChanged,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
    required this.onPushSingle,
    required this.onPushAll,
  });

  @override
  State<FirestoreTab> createState() => _FirestoreTabState();
}

class _FirestoreTabState extends State<FirestoreTab> {
  final Set<_SourceFilter> _sourceFilter = {
    _SourceFilter.firestoreItems,
    _SourceFilter.readyToPush,
  };
  final Set<String> _filterSpellIds = {};

  // All spell IDs present in either source.
  Set<String> get _allSpellIds {
    return {
      ...widget.firestoreTexts.map((t) => t.spellId),
      ...widget.readyToPush.map((r) => r.spellId),
    };
  }

  List<DailyText> get _filteredFirestore {
    if (!_sourceFilter.contains(_SourceFilter.firestoreItems)) return [];
    return widget.firestoreTexts.where((t) {
      if (_filterSpellIds.isNotEmpty &&
          !_filterSpellIds.contains(t.spellId)) { return false; }
      return true;
    }).toList();
  }

  List<SpellTextResult> get _filteredReady {
    if (!_sourceFilter.contains(_SourceFilter.readyToPush)) return [];
    return widget.readyToPush.where((r) {
      if (_filterSpellIds.isNotEmpty &&
          !_filterSpellIds.contains(r.spellId)) { return false; }
      return true;
    }).toList();
  }

  List<Object> _sortedFirestoreItems(List<DailyText> texts) {
    final sorted = List<DailyText>.from(texts);
    switch (widget.sort) {
      case SpellSortBy.levelThenName:
        sorted.sort((a, b) {
          final sa = widget.srdSpells[a.spellId];
          final sb = widget.srdSpells[b.spellId];
          if (sa == null && sb == null) return 0;
          if (sa == null) { return 1; }
          if (sb == null) { return -1; }
          final c = sa.level.compareTo(sb.level);
          return c != 0 ? c : sa.name.compareTo(sb.name);
        });
      case SpellSortBy.name:
        sorted.sort((a, b) {
          final na = widget.srdSpells[a.spellId]?.name ?? a.spellId;
          final nb = widget.srdSpells[b.spellId]?.name ?? b.spellId;
          return na.compareTo(nb);
        });
      case SpellSortBy.schoolThenName:
        sorted.sort((a, b) => a.spellId.compareTo(b.spellId));
    }

    if (widget.sort != SpellSortBy.levelThenName) return sorted;

    final items = <Object>[];
    int? lastLevel;
    for (final text in sorted) {
      final spell = widget.srdSpells[text.spellId];
      final level = spell?.level;
      if (level != lastLevel) {
        items.add(spell?.levelLabel ?? 'Unknown');
        lastLevel = level;
      }
      items.add(text);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final firestoreCount = widget.firestoreTexts.length;
    final readyCount = widget.readyToPush.length;

    return Column(
      children: [
        // Toolbar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Text('Firestore', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 12),
              SizedBox(
                width: 160,
                child: SpellSortDropdown(
                  value: widget.sort,
                  onChanged: widget.onSortChanged,
                  options: const [SpellSortBy.levelThenName, SpellSortBy.name],
                ),
              ),
              const Spacer(),
              if (readyCount > 0)
                FilledButton.icon(
                  onPressed: widget.onPushAll,
                  icon: const Icon(Icons.cloud_upload, size: 18),
                  label: Text('Push all ready ($readyCount)'),
                ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: widget.onRefresh,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Filter bar
        SizedBox(
          height: 48,
          child: Row(
            children: [
              // Spell chips
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: Row(
                    children: _allSpellIds.map((id) {
                      final name = widget.srdSpells[id]?.name ?? id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(name),
                          selected: _filterSpellIds.contains(id),
                          onSelected: (_) => setState(() {
                            if (_filterSpellIds.contains(id)) {
                              _filterSpellIds.remove(id);
                            } else {
                              _filterSpellIds.add(id);
                            }
                          }),
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              // Source chips
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Tooltip(
                      message: 'Firestore ($firestoreCount)',
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: FilterChip(
                          label: Icon(
                            Icons.cloud_done_outlined,
                            size: 16,
                            color: _sourceFilter
                                    .contains(_SourceFilter.firestoreItems)
                                ? null
                                : Colors.grey,
                          ),
                          selected: _sourceFilter
                              .contains(_SourceFilter.firestoreItems),
                          onSelected: (_) => setState(() {
                            if (_sourceFilter.contains(
                                _SourceFilter.firestoreItems)) {
                              _sourceFilter
                                  .remove(_SourceFilter.firestoreItems);
                            } else {
                              _sourceFilter.add(_SourceFilter.firestoreItems);
                            }
                          }),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Ready to push ($readyCount)',
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: FilterChip(
                          label: Icon(
                            Icons.upload_outlined,
                            size: 16,
                            color: _sourceFilter
                                    .contains(_SourceFilter.readyToPush)
                                ? scheme.primary
                                : Colors.grey,
                          ),
                          selected:
                              _sourceFilter.contains(_SourceFilter.readyToPush),
                          onSelected: (_) => setState(() {
                            if (_sourceFilter
                                .contains(_SourceFilter.readyToPush)) {
                              _sourceFilter.remove(_SourceFilter.readyToPush);
                            } else {
                              _sourceFilter.add(_SourceFilter.readyToPush);
                            }
                          }),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Content
        Expanded(
          child: widget.loadingFirestore
              ? const Center(child: CircularProgressIndicator())
              : _buildList(),
        ),
      ],
    );
  }

  Widget _buildList() {
    final firestoreItems = _filteredFirestore;
    final readyItems = _filteredReady;

    if (firestoreItems.isEmpty && readyItems.isEmpty) {
      return const Center(child: Text('No items for the current filters.'));
    }

    // Build a combined list: ready-to-push section first, then Firestore section.
    final fsItems = _sortedFirestoreItems(firestoreItems);
    final List<Object> combined = [];

    if (readyItems.isNotEmpty) {
      combined.add(_SectionHeader.ready);
      combined.addAll(readyItems);
    }
    if (fsItems.isNotEmpty) {
      combined.add(_SectionHeader.firestore);
      combined.addAll(fsItems);
    }

    return ListView.builder(
      itemCount: combined.length,
      itemBuilder: (context, index) {
        final item = combined[index];
        if (item == _SectionHeader.ready) {
          return _SourceHeader(
            label: 'Ready to push (${readyItems.length})',
            color: Theme.of(context).colorScheme.primary,
          );
        }
        if (item == _SectionHeader.firestore) {
          return _SourceHeader(
            label: 'In Firestore (${firestoreItems.length})',
          );
        }
        if (item is String) return _LevelHeader(label: item);
        if (item is SpellTextResult) {
          final isDuplicate = widget.textDuplicateIds.contains(item.id);
          return SpellTextCard(
            key: ValueKey('ready_${item.id}'),
            result: item,
            onAccept: () {},
            onDismiss: () {},
            onPush: () async {
              await widget.onPushSingle(item);
            },
            duplicateWarning: isDuplicate
                ? 'Text already exists in Firestore for this spell'
                : null,
          );
        }
        final dt = item as DailyText;
        final spellName = widget.srdSpells[dt.spellId]?.name ?? dt.spellId;
        return _DailyTextTile(
          key: ValueKey('fs_${dt.id}'),
          text: dt,
          spellName: spellName,
          onEdit: () => widget.onEdit(dt),
          onDelete: () => widget.onDelete(dt),
        );
      },
    );
  }
}

enum _SectionHeader { ready, firestore }

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _SourceHeader extends StatelessWidget {
  final String label;
  final Color? color;

  const _SourceHeader({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color ?? scheme.outline,
            ),
      ),
    );
  }
}

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

class _DailyTextTile extends StatelessWidget {
  final DailyText text;
  final String spellName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DailyTextTile({
    super.key,
    required this.text,
    required this.spellName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 16, right: 8),
      title: Text(text.subtitle),
      subtitle: Text(spellName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
