abstract class IRepository<T> {
  Future<T> getOne(String id);
  Future<List<T>> getAll();
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(String id);

  Stream get stream;
}