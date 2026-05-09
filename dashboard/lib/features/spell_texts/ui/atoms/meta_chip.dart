import 'package:flutter/material.dart';

/// Small metadata chip used in spell text cards.
class MetaChip extends StatelessWidget {
  final String label;

  const MetaChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
