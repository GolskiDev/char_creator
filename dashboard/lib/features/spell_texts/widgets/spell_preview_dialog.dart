import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';

class SpellPreviewDialog extends StatefulWidget {
  final List<SpellTextResult> results;
  final int initialIndex;
  final Future<void> Function(String id) onAccept;
  final Future<void> Function(String id) onDismiss;

  const SpellPreviewDialog({
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
      builder: (_) => SpellPreviewDialog(
        results: results,
        initialIndex: initialIndex,
        onAccept: onAccept,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<SpellPreviewDialog> createState() => _SpellPreviewDialogState();
}

class _SpellPreviewDialogState extends State<SpellPreviewDialog> {
  late int _index;
  bool _acting = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.results.length - 1);
  }

  SpellTextResult get _current => widget.results[_index];

  String get _imageAssetPath {
    final slug = _current.spellId.replaceAll('-', '_');
    return 'packages/spells_and_tools/assets/images/spells/$slug.webp';
  }

  void _goNext() {
    if (_index < widget.results.length - 1) {
      setState(() => _index++);
    }
  }

  void _goPrev() {
    if (_index > 0) {
      setState(() => _index--);
    }
  }

  Future<void> _accept() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      await widget.onAccept(_current.id);
    } finally {
      if (mounted) {
        if (_index < widget.results.length - 1) {
          setState(() {
            _index++;
            _acting = false;
          });
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _dismiss() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      await widget.onDismiss(_current.id);
    } finally {
      if (mounted) {
        if (_index < widget.results.length - 1) {
          setState(() {
            _index++;
            _acting = false;
          });
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _accept();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete) {
      _dismiss();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowDown) {
      _goNext();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowUp) {
      _goPrev();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final result = _current;
    final scheme = Theme.of(context).colorScheme;
    final total = widget.results.length;

    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Focus(
        autofocus: true,
        onKeyEvent: _handleKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top navigation bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: _index > 0 ? _goPrev : null,
                      tooltip: 'Previous',
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
                            '${_index + 1} / $total',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed:
                          _index < total - 1 ? _goNext : null,
                      tooltip: 'Next',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Spell image card (portrait aspect ratio, mirroring
                // DailyMessagesSpellsWidget from the main app)
                AspectRatio(
                  aspectRatio: 0.65,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.zero,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _imageAssetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.auto_fix_high,
                              size: 64,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
                        // Status chip overlay
                        Positioned(
                          top: 8,
                          right: 8,
                          child: _StatusBadge(status: result.status),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Spell description
                if (result.spellDescription.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      result.spellDescription,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                const SizedBox(height: 12),
                // Accept / Dismiss buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _acting ? null : _dismiss,
                        icon: Icon(Icons.close,
                            color: _acting ? null : scheme.error),
                        label: Text(
                          'Dismiss',
                          style: TextStyle(
                              color: _acting ? null : scheme.error),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _acting
                                ? scheme.outline
                                : scheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _acting ? null : _accept,
                        icon: const Icon(Icons.check),
                        label: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Keyboard hint
                Text(
                  '← → navigate  •  Enter accept  •  Backspace dismiss  •  Esc close',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final SpellTextStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      SpellTextStatus.pending => ('Pending', Colors.orange),
      SpellTextStatus.accepted => ('Accepted', Colors.green),
      SpellTextStatus.dismissed => ('Dismissed', Colors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
