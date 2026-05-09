import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/firestore_controller.dart';
import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/controllers/staging_controller.dart';
import '../../../features/spell_texts/models/spell.dart';
import '../../../features/spell_texts/services/llm_provider.dart';
import 'web_generate_tab.dart';
import 'web_firestore_tab.dart';
import 'web_snippet_manager_dialog.dart';
import 'web_spell_picker_dialog.dart';
import 'web_staging_tab.dart';

class WebSpellTextsPage extends StatefulWidget {
  const WebSpellTextsPage({super.key});

  @override
  State<WebSpellTextsPage> createState() => _WebSpellTextsPageState();
}

class _WebSpellTextsPageState extends State<WebSpellTextsPage> {
  late final SpellTextsController _ctrl;
  late final StagingController _staging;
  late final FirestoreController _firestore;

  @override
  void initState() {
    super.initState();
    _ctrl = SpellTextsController();
    _staging = StagingController(_ctrl);
    _firestore = FirestoreController(_ctrl);
    _ctrl.init();
    _staging.init();
    _firestore.init();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _staging.dispose();
    _firestore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _ctrl,
      builder: (context, _) => _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_ctrl.loadingService) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_ctrl.error != null) {
      return Center(child: Text('Error: ${_ctrl.error}'));
    }

    if (_ctrl.apiKey.isEmpty && _ctrl.provider != LlmProvider.ollama) {
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

    final pendingCount = _ctrl.pendingCount;
    final readyToPush = _ctrl.readyToPush;

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
                _buildGenerateWrapper(),
                WebStagingTab(staging: _staging, parent: _ctrl),
                WebFirestoreTab(firestore: _firestore, parent: _ctrl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateWrapper() {
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
                label: Text('Spells (${_ctrl.spells.length})'),
              ),
              const SizedBox(width: 4),
              if (_ctrl.snippetService != null)
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
        if (_ctrl.spells.isEmpty)
          Expanded(
            child: Center(
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
            ),
          )
        else
          Expanded(child: WebGenerateTab(ctrl: _ctrl)),
      ],
    );
  }

  void _openSettings() {
    showDialog<void>(
      context: context,
      builder: (_) => _LlmConfigDialog(
        provider: _ctrl.provider,
        apiKey: _ctrl.apiKey,
        model: _ctrl.model,
        baseUrl: _ctrl.baseUrl,
        onSave: ({required provider, required apiKey, required model, required baseUrl}) =>
            _ctrl.saveConfig(
              newProvider: provider,
              newApiKey: apiKey,
              newModel: model,
              newBaseUrl: baseUrl,
            ),
      ),
    );
  }

  void _openSpellManager() {
    showDialog<void>(
      context: context,
      builder: (_) => _SpellManagerDialog(
        spells: _ctrl.spells,
        onSave: _ctrl.saveSpells,
        firestoreCount: _ctrl.firestoreCountBySpellId,
      ),
    );
  }

  void _openSnippetManager() {
    if (_ctrl.snippetService == null) return;
    SnippetManagerDialog.show(context, _ctrl.snippetService!);
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
        if (!_spells.any((s) => s.id == spell.id)) _spells.add(spell);
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
                  foregroundColor: Theme.of(context).colorScheme.outline,
                  textStyle: Theme.of(context).textTheme.bodySmall,
                ),
                child:
                    Text(_showManual ? 'Hide manual add' : 'Add manually…'),
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
