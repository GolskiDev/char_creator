import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/open_5e_armor_model.dart';
import 'models/open_5e_class_model.dart';
import 'models/open_5e_conditions.dart';
import 'models/open_5e_magic_item.dart';
import 'models/open_5e_monster_model.dart';
import 'models/open_5e_race_model.dart';
import 'models/open_5e_weapon_model.dart';
import 'open_5e_collection_local_cache.dart';
import 'open_5e_collection_remote_data_source.dart';

final open5eCollectionRepositoryProvider = Provider<Open5eCollectionRepository>(
  (ref) {
    final remoteDataSource =
        ref.watch(open5eCollectionRemoteDataSourceProvider);
    final localCache = ref.watch(open5eCollectionLocalCacheProvider);
    return Open5eCollectionRepository(
      remoteDataSource: remoteDataSource,
      localCache: localCache,
    );
  },
);

final open5eWeaponsProvider =
    FutureProvider.autoDispose<List<Open5eWeaponModel>>(
  (ref) async {
    final repository = ref.read(open5eCollectionRepositoryProvider);
    return repository.fetchCollection(
      'weapons',
      (json) => Open5eWeaponModel.fromJson(json),
    );
  },
);

final open5eRacesProvider = FutureProvider.autoDispose<List<Open5eRaceModel>>(
  (ref) async {
    final repository = ref.read(open5eCollectionRepositoryProvider);
    return repository.fetchCollection(
      'races',
      (json) => Open5eRaceModel.fromJson(json),
    );
  },
);

final open5eMonstersProvider =
    FutureProvider.autoDispose<List<Open5eMonsterModel>>(
  (ref) async {
    final repository = ref.read(open5eCollectionRepositoryProvider);
    return repository.fetchCollection(
      'monsters',
      (json) => Open5eMonsterModel.fromMap(json),
    );
  },
);

final open5eMagicItemsProvider =
    FutureProvider.autoDispose<List<Open5eMagicItem>>(
  (ref) async {
    final repository = ref.read(open5eCollectionRepositoryProvider);
    return repository.fetchCollection(
      'magicitems',
      (json) => Open5eMagicItem.fromJson(json),
    );
  },
);

final open5eClassesProvider =
    FutureProvider.autoDispose<List<Open5eClassModel>>(
  (ref) async {
    final repository = ref.read(open5eCollectionRepositoryProvider);
    return repository.fetchCollection(
      'classes',
      (json) => Open5eClassModel.fromMap(json),
    );
  },
);

final open5eArmorsProvider = FutureProvider.autoDispose<List<Open5eArmorModel>>(
  (ref) async {
    final repository = ref.read(open5eCollectionRepositoryProvider);
    return repository.fetchCollection(
      'armors',
      (json) => Open5eArmorModel.fromMap(json),
    );
  },
);

final open5eConditionsProvider =
    FutureProvider.autoDispose<List<Open5eConditions>>(
  (ref) async {
    final repository = ref.read(open5eCollectionRepositoryProvider);
    return repository.fetchCollection(
      'conditions',
      (json) => Open5eConditions.fromMap(json),
    );
  },
);

class Open5eCollectionRepository {
  final Open5eCollectionRemoteDataSource _remoteDataSource;
  final Open5eCollectionLocalCache _localCache;

  Open5eCollectionRepository({
    required Open5eCollectionRemoteDataSource remoteDataSource,
    required Open5eCollectionLocalCache localCache,
  })  : _remoteDataSource = remoteDataSource,
        _localCache = localCache;

  Future<List<T>> fetchCollection<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cachedItems =
        await _localCache.getCollectionCache<T>(endpoint, fromJson);

    if (cachedItems != null) {
      return cachedItems;
    }

    final remoteItems =
        await _remoteDataSource.fetchCollection(endpoint, fromJson);
    await _localCache.setCollectionCache(endpoint, remoteItems);

    return remoteItems;
  }
}
