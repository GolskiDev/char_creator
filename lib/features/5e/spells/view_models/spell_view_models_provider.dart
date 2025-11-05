import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../user_spells_repository.dart/user_spells_repository.dart';
import 'spell_view_model.dart';

final spellViewModelsProvider = FutureProvider<List<SpellViewModel>>(
  (ref) async {
    final srdSpells = ref.watch(srdSpellViewModelsProvider.future);
    final userSpells = ref.watch(userSpellViewModelsProvider.future);
    final futures = [
      srdSpells,
      userSpells,
    ];
    final results = await Future.wait(futures);
    final allSpells = results.expand((list) => list).toList();
    return allSpells;
  },
);
