import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CharacterSheetWidget extends HookConsumerWidget {
  const CharacterSheetWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Sheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Current HP'),
                        suffixIcon: Icon(Icons.heart_broken_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Temp HP',
                        suffixIcon: Icon(Symbols.heart_plus_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        enabled: false,
                        labelText: 'Max HP',
                        suffixIcon: Icon(Icons.favorite_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Armor Class',
                        suffixIcon: Icon(Icons.shield_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Speed',
                        suffixIcon: Icon(Icons.directions_run_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Saving Throws Modifiers'),
                leading: const Icon(Symbols.shield_question),
                childrenPadding: const EdgeInsets.all(8),
                children: [
                  Column(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Strength',
                          suffixIcon: Icon(Symbols.fitness_center),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Dexterity',
                          suffixIcon: Icon(Symbols.sprint),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Constitution',
                          suffixIcon: Icon(Symbols.health_and_safety),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Intelligence',
                          suffixIcon: Icon(Symbols.science),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Wisdom',
                          suffixIcon: Icon(Symbols.psychology),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Charisma',
                          suffixIcon: Icon(Symbols.sentiment_very_satisfied),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ExpansionTile(
                title: const Text('Actions'),
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Attack Action Placeholder',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              ExpansionTile(
                title: const Text('Bonus Actions'),
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Bonus Action Placeholder',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              ExpansionTile(
                title: const Text('Reactions'),
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Reaction Placeholder',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              ExpansionTile(
                title: const Text('Other'),
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Other Placeholder',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Skills'),
                children: [
                  Column(
                    children: [
                      for (var skill in [
                        'Acrobatics',
                        'Animal Handling',
                        'Arcana',
                        'Athletics',
                        'Deception',
                        'History',
                        'Insight',
                        'Intimidation',
                        'Investigation',
                        'Medicine',
                        'Nature',
                        'Perception',
                        'Performance',
                        'Persuasion',
                        'Religion',
                        'Sleight of Hand',
                        'Stealth',
                        'Survival'
                      ])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(skill),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Modifier',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
