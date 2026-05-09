import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/firestore_controller.dart';
import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/models/daily_text.dart';
import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/ui/atoms/level_header.dart';
import '../../../features/spell_texts/ui/atoms/spell_sort_dropdown.dart';
import 'web_spell_text_card.dart';

class WebFirestoreTab extends StatelessWidget {
  final FirestoreController firestore;
  final SpellTextsController parent;

  const WebFirestoreTab({
    super.key,
    required this.firestore,
    required this.parent,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([firestore, parent]),
      builder: (context, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final readyCount = parent.readyToPush.length;

    return Column(
      children: [
        // Toolbar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Text('Firestore',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 12),
              SizedBox(
                width: 160,
                child: SpellSortDropdown(
                  value: firestore.sort,
                  onChanged: firestore.setSortBy,
                  options: const [
                    SpellSortBy.levelThenName,
                    SpellSortBy.name
                  ],
                ),
              ),
              const Spacer(),
              if (readyCount > 0)
                FilledButton.icon(
                  onPressed: () => _pushAll(context),
                  icon: const Icon(Icons.cloud_upload, size: 18),
                  label: Text('Push all ready ($readyCount)'),
                ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: parent.loadFirestore,
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
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: Row(
                    children: firestore.allSpellIds.map((id) {
                      final name =
                          firestore.srdSpells[id]?.name ?? id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(name),
                          selected: firestore.filterSpellIds.contains(id),
                          onSelected: (_) =>
                              firestore.toggleSpellFilter(id),
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Tooltip(
                      message:
                          'Firestore (${parent.firestoreTexts.length})',
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: FilterChip(
                          label: Icon(
                            Icons.cloud_done_outlined,
                            size: 16,
                            color: firestore.sourceFilter.contains(
                                    FirestoreSourceFilter.firestoreItems)
                                ? null
                                : Colors.grey,
                          ),
                          selected: firestore.sourceFilter.contains(
                              FirestoreSourceFilter.firestoreItems),
                          onSelected: (_) => firestore.toggleSourceFilter(
                              FirestoreSourceFilter.firestoreItems),
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
                            color: firestore.sourceFilter.contains(
                                    FirestoreSourceFilter.readyToPush)
                                ? scheme.primary
                                : Colors.grey,
                          ),
                          selected: firestore.sourceFilter
                              .contains(FirestoreSourceFilter.readyToPush),
                          onSelected: (_) => firestore.toggleSourceFilter(
                              FirestoreSourceFilter.readyToPush),
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
        Expanded(
          child: parent.loadingFirestore
              ? const Center(child: CircularProgressIndicator())
              : _buildList(context),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    final firestoreItems = firestore.filteredFirestore;
    final readyItems = firestore.filteredReady;

    if (firestoreItems.isEmpty && readyItems.isEmpty) {
      return const Center(
          child: Text('No items for the current filters.'));
    }

    final fsItems = firestore.sortedFirestoreItems(firestoreItems);
    final List<Object> combined = [];
    if (readyItems.isNotEmpty) {
      combined.add(_Section.ready);
      combined.addAll(readyItems);
    }
    if (fsItems.isNotEmpty) {
      combined.add(_Section.firestore);
      combined.addAll(fsItems);
    }

    return ListView.builder(
      itemCount: combined.length,
      itemBuilder: (context, index) {
        final item = combined[index];
        if (item == _Section.ready) {
          return _SourceHeader(
            label: 'Ready to push (${readyItems.length})',
            color: Theme.of(context).colorScheme.primary,
          );
        }
        if (item == _Section.firestore) {
          return _SourceHeader(
            label: 'In Firestore (${firestoreItems.length})',
          );
        }
        if (item is String) return LevelHeader(label: item);
        if (item is SpellTextResult) {
          final isDuplicate = parent.textDuplicateIds.contains(item.id);
          return WebSpellTextCard(
            key: ValueKey('ready_${item.id}'),
            result: item,
            onAccept: () {},
            onDismiss: () {},
            onPush: () => _pushSingle(context, item),
            duplicateWarning: isDuplicate
                ? 'Text already exists in Firestore for this spell'
                : null,
          );
        }
        final dt = item as DailyText;
        final spellName = firestore.srdSpells[dt.spellId]?.name ?? dt.spellId;
        return _DailyTextTile(
          key: ValueKey('fs_${dt.id}'),
          text: dt,
          spellName: spellName,
          onEdit: () => _showEditDialog(context, dt),
          onDelete: () => _confirmDelete(context, dt),
        );
      },
    );
  }

  Future<void> _pushAll(BuildContext context) async {
    final count = await parent.uploadAccepted();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        count > 0
            ? SnackBar(content: Text('Pushed $count texts to Firestore.'))
            : const SnackBar(
                content: Text('No new accepted results to push.')),
      );
    }
  }

  Future<void> _pushSingle(
      BuildContext context, SpellTextResult result) async {
    await parent.pushSingle(result);
  }

  void _confirmDelete(BuildContext context, DailyText text) {
    final spellName =
        firestore.srdSpells[text.spellId]?.name ?? text.spellId;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete text?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spellName,
                style: Theme.of(ctx).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(text.subtitle),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await parent.deleteFirestore(text);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, DailyText text) {
    final spellIdCtrl = TextEditingController(text: text.spellId);
    final subtitleCtrl = TextEditingController(text: text.subtitle);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Text'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: text.id),
                decoration: const InputDecoration(labelText: 'ID'),
                enabled: false,
              ),
              TextField(
                controller: spellIdCtrl,
                decoration: const InputDecoration(labelText: 'Spell ID'),
              ),
              TextField(
                controller: subtitleCtrl,
                decoration:
                    const InputDecoration(labelText: 'Subtitle'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final updated = DailyText(
                id: text.id,
                spellId: spellIdCtrl.text.trim(),
                subtitle: subtitleCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              parent.updateFirestore(updated);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

enum _Section { ready, firestore }

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
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
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
