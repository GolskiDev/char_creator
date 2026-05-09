import 'package:flutter/foundation.dart';

import '../models/daily_text.dart';
import '../models/spell_text_result.dart';
import '../services/srd_loader.dart';
import '../ui/atoms/spell_sort_dropdown.dart';
import 'spell_texts_controller.dart';

enum FirestoreSourceFilter { firestoreItems, readyToPush }

class FirestoreController extends ChangeNotifier {
  final SpellTextsController parent;

  FirestoreController(this.parent);

  Set<FirestoreSourceFilter> sourceFilter = {
    FirestoreSourceFilter.firestoreItems,
    FirestoreSourceFilter.readyToPush,
  };
  Set<String> filterSpellIds = {};
  SpellSortBy sort = SpellSortBy.levelThenName;
  Map<String, SrdSpell> srdSpells = {};

  // ---------------------------------------------------------------------------
  // Init
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    final loaded = await SrdLoader.loadSpells();
    srdSpells = {for (final s in loaded) s.id: s};
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Computed
  // ---------------------------------------------------------------------------

  Set<String> get allSpellIds => {
        ...parent.firestoreTexts.map((t) => t.spellId),
        ...parent.readyToPush.map((r) => r.spellId),
      };

  List<DailyText> get filteredFirestore {
    if (!sourceFilter.contains(FirestoreSourceFilter.firestoreItems)) return [];
    return parent.firestoreTexts.where((t) {
      if (filterSpellIds.isNotEmpty && !filterSpellIds.contains(t.spellId)) {
        return false;
      }
      return true;
    }).toList();
  }

  List<SpellTextResult> get filteredReady {
    if (!sourceFilter.contains(FirestoreSourceFilter.readyToPush)) return [];
    return parent.readyToPush.where((r) {
      if (filterSpellIds.isNotEmpty && !filterSpellIds.contains(r.spellId)) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Object> sortedFirestoreItems(List<DailyText> texts) {
    final sorted = List<DailyText>.from(texts);
    switch (sort) {
      case SpellSortBy.levelThenName:
        sorted.sort((a, b) {
          final sa = srdSpells[a.spellId];
          final sb = srdSpells[b.spellId];
          if (sa == null && sb == null) return 0;
          if (sa == null) return 1;
          if (sb == null) return -1;
          final c = sa.level.compareTo(sb.level);
          return c != 0 ? c : sa.name.compareTo(sb.name);
        });
      case SpellSortBy.name:
        sorted.sort((a, b) {
          final na = srdSpells[a.spellId]?.name ?? a.spellId;
          final nb = srdSpells[b.spellId]?.name ?? b.spellId;
          return na.compareTo(nb);
        });
      case SpellSortBy.schoolThenName:
        sorted.sort((a, b) => a.spellId.compareTo(b.spellId));
    }

    if (sort != SpellSortBy.levelThenName) return sorted;

    final items = <Object>[];
    int? lastLevel;
    for (final text in sorted) {
      final spell = srdSpells[text.spellId];
      final level = spell?.level;
      if (level != lastLevel) {
        items.add(spell?.levelLabel ?? 'Unknown');
        lastLevel = level;
      }
      items.add(text);
    }
    return items;
  }

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------

  void toggleSourceFilter(FirestoreSourceFilter f) {
    if (sourceFilter.contains(f)) {
      sourceFilter.remove(f);
    } else {
      sourceFilter.add(f);
    }
    notifyListeners();
  }

  void toggleSpellFilter(String id) {
    if (filterSpellIds.contains(id)) {
      filterSpellIds.remove(id);
    } else {
      filterSpellIds.add(id);
    }
    notifyListeners();
  }

  void setSortBy(SpellSortBy value) {
    sort = value;
    notifyListeners();
  }
}
