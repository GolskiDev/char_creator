import 'package:flutter/material.dart';

import '../services/spell_text_service.dart';
import 'spell_text_card.dart';

class SpellTextsListView extends StatefulWidget {
  final SpellTextService service;

  /// When true, shows an export button in the app bar area.
  final bool showExportButton;

  /// Called with the JSON string of all accepted results when the export button is tapped.
  final void Function(String json)? onExport;

  const SpellTextsListView({
    super.key,
    required this.service,
    this.showExportButton = false,
    this.onExport,
  });

  @override
  State<SpellTextsListView> createState() => _SpellTextsListViewState();
}

class _SpellTextsListViewState extends State<SpellTextsListView> {
  @override
  Widget build(BuildContext context) {
    final results = widget.service.results;

    return Column(
      children: [
        if (widget.showExportButton)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    final json = widget.service.exportAcceptedToJson();
                    widget.onExport?.call(json);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export accepted'),
                ),
              ],
            ),
          ),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('No generated texts yet.'))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return SpellTextCard(
                      key: ValueKey(result.id),
                      result: result,
                      onAccept: () async {
                        await widget.service.accept(result.id);
                        setState(() {});
                      },
                      onDismiss: () async {
                        await widget.service.dismiss(result.id);
                        setState(() {});
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
