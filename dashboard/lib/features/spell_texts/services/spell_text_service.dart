import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../models/prompt_template.dart';
import '../models/spell.dart';
import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';
import '../models/spells_config.dart';
import 'llm_client.dart';
import 'llm_client_factory.dart';
import 'spell_storage_service.dart';

class SpellTextService {
  final SpellStorageService _storage;
  final LlmClient _llm;
  final void Function(SpellTextResult)? onAccepted;
  final void Function(SpellTextResult)? onDismissed;

  final List<SpellTextResult> _results = [];
  final _uuid = const Uuid();

  SpellTextService({
    required SpellsConfig config,
    SpellStorageService? storage,
    LlmClient? llmClientOverride,
    this.onAccepted,
    this.onDismissed,
  })  : _storage = storage ?? SpellStorageService(),
        _llm = llmClientOverride ?? buildLlmClient(config);

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
  }) async {
    final prompt = promptTemplate.resolve(spell);
    final text = await _llm.generate(prompt);

    final result = SpellTextResult(
      id: _uuid.v4(),
      spellId: spell.id,
      spellTitle: spell.title,
      spellDescription: spell.description,
      generatedText: text,
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
  }) async {
    final generated = <SpellTextResult>[];
    for (final spell in spells) {
      for (var i = 0; i < count; i++) {
        generated.add(await generate(spell: spell, promptTemplate: promptTemplate));
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
