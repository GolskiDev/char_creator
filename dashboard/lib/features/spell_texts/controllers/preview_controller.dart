import 'package:flutter/foundation.dart';

import '../models/spell_text_result.dart';

class PreviewController extends ChangeNotifier {
  final List<SpellTextResult> results;
  final Future<void> Function(String id) onAccept;
  final Future<void> Function(String id) onDismiss;

  int _index;
  bool acting = false;

  // Session-persistent toggle — shared across all preview instances.
  static bool showDescription = false;

  PreviewController({
    required this.results,
    required int initialIndex,
    required this.onAccept,
    required this.onDismiss,
  }) : _index = initialIndex.clamp(0, results.isEmpty ? 0 : results.length - 1);

  SpellTextResult get current => results[_index];
  int get index => _index;
  int get total => results.length;
  bool get canGoPrev => _index > 0;
  bool get canGoNext => _index < results.length - 1;

  void goNext() {
    if (canGoNext) {
      _index++;
      notifyListeners();
    }
  }

  void goPrev() {
    if (canGoPrev) {
      _index--;
      notifyListeners();
    }
  }

  void toggleDescription() {
    showDescription = !showDescription;
    notifyListeners();
  }

  /// Returns true if the caller should close the dialog (last item processed).
  Future<bool> accept() async {
    if (acting) return false;
    acting = true;
    notifyListeners();
    try {
      await onAccept(current.id);
    } catch (_) {
      acting = false;
      notifyListeners();
      rethrow;
    }
    if (canGoNext) {
      _index++;
      acting = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Returns true if the caller should close the dialog (last item processed).
  Future<bool> dismiss() async {
    if (acting) return false;
    acting = true;
    notifyListeners();
    try {
      await onDismiss(current.id);
    } catch (_) {
      acting = false;
      notifyListeners();
      rethrow;
    }
    if (canGoNext) {
      _index++;
      acting = false;
      notifyListeners();
      return false;
    }
    return true;
  }
}
