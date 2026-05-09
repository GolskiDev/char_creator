import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../features/spell_texts/models/spell.dart';

class SpellSelector extends StatefulWidget {
  final List<Spell> spells;
  final List<Spell> selected;
  final Map<String, int>? firestoreCount;
  final void Function(List<Spell> selected) onSelectionChanged;

  const SpellSelector({
    super.key,
    required this.spells,
    required this.selected,
    this.firestoreCount,
    required this.onSelectionChanged,
  });

  @override
  State<SpellSelector> createState() => _SpellSelectorState();
}

class _SpellSelectorState extends State<SpellSelector> {
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selected.map((s) => s.id).toSet();
  }

  void _toggle(Spell spell) {
    setState(() {
      if (_selectedIds.contains(spell.id)) {
        _selectedIds.remove(spell.id);
      } else {
        _selectedIds.add(spell.id);
      }
    });
    widget.onSelectionChanged(
      widget.spells.where((s) => _selectedIds.contains(s.id)).toList(),
    );
  }

  void _toggleAll() {
    setState(() {
      if (_selectedIds.length == widget.spells.length) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(widget.spells.map((s) => s.id));
      }
    });
    widget.onSelectionChanged(
      widget.spells.where((s) => _selectedIds.contains(s.id)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allSelected = _selectedIds.length == widget.spells.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Spells', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            TextButton(
              onPressed: _toggleAll,
              child: Text(allSelected ? 'Deselect all' : 'Select all'),
            ),
          ],
        ),
        const Divider(height: 4),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.spells.length,
          itemBuilder: (context, index) {
            final spell = widget.spells[index];
            final checked = _selectedIds.contains(spell.id);
            final count = widget.firestoreCount?[spell.id] ?? 0;
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: checked,
              onChanged: (_) => _toggle(spell),
              secondary: _SpellThumbnail(imagePath: spell.imagePath),
              title: Text(spell.title, style: const TextStyle(fontSize: 13)),
              subtitle: count > 0
                  ? Text(
                      '$count in Firestore',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }
}

class _SpellThumbnail extends StatelessWidget {
  final String? imagePath;

  const _SpellThumbnail({this.imagePath});

  @override
  Widget build(BuildContext context) {
    const size = 40.0;

    // Show network images if the path is a URL.
    final path = imagePath;
    final isUrl = path != null &&
        (path.startsWith('http://') || path.startsWith('https://'));

    if (isUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          path,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, e) => const SizedBox(
            width: size,
            height: size,
            child: Icon(Icons.broken_image, size: 24),
          ),
        ),
      );
    }

    // On web, local file paths are not accessible — fall back to icon.
    // On mobile, local paths can be loaded; that path is handled in the host app.
    if (path == null || kIsWeb) {
      return const SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.auto_fix_high, size: 24),
      );
    }

    // Mobile: load from local file path via Image.file (dart:io).
    // This import is in a separate file to keep web compilation clean.
    return _MobileImage(path: path, size: size);
  }
}

// Placeholder for mobile file image — resolved at runtime on mobile only.
// For full mobile support, replace with Image.file(File(path)) in a
// conditional-import implementation when targeting iOS/Android.
class _MobileImage extends StatelessWidget {
  final String path;
  final double size;

  const _MobileImage({required this.path, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const Icon(Icons.auto_fix_high, size: 24),
    );
  }
}
