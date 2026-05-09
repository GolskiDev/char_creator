import 'package:flutter/material.dart';

import '../../../features/spell_texts/controllers/firestore_controller.dart';
import '../../../features/spell_texts/controllers/spell_texts_controller.dart';
import '../../../features/spell_texts/controllers/staging_controller.dart';
import '../../../features/spell_texts/services/llm_provider.dart';
import '../../web/spell_texts/web_spell_texts_page.dart' show LlmConfigDialog;
import 'mobile_firestore_page.dart';
import 'mobile_generate_page.dart';
import 'mobile_staging_page.dart';

class MobileSpellTextsPage extends StatefulWidget {
  const MobileSpellTextsPage({super.key});

  @override
  State<MobileSpellTextsPage> createState() => _MobileSpellTextsPageState();
}

class _MobileSpellTextsPageState extends State<MobileSpellTextsPage> {
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

  void _openSettings() {
    showDialog<void>(
      context: context,
      builder: (_) => LlmConfigDialog(
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
                    if (_ctrl.pendingCount > 0) ...[
                      const SizedBox(width: 4),
                      _Badge(count: _ctrl.pendingCount),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Firestore'),
                    if (_ctrl.readyToPush.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      _Badge(
                        count: _ctrl.readyToPush.length,
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
                MobileGeneratePage(ctrl: _ctrl, onOpenSettings: _openSettings),
                MobileStagingPage(staging: _staging, parent: _ctrl),
                MobileFirestorePage(firestore: _firestore, parent: _ctrl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final Color? color;

  const _Badge({required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color ?? scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 10,
          color: color != null ? Colors.white : scheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
