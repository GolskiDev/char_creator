import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  if (arguments.isEmpty || arguments.length > 2) {
    print('Usage: dart list_all_spells.dart <index> [end_index]');
    exit(1);
  }

  final spellsFile = File('../assets/spells.json');
  final spellsJson = jsonDecode(await spellsFile.readAsString()) as List;

  final spells = spellsJson
      .where((spell) => spell is Map && spell.containsKey('id'))
      .toList();

  spells.sort((a, b) {
    final levelA = a['level'] ?? 0;
    final levelB = b['level'] ?? 0;
    if (levelA != levelB) {
      return levelA.compareTo(levelB);
    }
    final nameA = (a['name'] ?? '').toString();
    final nameB = (b['name'] ?? '').toString();
    return nameA.compareTo(nameB);
  });

  int startIdx = int.tryParse(arguments[0]) ?? -1;
  int endIdx = startIdx;
  if (arguments.length == 2) {
    endIdx = int.tryParse(arguments[1]) ?? -1;
  }

  if (startIdx < 0 || endIdx < startIdx || endIdx >= spells.length) {
    print('Index out of range. Valid range: 0 to ${spells.length - 1}');
    exit(1);
  }

  for (int i = startIdx; i <= endIdx; i++) {
    final spell = spells[i];
    final imageId = spell['id'] ?? 'N/A';
    final description = spell['description'] ?? 'No description';
    print('id: $imageId');
    print('Description: $description');
    print('---');
  }
}
