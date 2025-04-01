import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'open_5e_spell_model.dart';
import 'open_5e_spells_local_cache.dart';
import 'open_5e_spells_remote_data_source.dart';

final open5eSpellsRepositoryProvider = Provider<Open5eSpellsRepository>(
  (ref) {
    final remoteDataSource = ref.watch(open5eSpellsRemoteDataSourceProvider);
    final localCache = ref.watch(open5eSpellsLocalCacheProvider);
    return Open5eSpellsRepository(
      remoteDataSource: remoteDataSource,
      localCache: localCache,
    );
  },
);

final allSRDSpellsProvider =
    FutureProvider.autoDispose<List<Open5eSpellModelV1>>(
  (ref) async {
    final repository = ref.read(open5eSpellsRepositoryProvider);
    return repository.allSRDSpells();
  },
);

class Open5eSpellsRepository {
  final Open5eSpellsRemoteDataSource _remoteDataSource;
  final Open5eSpellsLocalCache _localCache;

  Open5eSpellsRepository({
    required Open5eSpellsRemoteDataSource remoteDataSource,
    required Open5eSpellsLocalCache localCache,
  })  : _remoteDataSource = remoteDataSource,
        _localCache = localCache;

  Future<List<Open5eSpellModelV1>> allSRDSpells() async {
    final cachedSpells = await _localCache.getSpellsCache();

    if (cachedSpells != null) {
      return cachedSpells;
    }

    final remoteSpells = await _remoteDataSource.fetchSpells();
    await _localCache.setSpellsCache(remoteSpells);

    return remoteSpells;
  }
}
