import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod/riverpod.dart';

import 'open_5e_spell_model.dart';

final open5eSpellsLocalCacheProvider = Provider(
  (ref) => Open5eSpellsLocalCache(),
);

class Open5eSpellsLocalCache {
  static const String spellsCacheKey = 'spells_cache_key';

  Future<List<Open5eSpellModelV1>?> getSpellsCache() async {
    final spellsCacheFile =
        await DefaultCacheManager().getFileFromCache("spells_cache_key");

    if (spellsCacheFile == null) {
      return null;
    }

    final spellsCacheData = await spellsCacheFile.file.readAsString();
    final result = await compute(jsonDecode, spellsCacheData);
    final List<dynamic> spellsCacheJson = List.from(result);
    final List<Open5eSpellModelV1> spellsCache = spellsCacheJson
        .map(
          (spell) => Open5eSpellModelV1.fromJson(spell),
        )
        .toList();

    return spellsCache;
  }

  Future<void> setSpellsCache(List<Open5eSpellModelV1> spells) async {
    final spellsCacheJson =
        jsonEncode(spells.map((spell) => spell.toJson()).toList());
    await DefaultCacheManager().putFile(
      spellsCacheKey,
      utf8.encode(spellsCacheJson),
      fileExtension: 'json',
      key: spellsCacheKey,
    );
  }
}
