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
    final filtered = staging.filteredResults;
    final pendingCount = filtered
        .where((r) => r.status == SpellTextStatus.pending)
        .length;

    return Column(
      children: [
        // Sort + filter toolbar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: SpellSortDropdown(
                  value: staging.sort,
                  onChanged: staging.setSortBy,
                ),
              ),
              const SizedBox(width: 8),
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
