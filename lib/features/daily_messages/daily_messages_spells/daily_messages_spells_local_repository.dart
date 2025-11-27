import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'daily_messages_spells.dart';

class DailyMessagesSpellsLocalRepository {
  final String assetPath;
  DailyMessagesSpellsLocalRepository(
      {this.assetPath = 'assets/daily_messages_spells.json'});

  Future<List<DailyMessageSpellModel>> fetchLocalDailyMessages() async {
    final jsonAsset = await rootBundle.loadString(assetPath);
    final jsonData = jsonDecode(jsonAsset);
    final dailyMessagesSpells = List.from(jsonData)
        .map((e) {
          try {
            return DailyMessageSpellModel.fromJson(e);
          } catch (e) {
            return null;
          }
        })
        .nonNulls
        .toList();
    return dailyMessagesSpells;
  }
}

final dailyMessagesSpellsLocalRepositoryProvider =
    Provider<DailyMessagesSpellsLocalRepository>((ref) {
  return DailyMessagesSpellsLocalRepository();
});
