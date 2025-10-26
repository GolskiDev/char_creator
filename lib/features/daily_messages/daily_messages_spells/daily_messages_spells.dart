import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../5e/spells/spell_images/spell_images_repository.dart';

final dailyMessageSpellViewModelProvider = FutureProvider(
  (ref) {
    final spellImagesRepository = ref.watch(spellImagesRepositoryProvider);
    return DailyMessagesSpells(
      spellImagesRepository: spellImagesRepository,
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
  final String spellId;
  final String subtitle;

  DailyMessageSpellModel({
    required this.spellId,
    required this.subtitle,
  });

  factory DailyMessageSpellModel.fromJson(Map<String, dynamic> json) {
    return DailyMessageSpellModel(
      spellId: json['id'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}

class DailyMessagesSpells {
  final SpellImagesRepository spellImagesRepository;

  static String assetPath = 'assets/daily_messages_spells.json';

  DailyMessagesSpells({required this.spellImagesRepository});

  Future<DailyMessageSpellViewModel> getDailyMessageSpellViewModel() async {
    final dailyMessages = await getDailyMessageSpells();
    final dailyMessagesShuffled = dailyMessages.toList()..shuffle();
    for (final dailyMessage in dailyMessagesShuffled) {
      final exists = await spellImageExists(dailyMessage.spellId);
      if (exists) {
        final imagePath =
            await spellImagesRepository.getImagePath(dailyMessage.spellId);
        if (imagePath == null) {
          continue;
        }
        return DailyMessageSpellViewModel(
          spellId: dailyMessage.spellId,
          subtitle: dailyMessage.subtitle,
          imageUrl: imagePath,
        );
      }
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
        .map((e) => DailyMessageSpellModel.fromJson(e))
        .toList();
    return dailyMessagesSpells;
  }
}
