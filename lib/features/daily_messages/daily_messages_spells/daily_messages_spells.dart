import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/shared_preferences.dart';
import '../../5e/spells/spell_images/spell_images_repository.dart';

final dailyMessageSpellViewModelProvider = FutureProvider(
  (ref) async {
    final spellImagesRepository = ref.watch(spellImagesRepositoryProvider);
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);

    return DailyMessagesSpells(
      spellImagesRepository: spellImagesRepository,
      sharedPreferences: sharedPreferences,
    ).getDailyMessageSpellViewModel();
  },
);

class DailyMessageSpellViewModel {
  final String spellId;
  final String subtitle;
  final String imageUrl;

  DailyMessageSpellViewModel({
    required this.spellId,
    required this.subtitle,
    required this.imageUrl,
  });
}

class DailyMessageSpellModel {
  final String id;
  final String spellId;
  final String subtitle;

  DailyMessageSpellModel({
    required this.id,
    required this.spellId,
    required this.subtitle,
  });

  factory DailyMessageSpellModel.fromJson(Map<String, dynamic> json) {
    return DailyMessageSpellModel(
      id: json['id'] as String,
      spellId: json['spellId'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}

class DailyMessagesSpells {
  final SharedPreferencesWithCache sharedPreferences;
  final SpellImagesRepository spellImagesRepository;

  static String assetPath = 'assets/daily_messages_spells.json';
  static String readSpellIdsKey = 'read_daily_message_spells';

  DailyMessagesSpells({
    required this.spellImagesRepository,
    required this.sharedPreferences,
  });

  Future<DailyMessageSpellViewModel> getDailyMessageSpellViewModel() async {
    final dailyMessages = await getDailyMessageSpells();

    final readSpellIds = await getAllReadSpellIds();

    dailyMessages.removeWhere(
      (message) => readSpellIds.contains(message.spellId),
    );
    if (dailyMessages.isEmpty) {
      // If all spells have been read, reset the read list and use all spells
      await clearReadSpells();
      dailyMessages.addAll(await getDailyMessageSpells());
    }

    final dailyMessagesShuffled = dailyMessages.toList()..shuffle();
    for (final dailyMessage in dailyMessagesShuffled) {
      final imagePath =
          await spellImagesRepository.getImagePath(dailyMessage.spellId);

      if (imagePath == null) {
        continue;
      }
      markSpellAsRead(dailyMessage.spellId);
      return DailyMessageSpellViewModel(
        spellId: dailyMessage.spellId,
        subtitle: dailyMessage.subtitle,
        imageUrl: imagePath,
      );
    }
    return DailyMessageSpellViewModel(
      spellId: dailyMessagesShuffled.first.spellId,
      subtitle: dailyMessagesShuffled.first.subtitle,
      imageUrl: '',
    );
  }

  Future<bool> spellImageExists(String spellSlug) async {
    return spellImagesRepository.fileExists(spellSlug);
  }

  Future<List<DailyMessageSpellModel>> getDailyMessageSpells() async {
    final jsonAsset = await rootBundle.loadString(assetPath);
    final jsonData = await compute(jsonDecode, jsonAsset);
    final dailyMessagesSpells = List.from(jsonData)
        .map(
          (e) {
            try {
              return DailyMessageSpellModel.fromJson(e);
            } catch (e) {
              return null;
            }
          },
        )
        .nonNulls
        .toList();
    return dailyMessagesSpells;
  }

  Future<List<String>> getAllReadSpellIds() async {
    final readSpellIds = sharedPreferences.getStringList(
      readSpellIdsKey,
    );
    return readSpellIds ?? [];
  }

  Future<List<String>> markSpellAsRead(String spellId) async {
    final readSpellIds = await getAllReadSpellIds();
    if (!readSpellIds.contains(spellId)) {
      readSpellIds.add(spellId);
      await sharedPreferences.setStringList(
        readSpellIdsKey,
        readSpellIds,
      );
    }
    return readSpellIds;
  }

  Future<void> clearReadSpells() async {
    await sharedPreferences.remove(readSpellIdsKey);
  }
}
