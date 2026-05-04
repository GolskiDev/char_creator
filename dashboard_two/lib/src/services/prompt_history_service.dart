import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/prompt_template.dart';

class PromptHistoryService {
  static const _fileName = 'spell_prompt_history.json';
  static const _maxEntries = 20;

  final _uuid = const Uuid();
  final List<PromptTemplate> _history = [];

  List<PromptTemplate> get history => List.unmodifiable(_history);

  PromptTemplate? get latest => _history.isEmpty ? null : _history.first;

  Future<void> init() async {
    final file = await _getFile();
    if (!file.existsSync()) return;

    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents) as List<dynamic>;
    _history
      ..clear()
      ..addAll(
        jsonList.map((e) => PromptTemplate.fromJson(e as Map<String, dynamic>)),
      );
  }

  /// Saves [text] as a new prompt template, prepends it to history, and persists.
  Future<PromptTemplate> save(String text) async {
    final template = PromptTemplate(
      id: _uuid.v4(),
      text: text,
      createdAt: DateTime.now(),
    );
    _history.insert(0, template);
    if (_history.length > _maxEntries) {
      _history.removeRange(_maxEntries, _history.length);
    }
    await _persist();
    return template;
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> _persist() async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(_history.map((t) => t.toJson()).toList()));
  }
}
