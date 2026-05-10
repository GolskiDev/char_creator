import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/staging_controller.dart';
import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/models/spell_text_status.dart';
import '../../../features/spell_texts/ui/atoms/spell_sort_dropdown.dart';
import 'mobile_preview_page.dart';
import 'mobile_spell_text_card.dart';

class MobileStagingPage extends StatelessWidget {
  final StagingController staging;
  final SpellTextsController parent;

  const MobileStagingPage({
    super.key,
    required this.staging,
    required this.parent,
  });

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
    final filtered = staging.filteredResults;
    final pendingCount = filtered
        .where((r) => r.status == SpellTextStatus.pending)
        .length;
    final hasActiveStatusFilter =
        staging.visibleStatuses.length < SpellTextStatus.values.length;

    return Column(
      children: [
        // Toolbar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              Badge(
                isLabelVisible: hasActiveStatusFilter,
                smallSize: 8,
                child: IconButton(
                  icon: const Icon(Icons.tune),
                  tooltip: 'Filter & sort',
                  onPressed: () => _openFilterSheet(context, statusCounts),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: pendingCount > 0
                    ? () => _openReview(context, filtered
                        .where((r) => r.status == SpellTextStatus.pending)
                        .toList())
                    : null,
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: Text('Review ($pendingCount)'),
              ),
            ],
          ),
        ),
        // Spell filter chips
        if (parent.spells.isNotEmpty)
          SizedBox(
            height: 44,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: parent.spells.map((s) {
                  final count =
                      parent.firestoreCountBySpellId[s.id] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(
                          count > 0 ? '${s.title} ($count)' : s.title),
                      selected: staging.filterSpellIds.contains(s.id),
                      onSelected: (_) => staging.toggleSpellFilter(s.id),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        const Divider(height: 1),
        // Results list
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text('No results for the current filters.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final result = filtered[index];
                    return MobileSpellTextCard(
                      key: ValueKey(result.id),
                      result: result,
                      onAccept: () => staging.accept(result.id),
                      onDismiss: () => staging.dismiss(result.id),
                      onPreview: () => _openReview(context, filtered,
                          initialIndex: index),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _openFilterSheet(
      BuildContext context, Map<SpellTextStatus, int> statusCounts) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => ListenableBuilder(
        listenable: staging,
        builder: (context, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: SpellTextStatus.values.map((s) {
                      final label = switch (s) {
                        SpellTextStatus.pending => 'New',
                        SpellTextStatus.accepted => 'Accepted',
                        SpellTextStatus.dismissed => 'Dismissed',
                      };
                      final count = statusCounts[s] ?? 0;
                      return FilterChip(
                        label: Text('$label ($count)'),
                        selected: staging.visibleStatuses.contains(s),
                        onSelected: (_) => staging.toggleStatus(s),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Sort by',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: SpellSortBy.values.map((opt) {
                      final label = switch (opt) {
                        SpellSortBy.levelThenName => 'Level → Name',
                        SpellSortBy.name => 'Name',
                        SpellSortBy.schoolThenName => 'School → Name',
                      };
                      return ChoiceChip(
                        label: Text(label),
                        selected: staging.sort == opt,
                        onSelected: (v) {
                          if (v) staging.setSortBy(opt);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openReview(
    BuildContext context,
    List<SpellTextResult> list, {
    int initialIndex = 0,
  }) {
    MobilePreviewPage.push(
      context,
      results: list,
      initialIndex: initialIndex,
      onAccept: (id) => staging.accept(id),
      onDismiss: (id) => staging.dismiss(id),
    );
  }
}
