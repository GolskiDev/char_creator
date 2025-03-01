import 'package:flutter/material.dart';

import '../models/spell_model.dart';

class SpellFilterDrawer extends StatelessWidget {
  final List<SpellModel> allSpellModels;
  const SpellFilterDrawer({
    super.key,
    required this.allSpellModels,
  });

  @override
  Widget build(BuildContext context) {
    final schools = allSpellModels
        .map((spell) => spell.school)
        .where((school) => school != null)
        .toSet();

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'School',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Wrap(
                spacing: 8,
                runAlignment: WrapAlignment.center,
                children: schools
                    .map(
                      (school) => FilterChip(
                        label: Text(school!),
                        onSelected: (selected) {},
                      ),
                    )
                    .toList(),
              ),
            ),
            ListTile(
              title: const Text('Requires Concentration'),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {null},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {},
              ),
            ),
            ListTile(
              title: const Text('Can Be Cast As Ritual'),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {null},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {},
              ),
            ),
            ListTile(
              title: const Text('Requires Verbal Component'),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {null},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {},
              ),
            ),
            ListTile(
              title: const Text('Requires Somatic Component'),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {null},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {},
              ),
            ),
            ListTile(
              title: const Text('Requires Material Component'),
              trailing: SegmentedButton<bool?>(
                emptySelectionAllowed: true,
                multiSelectionEnabled: false,
                selected: {null},
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text('Yes'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('No'),
                  ),
                ],
                onSelectionChanged: (p0) => {},
              ),
            ),
            ListTile(
              title: const Text('Material'),
              subtitle: Wrap(
                spacing: 8,
                runAlignment: WrapAlignment.center,
                children: allSpellModels
                    .map((spell) => spell.material)
                    .where((material) => material != null)
                    .toSet()
                    .map(
                      (material) => FilterChip(
                        label: Expanded(
                          child: Text(
                            material!,
                          ),
                        ),
                        onSelected: (selected) {},
                      ),
                    )
                    .toList(),
              ),
            ),
            ListTile(
              title: const Text('Duration'),
              subtitle: Wrap(
                spacing: 8,
                runAlignment: WrapAlignment.center,
                children: allSpellModels
                    .map((spell) => spell.duration)
                    .where((duration) => duration != null)
                    .map((duration) => duration.toString())
                    .toSet()
                    .map(
                      (duration) => FilterChip(
                        label: Text(duration.toString()),
                        onSelected: (selected) {},
                      ),
                    )
                    .toList(),
              ),
            ),
            ListTile(
              title: const Text('Range'),
              subtitle: Wrap(
                spacing: 8,
                runAlignment: WrapAlignment.center,
                children: allSpellModels
                    .map((spell) => spell.range)
                    .where((range) => range != null)
                    .map((range) => range!.toString())
                    .toSet()
                    .map(
                      (range) => FilterChip(
                        label: Text(range.toString()),
                        onSelected: (selected) {},
                      ),
                    )
                    .toList(),
              ),
            ),
            ListTile(
              title: const Text('Casting Time'),
              subtitle: Wrap(
                spacing: 8,
                runAlignment: WrapAlignment.center,
                children: allSpellModels
                    .map((spell) => spell.castingTime)
                    .where((castingTime) => castingTime != null)
                    .map((castingTime) => castingTime!.toString())
                    .toSet()
                    .map(
                      (castingTime) => FilterChip(
                        label: Text(castingTime),
                        onSelected: (selected) {},
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
