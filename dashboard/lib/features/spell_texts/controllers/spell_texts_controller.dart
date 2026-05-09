import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_text.dart';
import '../models/spell.dart';
import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';
import '../models/spells_config.dart';
import '../services/daily_text_repository.dart';
import '../services/llm_provider.dart';
import '../services/prompt_history_service.dart';
import '../services/snippet_service.dart';
import '../services/spell_storage_service.dart';
import '../services/spell_text_service.dart';
import '../services/srd_loader.dart';

class SpellTextsController extends ChangeNotifier {
  static const _keyProvider = 'stt_provider';
  static const _keyApiKey = 'stt_api_key';
  static const _keyModel = 'stt_model';
  static const _keyBaseUrl = 'stt_base_url';
  static const _keySpells = 'stt_spells';

  final _repository = DailyTextRepository();

  SpellTextService? service;
  PromptHistoryService? promptHistory;
  SnippetService? snippetService;

  List<Spell> spells = [];
  List<DailyText> firestoreTexts = [];
  Map<String, SrdSpell> srdSpells = {};

  bool loadingService = true;
  bool loadingFirestore = true;
  String? error;

  LlmProvider provider = LlmProvider.openAI;
  String apiKey = '';
  String model = 'gpt-5.4-nano-2026-03-17';
  String baseUrl = '';

  // ---------------------------------------------------------------------------
  // Computed
  // ---------------------------------------------------------------------------

  List<SpellTextResult> get readyToPush {
    final svc = service;
    if (svc == null) return [];
    final firestoreIds = firestoreTexts.map((t) => t.id).toSet();
    return svc.results
        .where((r) =>
            r.status == SpellTextStatus.accepted &&
            !firestoreIds.contains(r.id))
        .toList();
  }

  Set<String> get textDuplicateIds {
    final textsBySpell = <String, Set<String>>{};
    for (final t in firestoreTexts) {
      textsBySpell.putIfAbsent(t.spellId, () => {}).add(t.subtitle.trim());
    }
    return {
      for (final r in readyToPush)
        if (textsBySpell[r.spellId]?.contains(r.generatedText.trim()) == true)
          r.id,
    };
  }

  Map<String, int> get firestoreCountBySpellId => {
        for (final spell in spells)
          spell.id: firestoreTexts.where((t) => t.spellId == spell.id).length,
      };

  int get pendingCount =>
      service?.results.where((r) => r.status == SpellTextStatus.pending).length ?? 0;

  // ---------------------------------------------------------------------------
  // Init
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    await Future.wait([_initService(), loadFirestore(), _loadSrdSpells()]);
  }

  Future<void> _loadSrdSpells() async {
    final loaded = await SrdLoader.loadSpells();
    srdSpells = {for (final s in loaded) s.id: s};
    notifyListeners();
  }

  Future<void> _initService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProvider = prefs.getString(_keyProvider);
      provider = LlmProvider.values.firstWhere(
        (p) => p.name == savedProvider,
        orElse: () => LlmProvider.openAI,
      );
      apiKey = prefs.getString(_keyApiKey) ?? '';
      model = prefs.getString(_keyModel) ?? 'gpt-5.4-nano-2026-03-17';
      baseUrl = prefs.getString(_keyBaseUrl) ?? '';
      final rawSpells = prefs.getStringList(_keySpells) ?? [];
      spells = rawSpells.map(_spellFromRaw).whereType<Spell>().toList();
      await _buildServices();
    } catch (e) {
      error = e.toString();
      loadingService = false;
      notifyListeners();
    }
  }

  Future<void> _buildServices() async {
    if (apiKey.isEmpty && provider != LlmProvider.ollama) {
      loadingService = false;
      notifyListeners();
      return;
    }
    final config = SpellsConfig(
      provider: provider,
      apiKey: apiKey,
      model: model,
      baseUrl: baseUrl.isEmpty ? null : baseUrl,
    );
    final snippets = SnippetService();
    await snippets.init();
    final svc = SpellTextService(
      config: config,
      storage: SpellStorageService(),
      snippetService: snippets,
    );
    final history = PromptHistoryService();
    await svc.init();
    await history.init();

    service = svc;
    promptHistory = history;
    snippetService = snippets;
    loadingService = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Config & Spells
  // ---------------------------------------------------------------------------

  Future<void> saveConfig({
    required LlmProvider newProvider,
    required String newApiKey,
    required String newModel,
    required String newBaseUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProvider, newProvider.name);
    await prefs.setString(_keyApiKey, newApiKey);
    await prefs.setString(_keyModel, newModel);
    await prefs.setString(_keyBaseUrl, newBaseUrl);

    provider = newProvider;
    apiKey = newApiKey;
    model = newModel;
    baseUrl = newBaseUrl;
    loadingService = true;
    notifyListeners();
    try {
      await _buildServices();
    } catch (e) {
      error = e.toString();
      loadingService = false;
      notifyListeners();
    }
  }

  Future<void> saveSpells(List<Spell> newSpells) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _keySpells, newSpells.map(_spellToRaw).toList());
    spells = newSpells;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Firestore
  // ---------------------------------------------------------------------------

  Future<void> loadFirestore() async {
    loadingFirestore = true;
    notifyListeners();
    final texts = await _repository.fetchAll();
    firestoreTexts = texts;
    loadingFirestore = false;
    notifyListeners();
  }

  /// Pushes all newly accepted results to Firestore. Returns count pushed.
  Future<int> uploadAccepted() async {
    if (service == null) return 0;
    final toUpload = readyToPush
        .map((r) =>
            DailyText(id: r.id, spellId: r.spellId, subtitle: r.generatedText))
        .toList();
    for (final text in toUpload) {
      await _repository.add(text);
    }
    await loadFirestore();
    return toUpload.length;
  }

  Future<void> pushSingle(SpellTextResult result) async {
    await _repository.add(
      DailyText(
          id: result.id,
          spellId: result.spellId,
          subtitle: result.generatedText),
    );
    await loadFirestore();
  }

  Future<void> deleteFirestore(DailyText text) async {
    await _repository.delete(text.id);
    await loadFirestore();
  }

  Future<void> updateFirestore(DailyText text) async {
    await _repository.update(text);
    await loadFirestore();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String _spellToRaw(Spell s) => '${s.id}|${s.title}|${s.description}';

  static Spell? _spellFromRaw(String raw) {
    final parts = raw.split('|');
    if (parts.length < 3) return null;
    return Spell(
        id: parts[0],
        title: parts[1],
        description: parts.sublist(2).join('|'));
  }
}
