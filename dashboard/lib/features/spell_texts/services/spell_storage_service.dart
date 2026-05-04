import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/spell_text_result.dart';

class SpellStorageService {
  static const _prefsKey = 'spell_text_results';

  Future<List<SpellTextResult>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return [];
    final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
    return jsonList
        .map((e) => SpellTextResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<SpellTextResult> results) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(results.map((r) => r.toJson()).toList()),
    );
  }
}
