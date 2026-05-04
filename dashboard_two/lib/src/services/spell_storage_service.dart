import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/spell_text_result.dart';

class SpellStorageService {
  static const _fileName = 'spell_text_results.json';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<SpellTextResult>> loadAll() async {
    final file = await _getFile();
    if (!file.existsSync()) return [];

    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents) as List<dynamic>;
    return jsonList
        .map((e) => SpellTextResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<SpellTextResult> results) async {
    final file = await _getFile();
    final jsonList = results.map((r) => r.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}
