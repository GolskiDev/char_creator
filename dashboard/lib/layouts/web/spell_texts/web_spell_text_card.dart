import 'package:flutter/material.dart';

import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/models/spell_text_status.dart';
import '../../../features/spell_texts/ui/atoms/meta_chip.dart';
import '../../../features/spell_texts/ui/atoms/status_badge.dart';

class WebSpellTextCard extends StatelessWidget {
  final SpellTextResult result;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;
  final VoidCallback? onPush;
  final VoidCallback? onPreview;
  final String? duplicateWarning;

  const WebSpellTextCard({
    super.key,
    required this.result,
    required this.onAccept,
    required this.onDismiss,
    this.onPush,
    this.onPreview,
    this.duplicateWarning,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (duplicateWarning != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 14, color: scheme.error),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        duplicateWarning!,
                        style: TextStyle(fontSize: 11, color: scheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.spellTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                StatusBadge(status: result.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(result.generatedText),
            if (result.temperature != null ||
                (result.metadata != null && result.metadata!.isNotEmpty)) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (result.temperature != null)
                    MetaChip(
                      label: 'temp: ${result.temperature!.toStringAsFixed(1)}',
                    ),
                  if (result.metadata != null)
                    ...result.metadata!.entries
                        .map((e) => MetaChip(label: '${e.key}: ${e.value}')),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onPreview != null)
                  IconButton(
                    tooltip: 'Preview',
                    icon: Icon(Icons.visibility_outlined,
                        color: scheme.onSurfaceVariant),
                    onPressed: onPreview,
                  ),
                if (result.status != SpellTextStatus.dismissed)
                  IconButton(
                    tooltip: 'Dismiss',
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onDismiss,
                  ),
                if (result.status != SpellTextStatus.accepted)
                  IconButton(
                    tooltip: 'Accept',
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: onAccept,
                  ),
                if (onPush != null)
                  IconButton(
                    tooltip: 'Push to Firestore',
                    icon: Icon(Icons.cloud_upload_outlined,
                        color: scheme.primary),
                    onPressed: onPush,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
