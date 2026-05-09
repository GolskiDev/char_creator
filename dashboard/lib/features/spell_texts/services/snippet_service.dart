import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/prompt_snippet.dart';

class SnippetService {
  static const _prefsKey = 'spell_prompt_snippets';

  final _uuid = const Uuid();
  final List<PromptSnippet> _snippets = [];

  List<PromptSnippet> get snippets => List.unmodifiable(_snippets);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
    _snippets
      ..clear()
      ..addAll(
        jsonList.map((e) => PromptSnippet.fromJson(e as Map<String, dynamic>)),
      );
  }

  /// Adds a new snippet. Throws [ArgumentError] if [name] is already in use or invalid.
  Future<PromptSnippet> add(String name, String content) async {
    if (!PromptSnippet.isValidName(name)) {
      throw ArgumentError('Snippet name must match [a-z0-9_-]+');
    }
    if (_snippets.any((s) => s.name == name)) {
      throw ArgumentError('A snippet named "$name" already exists.');
    }
    final snippet = PromptSnippet(
      id: _uuid.v4(),
      name: name,
      content: content,
      createdAt: DateTime.now(),
    );
    _snippets.add(snippet);
    await _persist();
    return snippet;
  }

  Future<void> update(PromptSnippet updated) async {
    final idx = _snippets.indexWhere((s) => s.id == updated.id);
    if (idx == -1) return;
    // Check for name collision (ignoring the snippet being updated).
    if (_snippets.any((s) => s.name == updated.name && s.id != updated.id)) {
      throw ArgumentError('A snippet named "${updated.name}" already exists.');
    }
    _snippets[idx] = updated;
    await _persist();
  }

  Future<void> delete(String id) async {
    _snippets.removeWhere((s) => s.id == id);
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(_snippets.map((s) => s.toJson()).toList()),
    );
  }
}
