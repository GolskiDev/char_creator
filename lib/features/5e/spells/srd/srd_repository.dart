import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';

import '../models/srd_spell_model.dart';
import '../view_models/spell_view_model.dart';

final allSRDSpellsProvider = FutureProvider<List<SpellViewModel>>(
  (ref) async {
    final repository = ref.watch(srdRepositoryProvider);
    return repository.getAllSpells();
  },
);

final srdRepositoryProvider = Provider<SRDRepository>(
  (ref) {
    return SRDRepository();
  },
);

class SRDRepository {
  Future<List<SpellViewModel>> getAllSpells() async {
    final spellsFile = await rootBundle.loadString('assets/spells.json');
    final map = await compute(jsonDecode, spellsFile) as List<dynamic>;
    final spells = map
        .map(
          (e) => SRDSpellModelV1.fromMap(e as Map<String, dynamic>),
        )
        .toList();

    return spells.map((spell) => spell.toSpellViewModel()).toList();
  }
}
