import 'dart:convert';
import 'dart:io';

void main() async {
  // Load spells.json
  final spellsFile = File('../assets/spells.json');
  final spellsJson = jsonDecode(await spellsFile.readAsString()) as List;
  final spellIds = spellsJson
      .where((spell) => spell is Map && spell.containsKey('id'))
      .map((spell) => spell['id'] as String)
      .toSet();

  // List image files
  final imagesDir = Directory('../assets/images/spells');
  final imageFiles = imagesDir
      .listSync()
      .whereType<File>()
      .map((f) => f.uri.pathSegments.last.split('.').first)
      .toSet();

  // Convert spell ids to image names (replace - with _)
  final spellImageNames = spellIds.map((id) => id.replaceAll('-', '_')).toSet();

  // Spells missing images
  final missingImages = spellIds
      .where((id) => !imageFiles.contains(id.replaceAll('-', '_')))
      .toList();

  // Images missing spells
  final missingSpells =
      imageFiles.where((img) => !spellImageNames.contains(img)).toList();

  print('Spells missing images ${missingImages.length}:');
  for (var id in missingImages) {
    print(id);
  }

  print('\nImages missing spells ${missingSpells.length}:');
  for (var img in missingSpells) {
    print(img);
  }
}
