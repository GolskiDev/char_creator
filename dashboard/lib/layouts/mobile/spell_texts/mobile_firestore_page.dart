import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/firestore_controller.dart';
import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/models/daily_text.dart';
import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/ui/atoms/level_header.dart';
import '../../../features/spell_texts/ui/atoms/spell_sort_dropdown.dart';
import '../../web/spell_texts/web_spell_text_card.dart';

/// Mobile Firestore tab — single-column list of items ready to push
/// and items already in Firestore.
class MobileFirestorePage extends StatelessWidget {
  final FirestoreController firestore;
  final SpellTextsController parent;

  const MobileFirestorePage({
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
    final readyCount = parent.readyToPush.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: SpellSortDropdown(
                  value: firestore.sort,
                  onChanged: firestore.setSortBy,
                  options: const [
                    SpellSortBy.levelThenName,
                    SpellSortBy.name
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (readyCount > 0)
                FilledButton.icon(
                  onPressed: () => _pushAll(context),
                  icon: const Icon(Icons.cloud_upload, size: 18),
                  label: Text('Push ($readyCount)'),
                ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: parent.loadFirestore,
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

    if (combined.isEmpty) {
      return const Center(child: Text('No items yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: combined.length,
      itemBuilder: (context, index) {
        final item = combined[index];
        if (item == _Section.ready) {
          return _SectionHeader(
            label: 'Ready to push (${readyItems.length})',
            color: Theme.of(context).colorScheme.primary,
          );
        }
        if (item == _Section.firestore) {
          return _SectionHeader(
            label: 'In Firestore (${firestoreItems.length})',
          );
        }
        if (item is String) return LevelHeader(label: item);
        if (item is SpellTextResult) {
          return WebSpellTextCard(
            key: ValueKey('ready_${item.id}'),
            result: item,
            onAccept: () {},
            onDismiss: () {},
            onPush: () => parent.pushSingle(item),
            duplicateWarning: parent.textDuplicateIds.contains(item.id)
                ? 'Text already exists in Firestore for this spell'
                : null,
          );
        }
        final dt = item as DailyText;
        final spellName =
            firestore.srdSpells[dt.spellId]?.name ?? dt.spellId;
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 16, right: 8),
          title: Text(dt.subtitle),
          subtitle: Text(spellName),
        );
      },
    );
  }

  Future<void> _pushAll(BuildContext context) async {
    final count = await parent.uploadAccepted();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pushed $count texts to Firestore.')),
      );
    }
  }
}

enum _Section { ready, firestore }

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color? color;

  const _SectionHeader({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color ?? Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}
