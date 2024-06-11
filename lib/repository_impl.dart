class DefaultRepositoryImpl implements DefaultRepository {
  final DefaultDataSource _dataSource;

  DefaultRepositoryImpl(this._dataSource);

  @override
  Future<String> getSomeData() async {
    return _dataSource.getSomeData();
  }
}