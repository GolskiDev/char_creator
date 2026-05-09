import 'package:flutter/material.dart';

enum SpellSortBy { levelThenName, name, schoolThenName }

/// A reusable sort dropdown for spell-related lists.
/// Pass [options] to restrict which sort modes are shown.
class SpellSortDropdown extends StatelessWidget {
  final SpellSortBy value;
  final ValueChanged<SpellSortBy> onChanged;
  final List<SpellSortBy> options;

  const SpellSortDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.options = SpellSortBy.values,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SpellSortBy>(
      initialValue: value,
      isDense: true,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Sort by', isDense: true),
      items: [
        for (final opt in options)
          DropdownMenuItem(
            value: opt,
            child: Row(children: [
              Icon(_iconFor(opt), size: 16),
              const SizedBox(width: 8),
              Text(_labelFor(opt), overflow: TextOverflow.ellipsis),
            ]),
          ),
      ],
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }

  static IconData _iconFor(SpellSortBy sort) => switch (sort) {
        SpellSortBy.levelThenName => Icons.format_list_numbered,
        SpellSortBy.name => Icons.sort_by_alpha,
        SpellSortBy.schoolThenName => Icons.school,
      };

  static String _labelFor(SpellSortBy sort) => switch (sort) {
        SpellSortBy.levelThenName => 'Level → Name',
        SpellSortBy.name => 'Name',
        SpellSortBy.schoolThenName => 'School → Name',
      };
}
