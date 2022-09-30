import 'needle_impl.dart';

typedef Factory<T> = T Function();

abstract class Needle {
  static Needle get instance => NeedleImpl();

  void registerFactory<T extends Object>(
    Factory<T> factory, {
    String? instanceName,
  });

  void registerSingleton<T extends Object>({
    required T instance,
    String? instanceName,
  });

  void registerLazySingleton<T extends Object>(
    Factory<T> factory, {
    String? instanceName,
  });

  T get<T>({String? instanceName});
}
