import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'open_5e.dart';

final open5eCollectionRemoteDataSourceProvider = Provider(
  (ref) => Open5eCollectionRemoteDataSource(),
);

enum RulesItems {
  magicItems,
  conditions,
  classes,
  races,
  monsters,
  armors,
  weapons,
}

class Open5eCollectionRemoteDataSource {
  final String? url = Open5e.baseUrl;
  final String filter = '?document__slug=wotc-srd';

  Future<List<T>> fetchCollection<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    List<T> items = [];
    String? nextUrl = '$url$endpoint$filter';

    while (nextUrl != null) {
      final result = await http.get(Uri.parse(nextUrl));
      final map = jsonDecode(result.body);

      items.addAll(
        List<T>.from(
          map['results'].map((element) => fromJson(element)),
        ),
      );

      nextUrl = map['next'];
    }

    return items;
  }
}
