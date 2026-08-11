abstract class Repository<T> {
  List<T> get items;

  void add(T item);

  void delete(String id);

  T findById(String id);
}