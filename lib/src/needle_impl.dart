import 'needle.dart';
import 'store/needle_store.dart';

class NeedleImpl implements Needle {
  static final NeedleImpl _storeHelperImpl = NeedleImpl._internal();

  factory NeedleImpl() => _storeHelperImpl;

  NeedleImpl._internal();

  final NeedleStore _needleStore = NeedleStoreImpl();

  /// if flag isLazySingleTon is true then update NeedleItem in store
  /// and put there T instance instead of T Function
  ///
  /// else is T factory
  ///
  /// and if it just an instance of T

  @override
  T get<T>({String? instanceName}) {
    final key = instanceName ?? T.toString();
    final NeedleItem storeItem = _needleStore.getItem(key);

    if (storeItem.isLazySingleton) return _handleSingleton<T>(key, storeItem);

    if (storeItem.item is T Function()) return storeItem.item.call() as T;

    return storeItem.item as T;
  }

  /// Save T Function in to store
  @override
  void registerFactory<T extends Object>(
    Factory<T> factory, {
    String? instanceName,
  }) {
    final key = instanceName ?? T.toString();
    _needleStore.putItem(
      NeedleItem<T Function()>(item: factory, instanceName: instanceName),
      key,
    );
  }

  /// Save an instance in to store as lazy singleton
  /// first read calls T Factory method and return a T instance
  /// then update item in the store replacing T Factory by the instance
  @override
  void registerLazySingleton<T extends Object>(
    Factory<T> factory, {
    String? instanceName,
  }) {
    final key = instanceName ?? T.toString();
    _needleStore.putItem(
      NeedleItem<T Function()>(
        item: factory,
        instanceName: instanceName,
        isLazySingleton: true,
      ),
      key,
    );
  }

  @override
  void registerSingleton<T extends Object>({
    required T instance,
    String? instanceName,
  }) {
    final key = instanceName ?? T.toString();
    _needleStore.putItem<T>(
      NeedleItem<T>(
        item: instance,
        instanceName: instanceName,
      ),
      key,
    );
  }

  T _handleSingleton<T>(String key, NeedleItem storeItem) {
    final instance = (storeItem.item as T Function()).call();
    final newItem = NeedleItem(
      item: instance,
      instanceName: storeItem.instanceName,
    );
    _needleStore.update(key, newItem);
    return instance;
  }
}
