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

  // Persists for the lifetime of the app session (static).
  static bool _showDescription = false;

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
    final screen = MediaQuery.of(context).size;

    // Compute dialog dimensions so the image always fills the height at its
    // natural 2:3 portrait ratio and the dialog shrinks when desc is hidden.
    //
    // Fixed UI chrome heights (nav bar + dividers + button row):  ~138 px
    final dialogHeight = screen.height * 0.88;
    final imageAreaHeight = (dialogHeight - 138).clamp(200.0, 9999.0);
    final imageCardWidth = imageAreaHeight * 2 / 3 + 24; // +24 for Card margin

    // Description panel: ~65 ch at bodySmall (≈ 12 sp × 6.5 px/ch ≈ 420 px)
    // This is the typographic "measure" — the ideal line length for reading.
    const descPanelWidth = 420.0;

    final dialogWidth = _showDescription
        ? imageCardWidth + descPanelWidth + 1 // 1 = VerticalDivider
        : imageCardWidth;

    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Focus(
        autofocus: true,
        onKeyEvent: _handleKey,
        child: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: Column(
            children: [
              // ── Top navigation bar ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: _index > 0 ? _goPrev : null,
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
                            '${_index + 1} / $total',
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
                      onPressed: _index < total - 1 ? _goNext : null,
                      tooltip: 'Next  (→)',
                    ),
                    IconButton(
                      icon: Icon(
                        _showDescription
                            ? Icons.description
                            : Icons.description_outlined,
                        size: 20,
                      ),
                      tooltip: _showDescription
                          ? 'Hide description'
                          : 'Show description',
                      onPressed: () =>
                          setState(() => _showDescription = !_showDescription),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // ── Main content: image left | info right ───────────
              // LayoutBuilder lets us derive the image width from the
              // available height so the portrait aspect ratio (2:3) is
              // always preserved without cropping.
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left column: image at 2:3 portrait ratio, fills height
                    SizedBox(
                      width: imageCardWidth,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(12),
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
                            // Generated text overlay at bottom
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
                              child: _StatusBadge(status: result.status),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right column: spell description (togglable)
                    if (_showDescription) ...[
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
              // ── Pinned action buttons ────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _acting ? null : _dismiss,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _acting ? null : scheme.error,
                          side: BorderSide(
                            color:
                                _acting ? scheme.outline : scheme.error,
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
                                    color: _acting ? null : scheme.error),
                                const SizedBox(width: 6),
                                Text('Dismiss',
                                    style: TextStyle(
                                        color: _acting
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
                                    color: (_acting
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
                        onPressed: _acting ? null : _accept,
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
