import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../features/spell_texts/controllers/preview_controller.dart';
import '../../../features/spell_texts/models/spell_text_result.dart';
import '../../../features/spell_texts/ui/atoms/spell_image.dart';
import '../../../features/spell_texts/ui/atoms/status_badge.dart';

/// Full-screen preview page for mobile.
/// Swipe left/right to navigate, large buttons for accept/dismiss.
class MobilePreviewPage extends StatefulWidget {
  final List<SpellTextResult> results;
  final int initialIndex;
  final Future<void> Function(String id) onAccept;
  final Future<void> Function(String id) onDismiss;

  const MobilePreviewPage({
    super.key,
    required this.results,
    required this.initialIndex,
    required this.onAccept,
    required this.onDismiss,
  });

  static Future<void> push(
    BuildContext context, {
    required List<SpellTextResult> results,
    required int initialIndex,
    required Future<void> Function(String id) onAccept,
    required Future<void> Function(String id) onDismiss,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MobilePreviewPage(
          results: results,
          initialIndex: initialIndex,
          onAccept: onAccept,
          onDismiss: onDismiss,
        ),
      ),
    );
  }

  @override
  State<MobilePreviewPage> createState() => _MobilePreviewPageState();
}

class _MobilePreviewPageState extends State<MobilePreviewPage> {
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
    return KeyEventResult.ignored;
  }

  Future<void> _handleAccept() async {
    HapticFeedback.lightImpact();
    final shouldClose = await _ctrl.accept();
    if (shouldClose && mounted) Navigator.of(context).pop();
  }

  Future<void> _handleDismiss() async {
    HapticFeedback.lightImpact();
    final shouldClose = await _ctrl.dismiss();
    if (shouldClose && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _ctrl,
      builder: (context, _) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final result = _ctrl.current;
    final scheme = Theme.of(context).colorScheme;

    return Focus(
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${_ctrl.index + 1} / ${_ctrl.total}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: _ctrl.canGoPrev ? _ctrl.goPrev : null,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              onPressed: _ctrl.canGoNext ? _ctrl.goNext : null,
            ),
            IconButton(
              icon: Icon(
                PreviewController.showDescription
                    ? Icons.description
                    : Icons.description_outlined,
              ),
              onPressed: _ctrl.toggleDescription,
            ),
          ],
        ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity;
            if (velocity == null) return;
            if (velocity < -300) _ctrl.goNext();
            if (velocity > 300) _ctrl.goPrev();
          },
          child: Column(
            children: [
              // Image area fills available space
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SpellImage(spellId: result.spellId),
                    // Generated text overlay at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Card.filled(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              result.generatedText,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontStyle: FontStyle.italic),
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
              // Description panel (togglable)
              if (PreviewController.showDescription)
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    border: Border(
                        top: BorderSide(color: scheme.outlineVariant)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.spellTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (result.spellDescription.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            result.spellDescription,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              // Action buttons
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  12 + MediaQuery.of(context).padding.bottom,
                ),
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
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, size: 20),
                            SizedBox(width: 8),
                            Text('Dismiss'),
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
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 20),
                            SizedBox(width: 8),
                            Text('Accept'),
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
