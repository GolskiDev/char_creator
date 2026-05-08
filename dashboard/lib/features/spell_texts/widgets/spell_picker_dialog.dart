import 'package:flutter/material.dart';

import '../models/spell.dart';
import '../services/srd_loader.dart';
import 'spell_sort_dropdown.dart';

/// A dialog for browsing and selecting multiple spells from the SRD.
/// Returns a list of selected [Spell]s (dashboard model) when confirmed.
class SpellPickerDialog extends StatefulWidget {
  const SpellPickerDialog({super.key});

  static Future<List<Spell>?> show(BuildContext context) {
    return showDialog<List<Spell>>(
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
  final Set<String> _checkedIds = {};
  SrdSpell? _previewed;
  SpellSortBy _sortBy = SpellSortBy.levelThenName;
  bool _loading = true;
  String? _error;

  double _listWidth = 320;

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
          _applyFilterAndSort();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _onSearch() => setState(_applyFilterAndSort);

  void _onSortChanged(SpellSortBy value) => setState(() {
        _sortBy = value;
        _applyFilterAndSort();
      });

  void _applyFilterAndSort() {
    final query = _searchCtrl.text.toLowerCase().trim();
    final list = query.isEmpty
        ? List<SrdSpell>.from(_allSpells)
        : _allSpells.where((s) => s.name.toLowerCase().contains(query)).toList();

    switch (_sortBy) {
      case SpellSortBy.levelThenName:
        list.sort((a, b) {
          final c = a.level.compareTo(b.level);
          return c != 0 ? c : a.name.compareTo(b.name);
        });
      case SpellSortBy.name:
        list.sort((a, b) => a.name.compareTo(b.name));
      case SpellSortBy.schoolThenName:
        list.sort((a, b) {
          final sa = a.school ?? '';
          final sb = b.school ?? '';
          final c = sa.compareTo(sb);
          return c != 0 ? c : a.name.compareTo(b.name);
        });
    }
    _filtered = list;
  }

  void _toggleCheck(SrdSpell spell) {
    setState(() {
      if (_checkedIds.contains(spell.id)) {
        _checkedIds.remove(spell.id);
      } else {
        _checkedIds.add(spell.id);
      }
    });
  }

  void _confirm() {
    final result = _allSpells
        .where((s) => _checkedIds.contains(s.id))
        .map((s) => Spell(
              id: s.id,
              title: s.name,
              description: s.description,
              imagePath: s.imageAssetPath,
            ))
        .toList();
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 680),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  if (_checkedIds.isNotEmpty)
                    Text(
                      '${_checkedIds.length} selected',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _checkedIds.isEmpty ? null : _confirm,
                    child: Text(
                      _checkedIds.isEmpty
                          ? 'Add spells'
                          : 'Add ${_checkedIds.length} spell${_checkedIds.length == 1 ? '' : 's'}',
                    ),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            // Left: search + sort + list
            SizedBox(
              width: _listWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: SpellSortDropdown(
                      value: _sortBy,
                      onChanged: _onSortChanged,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final spell = _filtered[index];
                        final isChecked = _checkedIds.contains(spell.id);
                        final isPreviewed = _previewed?.id == spell.id;
                        return ListTile(
                          dense: true,
                          selected: isPreviewed,
                          leading: Checkbox(
                            value: isChecked,
                            onChanged: (_) => _toggleCheck(spell),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          title: Text(spell.name),
                          subtitle: Text(
                            '${spell.levelLabel}${spell.school != null ? ' · ${_capitalize(spell.school!)}' : ''}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          onTap: () => setState(() => _previewed = spell),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Draggable divider
            _ResizeDivider(
              onDrag: (dx) => setState(() {
                _listWidth =
                    (_listWidth + dx).clamp(180.0, constraints.maxWidth - 200.0);
              }),
            ),
            // Right: preview
            Expanded(child: _buildPreview()),
          ],
        );
      },
    );
  }

  Widget _buildPreview() {
    if (_previewed == null) {
      return const Center(
        child: Text(
          'Tap a spell to preview',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final spell = _previewed!;
    final isChecked = _checkedIds.contains(spell.id);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Portrait image, vertically centered
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              spell.imageAssetPath,
              width: 130,
              height: 210,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 130,
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, size: 48, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Title + metadata + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        spell.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Checkbox(
                      value: isChecked,
                      onChanged: (_) => _toggleCheck(spell),
                    ),
                  ],
                ),
                Text(
                  '${spell.levelLabel}${spell.school != null ? ' · ${_capitalize(spell.school!)}' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  spell.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _ResizeDivider extends StatelessWidget {
  final void Function(double dx) onDrag;

  const _ResizeDivider({required this.onDrag});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).dividerColor;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
        child: SizedBox(
          width: 12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thin divider line
              Positioned.fill(
                child: Center(
                  child: Container(width: 1, color: color),
                ),
              ),
              // Grip pill
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
