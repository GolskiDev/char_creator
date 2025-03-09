import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'open_5e.dart';
import 'open_5e_spell_model.dart';
import 'package:http/http.dart' as http;

final open5eSpellsRepositoryProvider = Provider<Open5eSpellsRepository>(
  (ref) {
    return Open5eSpellsRepository();
  },
);

final allSpellProvider = FutureProvider.autoDispose<List<Open5eSpellModelV1>>(
  (ref) async {
    final repository = ref.read(open5eSpellsRepositoryProvider);
    return repository.allSpells();
  },
);

final allSRDSpellsProvider =
    FutureProvider.autoDispose<List<Open5eSpellModelV1>>(
  (ref) async {
    final repository = ref.read(open5eSpellsRepositoryProvider);
    return repository.allSRDSpells();
  },
);

final allSRDCantripsProvider = FutureProvider<List<Open5eSpellModelV1>>(
  (ref) async {
    final repository = ref.read(open5eSpellsRepositoryProvider);
    return repository.allSRDCantrips();
  },
);

class Open5eSpellsRepository {
  Future<List<Open5eSpellModelV1>> allSpells({
    int limit = 50,
  }) async {
    final result = await http.get(
      Uri.parse('${Open5e.baseUrl}spells/?limit=$limit'),
    );

    final map = jsonDecode(result.body);

    return List<Open5eSpellModelV1>.from(
      map['results'].map(
        (element) => Open5eSpellModelV1.fromJson(element),
      ),
    );
  }

  Future<List<Open5eSpellModelV1>> allSRDSpells() async {
    final result = await http.get(
      Uri.parse('${Open5e.baseUrl}spells/?document__slug=wotc-srd'),
    );

    final map = jsonDecode(result.body);

    return List<Open5eSpellModelV1>.from(
      map['results'].map(
        (element) => Open5eSpellModelV1.fromJson(element),
      ),
    );
  }

  Future<List<Open5eSpellModelV1>> allSRDCantrips() async {
    final result = await http.get(
      Uri.parse('${Open5e.baseUrl}spells/?document__slug=wotc-srd&level_int=0'),
    );

    final map = jsonDecode(result.body);

    return List<Open5eSpellModelV1>.from(
      map['results'].map(
        (element) => Open5eSpellModelV1.fromJson(element),
      ),
    );
  }
}
