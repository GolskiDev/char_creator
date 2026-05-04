import 'package:flutter/material.dart';

import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';

class SpellTextCard extends StatelessWidget {
  final SpellTextResult result;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  const SpellTextCard({
    super.key,
    required this.result,
    required this.onAccept,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              ],
            ),
          ],
        ),
      ),
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
