import 'package:flutter/material.dart';

import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';

class SpellTextCard extends StatelessWidget {
  final SpellTextResult result;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  /// When non-null, shows a push-to-Firestore button alongside accept/dismiss.
  final VoidCallback? onPush;

  /// When non-null, shows a warning banner with this message.
  final String? duplicateWarning;

  const SpellTextCard({
    super.key,
    required this.result,
    required this.onAccept,
    required this.onDismiss,
    this.onPush,
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
                        size: 14,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        duplicateWarning!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.error,
                        ),
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
                _StatusChip(status: result.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(result.generatedText),
            if (result.temperature != null ||
                (result.metadata != null &&
                    result.metadata!.isNotEmpty)) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (result.temperature != null)
                    _MetaChip(
                      label: 'temp: ${result.temperature!.toStringAsFixed(1)}',
                      scheme: scheme,
                    ),
                  if (result.metadata != null)
                    ...result.metadata!.entries.map(
                      (e) => _MetaChip(
                          label: '${e.key}: ${e.value}', scheme: scheme),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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

class _MetaChip extends StatelessWidget {
  final String label;
  final ColorScheme scheme;

  const _MetaChip({required this.label, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(fontSize: 10, color: scheme.onSecondaryContainer),
      ),
      backgroundColor: scheme.secondaryContainer,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final SpellTextStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      SpellTextStatus.pending => ('Pending', Colors.orange),
      SpellTextStatus.accepted => ('Accepted', Colors.green),
      SpellTextStatus.dismissed => ('Dismissed', Colors.red),
    };
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color, width: 1),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
