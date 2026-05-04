import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'daily_text_model.dart';
import 'daily_texts_repository.dart';

class DailyTextsListPage extends StatefulWidget {
  const DailyTextsListPage({Key? key}) : super(key: key);

  @override
  State<DailyTextsListPage> createState() => _DailyTextsListPageState();
}

class _DailyTextsListPageState extends State<DailyTextsListPage> {
  final DailyTextsRepository _repository = DailyTextsRepository();
  List<DailyText> _serverDailyTexts = [];
  List<DailyText> _inMemoryDailyTexts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDailyTexts();
  }

  Future<void> _loadDailyTexts() async {
    setState(() => _loading = true);
    final serverDailyTexts = await _repository.fetchDailyTexts();
    setState(() {
      _serverDailyTexts = serverDailyTexts;
      _loading = false;
    });
  }

  void _addInMemoryDailyTexts(List<DailyText> newDailyTexts) {
    setState(() {
      _inMemoryDailyTexts.addAll(newDailyTexts);
    });
  }

  Future<void> _pickJsonAndAdd() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null && result.files.single.bytes != null) {
      final jsonString = utf8.decode(result.files.single.bytes!);
      final List<dynamic> jsonList = json.decode(jsonString);
      final newDailyTexts = jsonList.map((e) => DailyText.fromJson(e)).toList();
      _addInMemoryDailyTexts(newDailyTexts.cast<DailyText>());
    }
  }

  Widget _buildEditableTile(DailyText dailyText, bool isServer) {
    final color = isServer
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.secondaryContainer;
    return Card(
      color: color,
      child: ListTile(
        title: Text(
          dailyText.subtitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('Spell ID: ${dailyText.spellId}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () => _showAddDailyTextDialog(
                context,
                existing: dailyText,
                isServer: isServer,
              ),
            ),
            if (!isServer)
              ElevatedButton(
                onPressed: () async {
                  await _repository.addDailyText(dailyText);
                  setState(() {
                    _inMemoryDailyTexts.removeWhere(
                      (d) => d.id == dailyText.id,
                    );
                  });
                  _loadDailyTexts();
                },
                child: const Text('Upload'),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddDailyTextDialog(
    BuildContext context, {
    DailyText? existing,
    bool isServer = false,
  }) {
    final _idController = TextEditingController(text: existing?.id ?? '');
    final _spellIdController = TextEditingController(
      text: existing?.spellId ?? '',
    );
    final _subtitleController = TextEditingController(
      text: existing?.subtitle ?? '',
    );

    String _generateRandomId() {
      // Generates a simple random alphanumeric string
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      return List.generate(
        12,
        (index) =>
            chars[(DateTime.now().millisecondsSinceEpoch + index * 997) %
                chars.length],
      ).join();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Add Daily Text' : 'Edit Daily Text'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _idController,
                        decoration: const InputDecoration(labelText: 'ID'),
                        enabled: existing == null,
                      ),
                    ),
                    if (existing == null)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Generate random ID',
                        onPressed: () {
                          _idController.text = _generateRandomId();
                        },
                      ),
                  ],
                ),
                TextField(
                  controller: _spellIdController,
                  decoration: const InputDecoration(labelText: 'Spell ID'),
                ),
                TextField(
                  controller: _subtitleController,
                  decoration: const InputDecoration(labelText: 'Subtitle'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedDailyText = DailyText(
                  id: _idController.text.trim(),
                  spellId: _spellIdController.text.trim(),
                  subtitle: _subtitleController.text.trim(),
                );
                setState(() {
                  if (existing == null) {
                    _addInMemoryDailyTexts([updatedDailyText]);
                  } else if (isServer) {
                    // Update server item
                    _repository.updateDailyText(updatedDailyText);
                    final idx = _serverDailyTexts.indexWhere(
                      (d) => d.id == updatedDailyText.id,
                    );
                    if (idx != -1) _serverDailyTexts[idx] = updatedDailyText;
                  } else {
                    // Update in-memory item
                    final idx = _inMemoryDailyTexts.indexWhere(
                      (d) => d.id == updatedDailyText.id,
                    );
                    if (idx != -1) _inMemoryDailyTexts[idx] = updatedDailyText;
                  }
                });
                Navigator.of(context).pop();
                if (isServer && existing != null) _loadDailyTexts();
              },
              child: Text(existing == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Texts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _pickJsonAndAdd,
            tooltip: 'Add from JSON',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ..._inMemoryDailyTexts.map((d) => _buildEditableTile(d, false)),
                ..._serverDailyTexts.map((d) => _buildEditableTile(d, true)),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDailyTextDialog(context),
        tooltip: 'Add Daily Text',
        child: const Icon(Icons.add),
      ),
    );
  }
}
