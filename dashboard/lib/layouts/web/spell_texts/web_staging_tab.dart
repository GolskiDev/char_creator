import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/staging_controller.dart';
import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/models/spell_text_status.dart';
import '../../../features/spell_texts/ui/atoms/level_header.dart';
import '../../../features/spell_texts/ui/atoms/spell_sort_dropdown.dart';
import 'web_preview_dialog.dart';
import 'web_spell_text_card.dart';

class WebStagingTab extends StatelessWidget {
  final StagingController staging;
  final SpellTextsController parent;

  const WebStagingTab({
    super.key,
    required this.staging,
    required this.parent,
  });

  void _openPreview(
      BuildContext context, int startIndex, List<SpellTextResult> list) {
    WebPreviewDialog.show(
      context,
      results: list,
      initialIndex: startIndex,
      onAccept: (id) => staging.accept(id),
      onDismiss: (id) => staging.dismiss(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([staging, parent]),
      builder: (context, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final results = parent.service?.results ?? [];
    final statusCounts = {
      for (final s in SpellTextStatus.values)
        s: results.where((r) => r.status == s).length,
    };
    final pendingCount = statusCounts[SpellTextStatus.pending] ?? 0;
    final filtered = staging.filteredResults;
    final items = staging.sortedItems(filtered);
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
                  value: staging.sort,
                  onChanged: staging.setSortBy,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: pendingCount > 0
                    ? () {
                        final pending = filteredFlat
                            .where((r) => r.status == SpellTextStatus.pending)
                            .toList();
                        _openPreview(context, 0, pending);
                      }
                    : null,
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: Text('Review ($pendingCount)'),
              ),
              TextButton.icon(
                onPressed: () => _importJson(context),
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Import JSON'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Filter bar
        _FilterBar(
          spells: parent.spells,
          selectedSpellIds: staging.filterSpellIds,
          firestoreCount: parent.firestoreCountBySpellId,
          onSpellToggle: staging.toggleSpellFilter,
          visibleStatuses: staging.visibleStatuses,
          onStatusToggle: staging.toggleStatus,
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
                    if (item is String) return LevelHeader(label: item);
                    final result = item as SpellTextResult;
                    final flatIndex = filteredFlat.indexOf(result);
                    return WebSpellTextCard(
                      key: ValueKey(result.id),
                      result: result,
                      onPreview: () => _openPreview(
                          context,
                          flatIndex < 0 ? 0 : flatIndex,
                          filteredFlat),
                      onAccept: () => staging.accept(result.id),
                      onDismiss: () => staging.dismiss(result.id),
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
                onPressed: (statusCounts[SpellTextStatus.accepted] ?? 0) > 0
                    ? () => _pushAccepted(context)
                    : null,
                icon: const Icon(Icons.cloud_upload, size: 18),
                label: Text(
                  'Push accepted (${statusCounts[SpellTextStatus.accepted] ?? 0})',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pushAccepted(BuildContext context) async {
    final count = await parent.uploadAccepted();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        count > 0
            ? SnackBar(content: Text('Pushed $count texts to Firestore.'))
            : const SnackBar(content: Text('No new accepted results to push.')),
      );
    }
  }

  Future<void> _importJson(BuildContext context) async {
    final result = await staging.importFromFile(parent.spells);
    if (!context.mounted) return;
    if (result.added == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not parse JSON file.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Imported ${result.added} item${result.added == 1 ? '' : 's'}'
          '${result.skipped > 0 ? ', skipped ${result.skipped} duplicate${result.skipped == 1 ? '' : 's'}' : ''}.',
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bar
// ---------------------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  final List<dynamic> spells;
  final Set<String> selectedSpellIds;
  final Map<String, int> firestoreCount;
  final void Function(String) onSpellToggle;
  final Set<SpellTextStatus> visibleStatuses;
  final void Function(SpellTextStatus) onStatusToggle;
  final Map<SpellTextStatus, int> statusCounts;

  const _FilterBar({
    required this.spells,
    required this.selectedSpellIds,
    required this.firestoreCount,
    required this.onSpellToggle,
    required this.visibleStatuses,
    required this.onStatusToggle,
    required this.statusCounts,
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
                  final id = s.id as String;
                  final title = s.title as String;
                  final count = firestoreCount[id] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(count > 0 ? '$title ($count)' : title),
                      selected: selectedSpellIds.contains(id),
                      onSelected: (_) => onSpellToggle(id),
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
