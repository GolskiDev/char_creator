import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'models/daily_text.dart';
import 'models/spell.dart';
import 'models/spell_text_status.dart';
import 'models/spells_config.dart';
import 'services/daily_text_repository.dart';
import 'services/llm_provider.dart';
import 'services/prompt_history_service.dart';
import 'services/spell_storage_service.dart';
import 'services/spell_text_service.dart';
import 'services/srd_loader.dart';
import 'widgets/spell_picker_dialog.dart';
import 'widgets/spell_sort_dropdown.dart';
import 'widgets/spell_texts_page.dart';

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
  List<Spell> _spells = [];
  bool _loadingService = true;
  String? _error;
  LlmProvider _provider = LlmProvider.openAI;
  String _apiKey = '';
  String _model = 'gpt-5.4-nano-2026-03-17';
  String _baseUrl = '';

  // DailyText management
  final _repository = DailyTextRepository();
  final _uuid = const Uuid();
  final List<DailyText> _stagingTexts = [];
  List<DailyText> _firestoreTexts = [];
  bool _loadingFirestore = true;

  // SRD lookup for sorting
  Map<String, SrdSpell> _srdSpells = {};
  SpellSortBy _stagingSort = SpellSortBy.levelThenName;
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
    if (mounted) setState(() => _srdSpells = {for (final s in spells) s.id: s});
  }

  // ---------------------------------------------------------------------------
  // LLM service init
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
      _model = prefs.getString(_keyModel) ?? 'gpt-4.1-nano-2026-03-17';
      _baseUrl = prefs.getString(_keyBaseUrl) ?? '';
      final rawSpells = prefs.getStringList(_keySpells) ?? [];
      _spells = rawSpells.map(_spellFromRaw).whereType<Spell>().toList();
      await _buildServices();
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loadingService = false; });
    }
  }

  Future<void> _buildServices() async {
    if (_apiKey.isEmpty && _provider != LlmProvider.ollama) {
      if (mounted) setState(() { _loadingService = false; });
      return;
    }
    final config = SpellsConfig(
      provider: _provider,
      apiKey: _apiKey,
      model: _model,
      baseUrl: _baseUrl.isEmpty ? null : _baseUrl,
    );
    final service = SpellTextService(config: config, storage: SpellStorageService());
    final history = PromptHistoryService();
    await service.init();
    await history.init();
    if (mounted) {
      setState(() {
        _service = service;
        _promptHistory = history;
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

  static String _spellToRaw(Spell s) => '${s.id}|${s.title}|${s.description}';

  static Spell? _spellFromRaw(String raw) {
    final parts = raw.split('|');
    if (parts.length < 3) return null;
    return Spell(id: parts[0], title: parts[1], description: parts.sublist(2).join('|'));
  }

  // ---------------------------------------------------------------------------
  // DailyText management
  // ---------------------------------------------------------------------------

  Future<void> _loadFirestore() async {
    setState(() => _loadingFirestore = true);
    final texts = await _repository.fetchAll();
    if (mounted) setState(() { _firestoreTexts = texts; _loadingFirestore = false; });
  }

  Future<void> _importJson() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.single.bytes == null) return;
    final jsonString = utf8.decode(result.files.single.bytes!);
    final List<dynamic> jsonList = json.decode(jsonString);
    final newTexts = jsonList
        .map((e) => DailyText.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() => _stagingTexts.addAll(newTexts));
  }

  Future<void> _uploadStagingToFirestore() async {
    for (final text in _stagingTexts) {
      await _repository.add(text);
    }
    setState(() => _stagingTexts.clear());
    await _loadFirestore();
  }

  Future<void> _uploadAcceptedToFirestore() async {
    if (_service == null) return;
    final accepted = _service!.results
        .where((r) => r.status == SpellTextStatus.accepted)
        .map((r) => DailyText(id: r.id, spellId: r.spellId, subtitle: r.generatedText))
        .toList();
    if (accepted.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No accepted results to upload.')),
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
        SnackBar(content: Text('Uploaded ${accepted.length} texts to Firestore.')),
      );
    }
  }

  void _showDailyTextDialog(
    BuildContext context, {
    DailyText? existing,
    bool isFirestore = false,
  }) {
    final idCtrl = TextEditingController(text: existing?.id ?? '');
    final spellIdCtrl = TextEditingController(text: existing?.spellId ?? '');
    final subtitleCtrl = TextEditingController(text: existing?.subtitle ?? '');

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Text' : 'Edit Text'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: idCtrl,
                      decoration: const InputDecoration(labelText: 'ID'),
                      enabled: existing == null,
                    ),
                  ),
                  if (existing == null)
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Generate ID',
                      onPressed: () =>
                          idCtrl.text = _uuid.v4().replaceAll('-', '').substring(0, 12),
                    ),
                ],
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = DailyText(
                id: idCtrl.text.trim(),
                spellId: spellIdCtrl.text.trim(),
                subtitle: subtitleCtrl.text.trim(),
              );
              Navigator.pop(context);
              if (existing == null) {
                setState(() => _stagingTexts.add(text));
              } else if (isFirestore) {
                _repository.update(text).then((_) => _loadFirestore());
              } else {
                setState(() {
                  final idx = _stagingTexts.indexWhere((d) => d.id == text.id);
                  if (idx != -1) _stagingTexts[idx] = text;
                });
              }
            },
            child: Text(existing == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showJsonDialog(String jsonString) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Exported JSON'),
        content: SingleChildScrollView(child: SelectableText(jsonString)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Settings dialogs
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
    showDialog<void>(
      context: context,
      builder: (_) => _SpellManagerDialog(spells: _spells, onSave: _saveSpells),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              const Tab(text: 'Generate'),
              Tab(text: 'Staging (${_stagingTexts.length})'),
              const Tab(text: 'Firestore'),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              children: [
                _buildGenerateTab(),
                _buildStagingTab(),
                _buildFirestoreTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateTab() {
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
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'LLM settings',
                icon: const Icon(Icons.settings),
                onPressed: _openSettings,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: _buildGenerateBody()),
      ],
    );
  }

  Widget _buildGenerateBody() {
    if (_loadingService) return const Center(child: CircularProgressIndicator());
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
    final firestoreCount = <String, int>{
      for (final spell in _spells)
        spell.id: _firestoreTexts.where((t) => t.spellId == spell.id).length,
    };
    return SpellTextsPage(
      spells: _spells,
      service: _service!,
      promptHistory: _promptHistory!,
      firestoreCountBySpellId: firestoreCount,
      showExportButton: true,
      onExport: _showJsonDialog,
      onUploadToFirestore: _uploadAcceptedToFirestore,
    );
  }

  // ---------------------------------------------------------------------------
  // Sort + group helpers for DailyText lists
  // ---------------------------------------------------------------------------

  List<Object> _sortedItems(List<DailyText> texts, SpellSortBy sort) {
    final sorted = List<DailyText>.from(texts);
    switch (sort) {
      case SpellSortBy.levelThenName:
        sorted.sort((a, b) {
          final sa = _srdSpells[a.spellId];
          final sb = _srdSpells[b.spellId];
          if (sa == null && sb == null) return 0;
          if (sa == null) return 1;
          if (sb == null) return -1;
          final c = sa.level.compareTo(sb.level);
          return c != 0 ? c : sa.name.compareTo(sb.name);
        });
      case SpellSortBy.name:
        sorted.sort((a, b) {
          final na = _srdSpells[a.spellId]?.name ?? a.spellId;
          final nb = _srdSpells[b.spellId]?.name ?? b.spellId;
          return na.compareTo(nb);
        });
      case SpellSortBy.schoolThenName:
        sorted.sort((a, b) => a.spellId.compareTo(b.spellId));
    }
    if (sort != SpellSortBy.levelThenName) return sorted;

    // Interleave level headers
    final items = <Object>[];
    int? lastLevel;
    for (final text in sorted) {
      final spell = _srdSpells[text.spellId];
      final level = spell?.level;
      if (level != lastLevel) {
        items.add(spell?.levelLabel ?? 'Unknown');
        lastLevel = level;
      }
      items.add(text);
    }
    return items;
  }

  Widget _buildTextList({
    required List<DailyText> texts,
    required SpellSortBy sort,
    required Widget Function(DailyText, {required bool indented}) tileBuilder,
  }) {
    if (texts.isEmpty) return const SizedBox.shrink();
    final items = _sortedItems(texts, sort);
    final grouped = sort == SpellSortBy.levelThenName;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is String) return _LevelHeader(label: item);
        return tileBuilder(item as DailyText, indented: grouped);
      },
    );
  }

  Widget _buildStagingTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Text(
                'Pending upload',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 160,
                child: SpellSortDropdown(
                  value: _stagingSort,
                  onChanged: (v) => setState(() => _stagingSort = v),
                  options: const [SpellSortBy.levelThenName, SpellSortBy.name],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _importJson,
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Import JSON'),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Add manually',
                icon: const Icon(Icons.add),
                onPressed: () => _showDailyTextDialog(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _stagingTexts.isEmpty
              ? const Center(child: Text('No pending texts. Import JSON or add manually.'))
              : _buildTextList(
                  texts: _stagingTexts,
                  sort: _stagingSort,
                  tileBuilder: (text, {required bool indented}) => _DailyTextTile(
                    key: ValueKey(text.id),
                    text: text,
                    indented: indented,
                    onEdit: () => _showDailyTextDialog(context, existing: text),
                    onDelete: () => setState(
                        () => _stagingTexts.removeWhere((t) => t.id == text.id)),
                  ),
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: _stagingTexts.isEmpty
                    ? null
                    : () => _showJsonDialog(
                          jsonEncode(_stagingTexts.map((t) => t.toJson()).toList()),
                        ),
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Export JSON'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _stagingTexts.isEmpty ? null : _uploadStagingToFirestore,
                icon: const Icon(Icons.cloud_upload, size: 18),
                label: const Text('Upload all to Firestore'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFirestoreTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Text('Firestore', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 12),
              SizedBox(
                width: 160,
                child: SpellSortDropdown(
                  value: _firestoreSort,
                  onChanged: (v) => setState(() => _firestoreSort = v),
                  options: const [SpellSortBy.levelThenName, SpellSortBy.name],
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: _loadFirestore,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _loadingFirestore
              ? const Center(child: CircularProgressIndicator())
              : _firestoreTexts.isEmpty
                  ? const Center(child: Text('No texts on Firestore yet.'))
                  : _buildTextList(
                      texts: _firestoreTexts,
                      sort: _firestoreSort,
                      tileBuilder: (text, {required bool indented}) => _DailyTextTile(
                        key: ValueKey(text.id),
                        text: text,
                        indented: indented,
                        onEdit: () => _showDailyTextDialog(
                          context,
                          existing: text,
                          isFirestore: true,
                        ),
                        onDelete: () async {
                          await _repository.delete(text.id);
                          await _loadFirestore();
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared tile for DailyText items
// ---------------------------------------------------------------------------

class _LevelHeader extends StatelessWidget {
  final String label;
  const _LevelHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _DailyTextTile extends StatelessWidget {
  final DailyText text;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool indented;

  const _DailyTextTile({
    super.key,
    required this.text,
    required this.onEdit,
    required this.onDelete,
    this.indented = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: indented
          ? const EdgeInsets.only(left: 28, right: 8)
          : const EdgeInsets.symmetric(horizontal: 16),
      title: Text(text.subtitle),
      subtitle: Text('Spell ID: ${text.spellId}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: onDelete,
          ),
        ],
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
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
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

  const _SpellManagerDialog({required this.spells, required this.onSave});

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
    final picked = await SpellPickerDialog.show(context);
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
            // Primary action
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: _pickFromSrd,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Browse SRD spells'),
              ),
            ),
            // Collapsed manual add
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _showManual = !_showManual),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.outline,
                  textStyle: Theme.of(context).textTheme.bodySmall,
                ),
                child: Text(_showManual ? 'Hide manual add' : 'Add manually…'),
              ),
            ),
            if (_showManual) ...[
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _idCtrl,
                      decoration: const InputDecoration(labelText: 'ID'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: 'Description'),
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
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () => setState(() => _spells.removeAt(index)),
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
