import 'package:flutter/material.dart';

import '../models/spell.dart';
import '../services/srd_loader.dart';

/// A dialog for browsing and selecting a spell from the SRD.
/// Returns the selected [Spell] (dashboard model) when confirmed.
class SpellPickerDialog extends StatefulWidget {
  const SpellPickerDialog({super.key});

  static Future<Spell?> show(BuildContext context) {
    return showDialog<Spell>(
      context: context,
      builder: (_) => const SpellPickerDialog(),
    );
  }

  @override
  State<SpellPickerDialog> createState() => _SpellPickerDialogState();
}

class _SpellPickerDialogState extends State<SpellPickerDialog> {
  final _searchCtrl = TextEditingController();

  List<SrdSpell> _allSpells = [];
  List<SrdSpell> _filtered = [];
  SrdSpell? _selected;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final spells = await SrdLoader.loadSpells();
      if (mounted) {
        setState(() {
          _allSpells = spells;
          _filtered = spells;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _onSearch() {
    final query = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filtered = query.isEmpty
          ? _allSpells
          : _allSpells.where((s) => s.name.toLowerCase().contains(query)).toList();
    });
  }

  void _confirm() {
    if (_selected == null) return;
    final s = _selected!;
    Navigator.of(context).pop(
      Spell(
        id: s.id,
        title: s.name,
        description: s.description,
        imagePath: s.imageAssetPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 560),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Browse SRD Spells',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: _buildBody()),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _selected == null ? null : _confirm,
                    child: const Text('Select'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: search + list
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search spells...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    isDense: true,
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              _searchCtrl.clear();
                              _onSearch();
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final spell = _filtered[index];
                    final isSelected = _selected?.id == spell.id;
                    return ListTile(
                      dense: true,
                      selected: isSelected,
                      title: Text(spell.name),
                      subtitle: Text(
                        '${spell.levelLabel}${spell.school != null ? ' · ${_capitalize(spell.school!)}' : ''}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      onTap: () => setState(() => _selected = spell),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        // Right: preview
        Expanded(child: _buildPreview()),
      ],
    );
  }

  Widget _buildPreview() {
    if (_selected == null) {
      return const Center(
        child: Text(
          'Select a spell to preview',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final spell = _selected!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              spell.imageAssetPath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(Icons.auto_awesome, size: 48, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(spell.name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            '${spell.levelLabel}${spell.school != null ? ' · ${_capitalize(spell.school!)}' : ''}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            spell.description,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
