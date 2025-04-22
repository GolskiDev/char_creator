import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod/riverpod.dart';

final open5eCollectionLocalCacheProvider = Provider(
  (ref) => Open5eCollectionLocalCache(),
);

class Open5eCollectionLocalCache {
  static const String cacheKeyPrefix = 'collection_cache_';

  Future<List<T>?> getCollectionCache<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cacheKey = '$cacheKeyPrefix$endpoint';
    final cacheFile = await DefaultCacheManager().getFileFromCache(cacheKey);

    if (cacheFile == null) {
      return null;
    }

    final cacheData = await cacheFile.file.readAsString();
    final List<dynamic> cacheJson = jsonDecode(cacheData);
    return cacheJson.map((item) => fromJson(item)).toList();
  }

  Future<void> setCollectionCache<T>(
    String endpoint,
    List<T> items,
  ) async {
    final cacheKey = '$cacheKeyPrefix$endpoint';
    final cacheJson =
        jsonEncode(items.map((item) => (item as dynamic).toJson()).toList());
    await DefaultCacheManager().putFile(
      cacheKey,
      utf8.encode(cacheJson),
      fileExtension: 'json',
      key: cacheKey,
    );
  }
}
