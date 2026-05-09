import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../models/daily_text.dart';
import '../models/spell.dart';
import '../models/spell_text_result.dart';
import '../models/spell_text_status.dart';
import '../services/srd_loader.dart';
import '../ui/atoms/spell_sort_dropdown.dart';
import 'spell_texts_controller.dart';

class StagingController extends ChangeNotifier {
  final SpellTextsController parent;

  StagingController(this.parent);

  final Set<String> filterSpellIds = {};
  final Set<SpellTextStatus> visibleStatuses = {
    SpellTextStatus.pending,
    SpellTextStatus.accepted,
    SpellTextStatus.dismissed,
  };
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

  List<SpellTextResult> get filteredResults {
    final svc = parent.service;
    if (svc == null) return [];
    return svc.results.where((r) {
      if (filterSpellIds.isNotEmpty && !filterSpellIds.contains(r.spellId)) {
        return false;
      }
      return visibleStatuses.contains(r.status);
    }).toList();
  }

  List<Object> sortedItems(List<SpellTextResult> results) {
    final sorted = List<SpellTextResult>.from(results);
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
        sorted.sort((a, b) => a.spellTitle.compareTo(b.spellTitle));
      case SpellSortBy.schoolThenName:
        sorted.sort((a, b) {
          final sa = srdSpells[a.spellId]?.school ?? '';
          final sb = srdSpells[b.spellId]?.school ?? '';
          final c = sa.compareTo(sb);
          return c != 0 ? c : a.spellTitle.compareTo(b.spellTitle);
        });
    }

    if (sort != SpellSortBy.levelThenName) return sorted;

    final items = <Object>[];
    int? lastLevel;
    for (final r in sorted) {
      final spell = srdSpells[r.spellId];
      final level = spell?.level;
      if (level != lastLevel) {
        items.add(spell?.levelLabel ?? 'Unknown');
        lastLevel = level;
      }
      items.add(r);
    }
    return items;
  }

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------

  void toggleSpellFilter(String id) {
    if (filterSpellIds.contains(id)) {
      filterSpellIds.remove(id);
    } else {
      filterSpellIds.add(id);
    }
    notifyListeners();
  }

  void toggleStatus(SpellTextStatus status) {
    if (visibleStatuses.contains(status)) {
      visibleStatuses.remove(status);
    } else {
      visibleStatuses.add(status);
    }
    notifyListeners();
  }

  void setSortBy(SpellSortBy value) {
    sort = value;
    notifyListeners();
  }

  Future<void> accept(String id) async {
    final svc = parent.service;
    if (svc == null) return;
    await svc.accept(id);
    parent.notifyListeners();
  }

  Future<void> dismiss(String id) async {
    final svc = parent.service;
    if (svc == null) return;
    await svc.dismiss(id);
    parent.notifyListeners();
  }

  /// Imports results from a JSON file. Returns ({added, skipped}).
  Future<({int added, int skipped})> importFromFile(
      List<Spell> spells) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final bytes = picked?.files.single.bytes;
    if (picked == null || bytes == null) {
      return (added: 0, skipped: 0);
    }

    final jsonString = utf8.decode(bytes);
    late final List<dynamic> jsonList;
    try {
      jsonList = json.decode(jsonString) as List<dynamic>;
    } catch (_) {
      return (added: -1, skipped: 0); // -1 signals parse error
    }

    final spellMap = {for (final s in spells) s.id: s};
    final incoming = jsonList.map((e) {
      final dt = DailyText.fromJson(e as Map<String, dynamic>);
      final spell = spellMap[dt.spellId];
      return SpellTextResult(
        id: dt.id,
        spellId: dt.spellId,
        spellTitle: spell?.title ?? dt.spellId,
        spellDescription: spell?.description ?? '',
        generatedText: dt.subtitle,
        createdAt: DateTime.now(),
        status: SpellTextStatus.accepted,
      );
    }).toList();

    final svc = parent.service;
    if (svc == null) return (added: 0, skipped: 0);
    final skipped = await svc.importResults(incoming);
    parent.notifyListeners();
    notifyListeners();
    return (added: incoming.length - skipped, skipped: skipped);
  }
}
