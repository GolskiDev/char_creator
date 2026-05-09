import 'package:flutter/material.dart';

import '../../models/spell_text_status.dart';

enum StatusBadgeStyle { chip, overlay }

/// Shared status display atom.
///
/// [StatusBadgeStyle.chip] — bordered chip used in list cards.
/// [StatusBadgeStyle.overlay] — filled rounded badge for image overlays.
class StatusBadge extends StatelessWidget {
  final SpellTextStatus status;
  final StatusBadgeStyle style;

  const StatusBadge({
    super.key,
    required this.status,
    this.style = StatusBadgeStyle.chip,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      SpellTextStatus.pending => ('Pending', Colors.orange),
      SpellTextStatus.accepted => ('Accepted', Colors.green),
      SpellTextStatus.dismissed => ('Dismissed', Colors.red),
    };

    return switch (style) {
      StatusBadgeStyle.chip => Chip(
          label: Text(label, style: const TextStyle(fontSize: 11)),
          backgroundColor: color.withValues(alpha: 0.15),
          side: BorderSide(color: color, width: 1),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      StatusBadgeStyle.overlay => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    };
  }
}
