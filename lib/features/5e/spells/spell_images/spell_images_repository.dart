import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final spellImagesRepositoryProvider = Provider<SpellImagesRepository>(
  (ref) {
    return SpellImagesRepository();
  },
);

final spellImagePathProvider = FutureProvider.family<String?, String>(
  (ref, spellSlug) {
    final repository = ref.watch(spellImagesRepositoryProvider);
    return repository.getImagePath(spellSlug);
  },
);

class SpellImagesRepository {
  final String _basePath = 'assets/images/spells/';

  Future<bool> fileExists(String spellSlug) async {
    try {
      final assetPath = imageNameToPath(spellSlug);
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getImagePath(String spellSlug) async {
    final imageName = spellSlugToImageName(spellSlug);
    final exists = await fileExists(imageName);
    if (exists) {
      return imageNameToPath(imageName);
    } else {
      return null;
    }
  }

  String spellSlugToImageName(String spellSlug) {
    return spellSlug.replaceAll('-', '_');
  }

  String imageNameToPath(String imageName) {
    return '$_basePath$imageName.webp';
  }
}
