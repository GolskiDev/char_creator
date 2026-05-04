import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/spell.dart';
import 'models/spells_config.dart';
import 'services/llm_provider.dart';
import 'services/prompt_history_service.dart';
import 'services/spell_storage_service.dart';
import 'services/spell_text_service.dart';
import 'widgets/spell_texts_page.dart';

/// Hosts the spell text generation feature inside the admin panel.
/// Manages LLM config (persisted in SharedPreferences) and the spell list.
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

  SpellTextService? _service;
  PromptHistoryService? _promptHistory;
  List<Spell> _spells = [];
  bool _loading = true;
  String? _error;

  // Current LLM config
  LlmProvider _provider = LlmProvider.anthropic;
  String _apiKey = '';
  String _model = 'claude-haiku-4-5-20251001';
  String _baseUrl = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _provider = LlmProvider.values.byName(
        prefs.getString(_keyProvider) ?? LlmProvider.anthropic.name,
      );
      _apiKey = prefs.getString(_keyApiKey) ?? '';
      _model = prefs.getString(_keyModel) ?? 'claude-haiku-4-5-20251001';
      _baseUrl = prefs.getString(_keyBaseUrl) ?? '';

      // Load persisted spells (stored as "id|title|description" lines).
      final rawSpells = prefs.getStringList(_keySpells) ?? [];
      _spells = rawSpells.map(_spellFromRaw).whereType<Spell>().toList();

      await _buildServices();
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _buildServices() async {
    if (_apiKey.isEmpty && _provider != LlmProvider.ollama) {
      if (mounted) setState(() { _loading = false; });
      return;
    }
    final config = SpellsConfig(
      provider: _provider,
      apiKey: _apiKey,
      model: _model,
      baseUrl: _baseUrl.isEmpty ? null : _baseUrl,
    );
    final storage = SpellStorageService();
    final history = PromptHistoryService();
    final service = SpellTextService(config: config, storage: storage);
    await service.init();
    await history.init();
    if (mounted) {
      setState(() {
        _service = service;
        _promptHistory = history;
        _loading = false;
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
      _loading = true;
    });
    await _buildServices();
  }

  Future<void> _saveSpells(List<Spell> spells) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keySpells,
      spells.map(_spellToRaw).toList(),
    );
    setState(() => _spells = spells);
  }

  static String _spellToRaw(Spell s) => '${s.id}|${s.title}|${s.description}';

  static Spell? _spellFromRaw(String raw) {
    final parts = raw.split('|');
    if (parts.length < 3) return null;
    return Spell(
      id: parts[0],
      title: parts[1],
      description: parts.sublist(2).join('|'),
    );
  }

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
      builder: (_) => _SpellManagerDialog(
        spells: _spells,
        onSave: _saveSpells,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Toolbar(
          onSettings: _openSettings,
          onManageSpells: _openSpellManager,
          spellCount: _spells.length,
        ),
        const Divider(height: 1),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
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
    return SpellTextsPage(
      spells: _spells,
      service: _service!,
      promptHistory: _promptHistory!,
      showExportButton: true,
      onExport: _handleExport,
    );
  }

  void _handleExport(String json) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Exported JSON'),
        content: SingleChildScrollView(
          child: SelectableText(json),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Toolbar
// ---------------------------------------------------------------------------

class _Toolbar extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onManageSpells;
  final int spellCount;

  const _Toolbar({
    required this.onSettings,
    required this.onManageSpells,
    required this.spellCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(
            'Spell Texts',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onManageSpells,
            icon: const Icon(Icons.list, size: 18),
            label: Text('Spells ($spellCount)'),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'LLM settings',
            icon: const Icon(Icons.settings),
            onPressed: onSettings,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Spells'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add form
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
            const SizedBox(height: 8),
            // List
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
