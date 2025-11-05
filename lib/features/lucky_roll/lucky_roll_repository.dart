import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spells_and_tools/features/lucky_roll/lucky_roll_model.dart';
import 'package:spells_and_tools/utils/shared_preferences.dart';

final luckyRollProvider = FutureProvider<LuckyRollModel?>((ref) async {
  final repository = await ref.watch(luckyRollRepositoryProvider.future);
  return repository.getLuckyRollModel();
});

final luckyRollRepositoryProvider =
    FutureProvider<LuckyRollRepository>((ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  return LuckyRollRepository(sharedPreferences: sharedPreferences);
});

class LuckyRollRepository {
  static const String lastLuckyRollKey = 'last_lucky_roll';

  final StreamController<LuckyRollModel?> _controller =
      StreamController.broadcast();

  final SharedPreferencesWithCache sharedPreferences;
  LuckyRollRepository({
    required this.sharedPreferences,
  }) {
    updateStream();
  }

  get luckyRollModelStream => _controller.stream;

  Future<LuckyRollModel?> getLuckyRollModel() async {
    final jsonString = sharedPreferences.getString(lastLuckyRollKey);
    if (jsonString == null) return null;
    final json = await compute(jsonDecode, jsonString);
    return LuckyRollModel.fromJson(json);
  }

  Future<void> saveLuckyRollModel(LuckyRollModel model) async {
    final jsonString = await compute(jsonEncode, model.toJson());
    await sharedPreferences.setString(lastLuckyRollKey, jsonString);
    await updateStream();
  }

  Future<void> updateStream() async {
    final model = await getLuckyRollModel();
    _controller.add(model);
  }
}
