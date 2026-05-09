import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/daily_text.dart';
import 'models/spell.dart';
import 'models/spell_text_result.dart';
import 'models/spell_text_status.dart';
import 'models/spells_config.dart';
import 'services/daily_text_repository.dart';
import 'services/llm_provider.dart';
import 'services/prompt_history_service.dart';
import 'services/snippet_service.dart';
import 'services/spell_storage_service.dart';
import 'services/spell_text_service.dart';
import 'services/srd_loader.dart';
import 'widgets/firestore_tab.dart';
import 'widgets/generate_tab.dart';
import 'widgets/snippet_manager_dialog.dart';
import 'widgets/spell_picker_dialog.dart';
import 'widgets/spell_sort_dropdown.dart';
import 'widgets/staging_tab.dart';

class SpellTextsHostPage extends StatefulWidget {
  const SpellTextsHostPage({super.key});

  @override
  State<SpellTextsHostPage> createState() => _SpellTextsHostPageState();
}

class _SpellTextsHostPageState extends State<SpellTextsHostPage> {
  static const _keyProvider = 'stt_provider';
  static const _keyApiKey = 'stt_api_key';
  static const _keyModel = 'stt_model';
  static const _keyBaseUrl = 'stt_base_url';
  static const _keySpells = 'stt_spells';

  // LLM generation
  SpellTextService? _service;
  PromptHistoryService? _promptHistory;
  SnippetService? _snippetService;
  List<Spell> _spells = [];
  bool _loadingService = true;
  String? _error;
  LlmProvider _provider = LlmProvider.openAI;
  String _apiKey = '';
  String _model = 'gpt-4o-mini';
  String _baseUrl = '';

  // DailyText / Firestore
  final _repository = DailyTextRepository();
  List<DailyText> _firestoreTexts = [];
  bool _loadingFirestore = true;

  // SRD lookup + sort
  Map<String, SrdSpell> _srdSpells = {};
  SpellSortBy _firestoreSort = SpellSortBy.levelThenName;

  @override
  void initState() {
    super.initState();
    _initService();
    _loadFirestore();
    _loadSrdSpells();
  }

  Future<void> _loadSrdSpells() async {
    final spells = await SrdLoader.loadSpells();
    if (mounted) {
      setState(() => _srdSpells = {for (final s in spells) s.id: s});
    }
  }

  // ---------------------------------------------------------------------------
  // Service init
  // ---------------------------------------------------------------------------

  Future<void> _initService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProvider = prefs.getString(_keyProvider);
      _provider = LlmProvider.values.firstWhere(
        (p) => p.name == savedProvider,
        orElse: () => LlmProvider.openAI,
      );
      _apiKey = prefs.getString(_keyApiKey) ?? '';
      _model = prefs.getString(_keyModel) ?? 'gpt-4o-mini';
      _baseUrl = prefs.getString(_keyBaseUrl) ?? '';
      final rawSpells = prefs.getStringList(_keySpells) ?? [];
      _spells = rawSpells.map(_spellFromRaw).whereType<Spell>().toList();
      await _buildServices();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loadingService = false;
        });
      }
    }
  }

  Future<void> _buildServices() async {
    if (_apiKey.isEmpty && _provider != LlmProvider.ollama) {
      if (mounted) setState(() => _loadingService = false);
      return;
    }
    final config = SpellsConfig(
      provider: _provider,
      apiKey: _apiKey,
      model: _model,
      baseUrl: _baseUrl.isEmpty ? null : _baseUrl,
    );
    final snippetService = SnippetService();
    await snippetService.init();

    final service = SpellTextService(
      config: config,
      storage: SpellStorageService(),
      snippetService: snippetService,
    );
    final history = PromptHistoryService();
    await service.init();
    await history.init();

    if (mounted) {
      setState(() {
        _service = service;
        _promptHistory = history;
        _snippetService = snippetService;
        _loadingService = false;
      });
    }
  }

  Future<void> _saveConfig({
    required LlmProvider provider,
    required String apiKey,
    required String model,
    required String baseUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProvider, provider.name);
    await prefs.setString(_keyApiKey, apiKey);
    await prefs.setString(_keyModel, model);
    await prefs.setString(_keyBaseUrl, baseUrl);
    setState(() {
      _provider = provider;
      _apiKey = apiKey;
      _model = model;
      _baseUrl = baseUrl;
      _loadingService = true;
    });
    await _buildServices();
  }

  Future<void> _saveSpells(List<Spell> spells) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySpells, spells.map(_spellToRaw).toList());
    setState(() => _spells = spells);
  }

  static String _spellToRaw(Spell s) =>
      '${s.id}|${s.title}|${s.description}';

  static Spell? _spellFromRaw(String raw) {
    final parts = raw.split('|');
    if (parts.length < 3) return null;
    return Spell(
        id: parts[0],
        title: parts[1],
        description: parts.sublist(2).join('|'));
  }

  // ---------------------------------------------------------------------------
  // Firestore
  // ---------------------------------------------------------------------------

  Future<void> _loadFirestore() async {
    setState(() => _loadingFirestore = true);
    final texts = await _repository.fetchAll();
    if (mounted) {
      setState(() {
        _firestoreTexts = texts;
        _loadingFirestore = false;
      });
    }
  }

  Future<void> _uploadAcceptedToFirestore() async {
    if (_service == null) return;
    final firestoreIds = _firestoreTexts.map((t) => t.id).toSet();
    final accepted = _service!.results
        .where((r) =>
            r.status == SpellTextStatus.accepted &&
            !firestoreIds.contains(r.id))
        .map((r) =>
            DailyText(id: r.id, spellId: r.spellId, subtitle: r.generatedText))
        .toList();
    if (accepted.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No new accepted results to push.')),
        );
      }
      return;
    }
    for (final text in accepted) {
      await _repository.add(text);
    }
    await _loadFirestore();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Pushed ${accepted.length} texts to Firestore.')),
      );
    }
  }

  Future<void> _pushSingle(SpellTextResult result) async {
    await _repository.add(
      DailyText(
          id: result.id,
          spellId: result.spellId,
          subtitle: result.generatedText),
    );
    await _loadFirestore();
  }

  void _confirmDeleteFirestore(DailyText text) {
    final spellName = _srdSpells[text.spellId]?.name ?? text.spellId;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete text?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spellName,
                style: Theme.of(ctx).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(text.subtitle),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await _repository.delete(text.id);
              await _loadFirestore();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(DailyText text) {
    final spellIdCtrl = TextEditingController(text: text.spellId);
    final subtitleCtrl = TextEditingController(text: text.subtitle);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Text'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: text.id),
                decoration: const InputDecoration(labelText: 'ID'),
                enabled: false,
              ),
              TextField(
                controller: spellIdCtrl,
                decoration: const InputDecoration(labelText: 'Spell ID'),
              ),
              TextField(
                controller: subtitleCtrl,
                decoration: const InputDecoration(labelText: 'Subtitle'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final updated = DailyText(
                id: text.id,
                spellId: spellIdCtrl.text.trim(),
                subtitle: subtitleCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              _repository.update(updated).then((_) => _loadFirestore());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dialogs
  // ---------------------------------------------------------------------------

  void _openSettings() {
    showDialog<void>(
      context: context,
      builder: (_) => _LlmConfigDialog(
        provider: _provider,
        apiKey: _apiKey,
        model: _model,
        baseUrl: _baseUrl,
        onSave: _saveConfig,
      ),
    );
  }

  void _openSpellManager() {
    final firestoreCount = {
      for (final spell in _spells)
        spell.id:
            _firestoreTexts.where((t) => t.spellId == spell.id).length,
    };
    showDialog<void>(
      context: context,
      builder: (_) => _SpellManagerDialog(
        spells: _spells,
        onSave: _saveSpells,
        firestoreCount: firestoreCount,
      ),
    );
  }

  void _openSnippetManager() {
    if (_snippetService == null) return;
    SnippetManagerDialog.show(context, _snippetService!);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final service = _service;
    final firestoreIds = _firestoreTexts.map((t) => t.id).toSet();
    final readyToPush = service?.results
            .where((r) =>
                r.status == SpellTextStatus.accepted &&
                !firestoreIds.contains(r.id))
            .toList() ??
        [];

    // IDs of ready-to-push items whose text content already exists in Firestore
    // for the same spell (content match, different ID).
    final firestoreTextsBySpell = <String, Set<String>>{};
    for (final t in _firestoreTexts) {
      firestoreTextsBySpell
          .putIfAbsent(t.spellId, () => {})
          .add(t.subtitle.trim());
    }
    final textDuplicateIds = {
      for (final r in readyToPush)
        if (firestoreTextsBySpell[r.spellId]
                ?.contains(r.generatedText.trim()) ==
            true)
          r.id,
    };
    final pendingCount = service?.results
            .where((r) => r.status == SpellTextStatus.pending)
            .length ??
        0;
    final firestoreCount = <String, int>{
      for (final spell in _spells)
        spell.id:
            _firestoreTexts.where((t) => t.spellId == spell.id).length,
    };

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              const Tab(text: 'Generate'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Staging'),
                    if (pendingCount > 0) ...[
                      const SizedBox(width: 6),
                      _TabBadge(count: pendingCount),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Firestore'),
                    if (readyToPush.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      _TabBadge(
                        count: readyToPush.length,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              children: [
                _buildGenerateTab(firestoreCount),
                _buildStagingTab(service, firestoreCount),
                _buildFirestoreTab(readyToPush, textDuplicateIds),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab body builders
  // ---------------------------------------------------------------------------

  Widget _buildGenerateTab(Map<String, int> firestoreCount) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              const Spacer(),
              TextButton.icon(
                onPressed: _openSpellManager,
                icon: const Icon(Icons.list, size: 18),
                label: Text('Spells (${_spells.length})'),
              ),
              const SizedBox(width: 4),
              if (_snippetService != null)
                IconButton(
                  tooltip: 'Manage snippets',
                  icon: const Icon(Icons.extension_outlined),
                  onPressed: _openSnippetManager,
                ),
              IconButton(
                tooltip: 'LLM settings',
                icon: const Icon(Icons.settings),
                onPressed: _openSettings,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: _buildGenerateBody(firestoreCount)),
      ],
    );
  }

  Widget _buildGenerateBody(Map<String, int> firestoreCount) {
    if (_loadingService) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) return Center(child: Text('Error: $_error'));
    if (_apiKey.isEmpty && _provider != LlmProvider.ollama) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Configure your LLM API key to get started.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _openSettings,
              icon: const Icon(Icons.settings),
              label: const Text('Open settings'),
            ),
          ],
        ),
      );
    }
    if (_spells.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add spells to generate texts for.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _openSpellManager,
              icon: const Icon(Icons.add),
              label: const Text('Manage spells'),
            ),
          ],
        ),
      );
    }
    return GenerateTab(
      spells: _spells,
      service: _service!,
      promptHistory: _promptHistory!,
      snippetService: _snippetService!,
      provider: _provider,
      firestoreCountBySpellId: firestoreCount,
    );
  }

  Widget _buildStagingTab(
      SpellTextService? service, Map<String, int> firestoreCount) {
    if (service == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return StagingTab(
      key: ValueKey(service),
      service: service,
      spells: _spells,
      firestoreCountBySpellId: firestoreCount,
      onPushAccepted: () async {
        await _uploadAcceptedToFirestore();
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildFirestoreTab(
      List<SpellTextResult> readyToPush, Set<String> textDuplicateIds) {
    return FirestoreTab(
      firestoreTexts: _firestoreTexts,
      loadingFirestore: _loadingFirestore,
      readyToPush: readyToPush,
      textDuplicateIds: textDuplicateIds,
      srdSpells: _srdSpells,
      sort: _firestoreSort,
      onSortChanged: (v) => setState(() => _firestoreSort = v),
      onRefresh: _loadFirestore,
      onEdit: _showEditDialog,
      onDelete: _confirmDeleteFirestore,
      onPushSingle: (result) async {
        await _pushSingle(result);
        if (mounted) setState(() {});
      },
      onPushAll: () async {
        await _uploadAcceptedToFirestore();
        if (mounted) setState(() {});
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Tab badge
// ---------------------------------------------------------------------------

class _TabBadge extends StatelessWidget {
  final int count;
  final Color? color;

  const _TabBadge({required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color ?? scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          color: color != null ? Colors.white : scheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LLM config dialog
// ---------------------------------------------------------------------------

class _LlmConfigDialog extends StatefulWidget {
  final LlmProvider provider;
  final String apiKey;
  final String model;
  final String baseUrl;
  final Future<void> Function({
    required LlmProvider provider,
    required String apiKey,
    required String model,
    required String baseUrl,
  }) onSave;

  const _LlmConfigDialog({
    required this.provider,
    required this.apiKey,
    required this.model,
    required this.baseUrl,
    required this.onSave,
  });

  @override
  State<_LlmConfigDialog> createState() => _LlmConfigDialogState();
}

class _LlmConfigDialogState extends State<_LlmConfigDialog> {
  late LlmProvider _provider;
  late final TextEditingController _apiKey;
  late final TextEditingController _model;
  late final TextEditingController _baseUrl;

  @override
  void initState() {
    super.initState();
    _provider = widget.provider;
    _apiKey = TextEditingController(text: widget.apiKey);
    _model = TextEditingController(text: widget.model);
    _baseUrl = TextEditingController(text: widget.baseUrl);
  }

  @override
  void dispose() {
    _apiKey.dispose();
    _model.dispose();
    _baseUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('LLM Settings'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<LlmProvider>(
              initialValue: _provider,
              decoration: const InputDecoration(labelText: 'Provider'),
              items: LlmProvider.values
                  .map((p) =>
                      DropdownMenuItem(value: p, child: Text(p.name)))
                  .toList(),
              onChanged: (v) => setState(() => _provider = v!),
            ),
            const SizedBox(height: 12),
            if (_provider != LlmProvider.ollama)
              TextField(
                controller: _apiKey,
                decoration: const InputDecoration(labelText: 'API Key'),
                obscureText: true,
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _model,
              decoration: const InputDecoration(labelText: 'Model'),
            ),
            if (_provider == LlmProvider.ollama) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _baseUrl,
                decoration: const InputDecoration(
                  labelText: 'Base URL',
                  hintText: 'http://localhost:11434/api',
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            await widget.onSave(
              provider: _provider,
              apiKey: _apiKey.text.trim(),
              model: _model.text.trim(),
              baseUrl: _baseUrl.text.trim(),
            );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Spell manager dialog
// ---------------------------------------------------------------------------

class _SpellManagerDialog extends StatefulWidget {
  final List<Spell> spells;
  final Future<void> Function(List<Spell>) onSave;
  final Map<String, int> firestoreCount;

  const _SpellManagerDialog({
    required this.spells,
    required this.onSave,
    required this.firestoreCount,
  });

  @override
  State<_SpellManagerDialog> createState() => _SpellManagerDialogState();
}

class _SpellManagerDialogState extends State<_SpellManagerDialog> {
  late final List<Spell> _spells;
  final _idCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _showManual = false;

  @override
  void initState() {
    super.initState();
    _spells = List.of(widget.spells);
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _add() {
    final id = _idCtrl.text.trim();
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    if (id.isEmpty || title.isEmpty) return;
    setState(() {
      _spells.add(Spell(id: id, title: title, description: desc));
      _idCtrl.clear();
      _titleCtrl.clear();
      _descCtrl.clear();
    });
  }

  Future<void> _pickFromSrd() async {
    final picked = await SpellPickerDialog.show(context,
        firestoreCount: widget.firestoreCount);
    if (picked == null || picked.isEmpty) return;
    setState(() {
      for (final spell in picked) {
        if (!_spells.any((s) => s.id == spell.id)) {
          _spells.add(spell);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Spells'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: _pickFromSrd,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Browse SRD spells'),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    setState(() => _showManual = !_showManual),
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.outline,
                  textStyle: Theme.of(context).textTheme.bodySmall,
                ),
                child: Text(
                    _showManual ? 'Hide manual add' : 'Add manually…'),
              ),
            ),
            if (_showManual) ...[
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _idCtrl,
                      decoration:
                          const InputDecoration(labelText: 'ID'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _titleCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Title'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Description'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _add,
                    tooltip: 'Add spell',
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            if (_spells.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _spells.length,
                  itemBuilder: (context, index) {
                    final spell = _spells[index];
                    return ListTile(
                      dense: true,
                      title: Text('${spell.title} (${spell.id})'),
                      subtitle: Text(
                        spell.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 18),
                        onPressed: () =>
                            setState(() => _spells.removeAt(index)),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            await widget.onSave(_spells);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
