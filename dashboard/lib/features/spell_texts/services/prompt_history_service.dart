import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/prompt_template.dart';

class PromptHistoryService {
  static const _prefsKey = 'spell_prompt_history';
  static const _maxEntries = 20;

  final _uuid = const Uuid();
  final List<PromptTemplate> _history = [];

  List<PromptTemplate> get history => List.unmodifiable(_history);

  PromptTemplate? get latest => _history.isEmpty ? null : _history.first;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
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

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(_history.map((t) => t.toJson()).toList()),
    );
  }
}
