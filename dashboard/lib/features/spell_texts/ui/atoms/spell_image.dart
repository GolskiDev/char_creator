import 'package:flutter/material.dart';

/// Resolves and displays a spell image from the package assets.
/// Shows a fallback icon when the asset is not found.
class SpellImage extends StatelessWidget {
  final String spellId;
  final BoxFit fit;

  const SpellImage({
    super.key,
    required this.spellId,
    this.fit = BoxFit.cover,
  });

  static String assetPath(String spellId) {
    final slug = spellId.replaceAll('-', '_');
    return 'packages/spells_and_tools/assets/images/spells/$slug.webp';
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath(spellId),
      fit: fit,
      errorBuilder: (_, __, ___) => Center(
        child: Icon(
          Icons.auto_fix_high,
          size: 64,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
