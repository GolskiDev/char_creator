import 'package:flutter/material.dart';

import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/ui/atoms/meta_chip.dart';
import '../../../features/spell_texts/ui/atoms/spell_image.dart';
import '../../../features/spell_texts/ui/atoms/status_badge.dart';

/// Compact card used in the mobile staging list.
/// Supports swipe-to-accept (right) and swipe-to-dismiss (left).
class MobileSpellTextCard extends StatelessWidget {
  final SpellTextResult result;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;
  final VoidCallback? onPreview;

  const MobileSpellTextCard({
    super.key,
    required this.result,
    required this.onAccept,
    required this.onDismiss,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(result.id),
      background: Container(
        color: Colors.green.withValues(alpha: 0.15),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.check, color: Colors.green),
      ),
      secondaryBackground: Container(
        color: Colors.red.withValues(alpha: 0.15),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.close, color: Colors.red),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onAccept();
        } else {
          onDismiss();
        }
        return false; // we manage removal ourselves
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: InkWell(
          onTap: onPreview,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Spell thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 56,
                    height: 84,
                    child: SpellImage(spellId: result.spellId),
                  ),
                ),
                const SizedBox(width: 10),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              result.spellTitle,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          StatusBadge(status: result.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.generatedText,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (result.temperature case final temp?) ...[
                        const SizedBox(height: 4),
                        MetaChip(
                          label: 'temp: ${temp.toStringAsFixed(1)}',
                        ),
                      ],
                    ],
                  ),
                ),
                // Quick actions
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red,
                          size: 20),
                      onPressed: onDismiss,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green,
                          size: 20),
                      onPressed: onAccept,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
