import 'dart:io';

import 'package:flutter/material.dart';

import '../models/spell.dart';

class SpellSelector extends StatefulWidget {
  final List<Spell> spells;
  final List<Spell> selected;
  final void Function(List<Spell> selected) onSelectionChanged;

  const SpellSelector({
    super.key,
    required this.spells,
    required this.selected,
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
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: checked,
              onChanged: (_) => _toggle(spell),
              secondary: _SpellThumbnail(imagePath: spell.imagePath),
              title: Text(spell.title, style: const TextStyle(fontSize: 13)),
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
    if (imagePath == null) {
      return const SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.auto_fix_high, size: 24),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        File(imagePath!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => const SizedBox(
          width: size,
          height: size,
          child: Icon(Icons.broken_image, size: 24),
        ),
      ),
    );
  }
}
