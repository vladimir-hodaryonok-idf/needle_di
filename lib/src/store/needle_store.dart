import '../exceptions/exceptions.dart';

abstract class NeedleStore {
  void putItem<T>(NeedleItem<T> item, String key);

  NeedleItem getItem(String key);

  void update<T>(String key, NeedleItem<T> item);
}

class NeedleStoreImpl implements NeedleStore {
  final Map<String, NeedleItem> _store = {};

  @override
  NeedleItem getItem(String key) {
    final item = _store[key];
    if (item == null) throw ItemNotFoundException(key);
    return item;
  }

  @override
  void putItem<T>(NeedleItem<T> item, String key) => _store[key] = item;

  @override
  void update<T>(String key, NeedleItem<T> item) =>
      _store.update(key, (value) => item);
}

/// item can store and instance of the object
/// and factory method
class NeedleItem<T> {
  final T item;
  final String? instanceName;
  final bool isLazySingleton;

  NeedleItem({
    required this.item,
    required this.instanceName,
    this.isLazySingleton = false,
  });
}
