import 'dart:convert';

import 'package:flutter/services.dart';

class SrdSpell {
  final String id;
  final String name;
  final int level;
  final String? school;
  final String description;

  const SrdSpell({
    required this.id,
    required this.name,
    required this.level,
    this.school,
    required this.description,
  });

  String get imageAssetPath =>
      'packages/spells_and_tools/assets/images/spells/${id.replaceAll('-', '_')}.webp';

  String get levelLabel => level == 0 ? 'Cantrip' : 'Level $level';
}

class SrdLoader {
  static List<SrdSpell>? _cache;

  static Future<List<SrdSpell>> loadSpells() async {
    final cached = _cache;
    if (cached != null) return cached;
    final jsonString = await rootBundle
        .loadString('packages/spells_and_tools/assets/spells.json')
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception(
            'Timed out loading spell data. Is the spells_and_tools asset bundled?',
          ),
        );
    final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
    final result = data.map((e) {
      final m = e as Map<String, dynamic>;
      return SrdSpell(
        id: m['id'] as String,
        name: m['name'] as String,
        level: m['level'] as int,
        school: m['school'] as String?,
        description: m['description'] as String,
      );
    }).toList();
    _cache = result;
    return result;
  }
}
