import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../models/prompt_template.dart';
import '../models/spell.dart';
import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';
import '../models/spells_config.dart';
import 'llm_client.dart';
import 'llm_client_factory.dart';
import 'llm_response_parser.dart';
import 'snippet_service.dart';
import 'spell_storage_service.dart';

class SpellTextService {
  final SpellStorageService _storage;
  final LlmClient _llm;
  final SnippetService? _snippetService;
  final void Function(SpellTextResult)? onAccepted;
  final void Function(SpellTextResult)? onDismissed;

  final List<SpellTextResult> _results = [];
  final _uuid = const Uuid();

  SpellTextService({
    required SpellsConfig config,
    SpellStorageService? storage,
    LlmClient? llmClientOverride,
    SnippetService? snippetService,
    this.onAccepted,
    this.onDismissed,
  })  : _storage = storage ?? SpellStorageService(),
        _llm = llmClientOverride ?? buildLlmClient(config),
        _snippetService = snippetService;

  List<SpellTextResult> get results => List.unmodifiable(_results);

  /// Loads previously persisted results from storage.
  Future<void> init() async {
    final saved = await _storage.loadAll();
    _results
      ..clear()
      ..addAll(saved);
  }

  /// Sends the resolved prompt to the LLM and stores the result with [pending] status.
  Future<SpellTextResult> generate({
    required Spell spell,
    required PromptTemplate promptTemplate,
    double temperature = 1.0,
  }) async {
    final snippetMap = <String, String>{
      for (final s in (_snippetService?.snippets ?? [])) s.name: s.content,
    };
    final prompt = promptTemplate.resolve(spell, snippets: snippetMap);
    final raw = await _llm.generate(prompt, temperature: temperature);
    final parsed = parseLlmResponse(raw);

    final result = SpellTextResult(
      id: _uuid.v4(),
      spellId: spell.id,
      spellTitle: spell.title,
      spellDescription: spell.description,
      generatedText: parsed.text,
      metadata: parsed.metadata,
      temperature: temperature,
      createdAt: DateTime.now(),
    );

    _results.insert(0, result);
    await _storage.saveAll(_results);
    return result;
  }

  /// Generates [count] texts for each spell in [spells] sequentially.
  Future<List<SpellTextResult>> generateBatch({
    required List<Spell> spells,
    required PromptTemplate promptTemplate,
    required int count,
    double temperature = 1.0,
  }) async {
    final generated = <SpellTextResult>[];
    for (final spell in spells) {
      for (var i = 0; i < count; i++) {
        generated.add(await generate(
          spell: spell,
          promptTemplate: promptTemplate,
          temperature: temperature,
        ));
      }
    }
    return generated;
  }

  /// Returns all results for a specific spell, preserving newest-first order.
  List<SpellTextResult> resultsForSpell(String spellId) =>
      _results.where((r) => r.spellId == spellId).toList();

  /// Marks a result as accepted and fires [onAccepted].
  Future<void> accept(String id) async {
    final result = _findById(id);
    result.status = SpellTextStatus.accepted;
    await _storage.saveAll(_results);
    onAccepted?.call(result);
  }

  /// Marks a result as dismissed and fires [onDismissed].
  Future<void> dismiss(String id) async {
    final result = _findById(id);
    result.status = SpellTextStatus.dismissed;
    await _storage.saveAll(_results);
    onDismissed?.call(result);
  }

  /// Imports a list of results, skipping any with IDs that already exist.
  /// Returns the number of duplicates skipped.
  Future<int> importResults(List<SpellTextResult> incoming) async {
    final existingIds = _results.map((r) => r.id).toSet();
    final toAdd = incoming.where((r) => !existingIds.contains(r.id)).toList();
    final skipped = incoming.length - toAdd.length;
    _results.insertAll(0, toAdd);
    await _storage.saveAll(_results);
    return skipped;
  }

  /// Removes a result by ID.
  Future<void> deleteResult(String id) async {
    _results.removeWhere((r) => r.id == id);
    await _storage.saveAll(_results);
  }

  /// Returns a JSON string of accepted results in DailyText format {id, spellId, subtitle}.
  String exportAcceptedToJson() {
    final accepted = _results.where((r) => r.status == SpellTextStatus.accepted);
    return jsonEncode(
      accepted
          .map((r) => {'id': r.id, 'spellId': r.spellId, 'subtitle': r.generatedText})
          .toList(),
    );
  }

  SpellTextResult _findById(String id) {
    return _results.firstWhere((r) => r.id == id);
  }
}
