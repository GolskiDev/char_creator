import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../features/spell_texts/controllers/preview_controller.dart';
import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/ui/atoms/spell_image.dart';
import '../../../features/spell_texts/ui/atoms/status_badge.dart';

class WebPreviewDialog extends StatefulWidget {
  final List<SpellTextResult> results;
  final int initialIndex;
  final Future<void> Function(String id) onAccept;
  final Future<void> Function(String id) onDismiss;

  const WebPreviewDialog({
    super.key,
    required this.results,
    required this.initialIndex,
    required this.onAccept,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required List<SpellTextResult> results,
    required int initialIndex,
    required Future<void> Function(String id) onAccept,
    required Future<void> Function(String id) onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => WebPreviewDialog(
        results: results,
        initialIndex: initialIndex,
        onAccept: onAccept,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<WebPreviewDialog> createState() => _WebPreviewDialogState();
}

class _WebPreviewDialogState extends State<WebPreviewDialog> {
  late final PreviewController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PreviewController(
      results: widget.results,
      initialIndex: widget.initialIndex,
      onAccept: widget.onAccept,
      onDismiss: widget.onDismiss,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _handleAccept();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete) {
      _handleDismiss();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowDown) {
      _ctrl.goNext();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowUp) {
      _ctrl.goPrev();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _handleAccept() async {
    final shouldClose = await _ctrl.accept();
    if (shouldClose && mounted) Navigator.of(context).pop();
  }

  Future<void> _handleDismiss() async {
    final shouldClose = await _ctrl.dismiss();
    if (shouldClose && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _ctrl,
      builder: (context, _) => _buildDialog(context),
    );
  }

  Widget _buildDialog(BuildContext context) {
    final result = _ctrl.current;
    final scheme = Theme.of(context).colorScheme;
    final screen = MediaQuery.of(context).size;

    final dialogHeight = screen.height * 0.88;
    final imageAreaHeight = (dialogHeight - 138).clamp(200.0, 9999.0);
    final imageCardWidth = imageAreaHeight * 2 / 3 + 24;
    const descPanelWidth = 420.0;

    final dialogWidth = PreviewController.showDescription
        ? imageCardWidth + descPanelWidth + 1
        : imageCardWidth;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Focus(
        autofocus: true,
        onKeyEvent: _handleKey,
        child: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: Column(
            children: [
              // Top navigation bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: _ctrl.canGoPrev ? _ctrl.goPrev : null,
                      tooltip: 'Previous  (←)',
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            result.spellTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${_ctrl.index + 1} / ${_ctrl.total}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed: _ctrl.canGoNext ? _ctrl.goNext : null,
                      tooltip: 'Next  (→)',
                    ),
                    IconButton(
                      icon: Icon(
                        PreviewController.showDescription
                            ? Icons.description
                            : Icons.description_outlined,
                        size: 20,
                      ),
                      tooltip: PreviewController.showDescription
                          ? 'Hide description'
                          : 'Show description',
                      onPressed: _ctrl.toggleDescription,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Image + optional description
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: imageCardWidth,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            SpellImage(spellId: result.spellId),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Card.filled(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      result.generatedText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: StatusBadge(
                                status: result.status,
                                style: StatusBadgeStyle.overlay,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (PreviewController.showDescription) ...[
                      const VerticalDivider(width: 1),
                      SizedBox(
                        width: descPanelWidth,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.spellTitle,
                                style:
                                    Theme.of(context).textTheme.titleSmall,
                              ),
                              if (result.spellDescription.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  result.spellDescription,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: scheme.onSurfaceVariant),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 1),
              // Pinned action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _ctrl.acting ? null : _handleDismiss,
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              _ctrl.acting ? null : scheme.error,
                          side: BorderSide(
                            color: _ctrl.acting
                                ? scheme.outline
                                : scheme.error,
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.close,
                                    size: 18,
                                    color: _ctrl.acting
                                        ? null
                                        : scheme.error),
                                const SizedBox(width: 6),
                                Text('Dismiss',
                                    style: TextStyle(
                                        color: _ctrl.acting
                                            ? null
                                            : scheme.error)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Backspace',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: (_ctrl.acting
                                            ? scheme.onSurface
                                            : scheme.error)
                                        .withValues(alpha: 0.55),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _ctrl.acting ? null : _handleAccept,
                        style: FilledButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 18),
                                SizedBox(width: 6),
                                Text('Accept'),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Enter',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: scheme.onPrimary
                                        .withValues(alpha: 0.65),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
