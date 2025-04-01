import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'open_5e.dart';
import 'open_5e_spell_model.dart';

final open5eSpellsRemoteDataSourceProvider = Provider(
  (ref) => Open5eSpellsRemoteDataSource(),
);

class Open5eSpellsRemoteDataSource {
  final String? url = '${Open5e.baseUrl}spells/?document__slug=wotc-srd';

  Future<List<Open5eSpellModelV1>> fetchSpells() async {
    List<Open5eSpellModelV1> spells = [];
    String? nextUrl = url;

    while (nextUrl != null) {
      final result = await http.get(Uri.parse(nextUrl));
      final map = jsonDecode(result.body);

      spells.addAll(
        List<Open5eSpellModelV1>.from(
          map['results'].map(
            (element) => Open5eSpellModelV1.fromJson(element),
          ),
        ),
      );

      nextUrl = map['next'];
    }

    return spells;
  }
}
