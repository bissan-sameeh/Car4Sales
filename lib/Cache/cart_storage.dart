import '../core/utils/enums.dart';
import 'cache_controller.dart';

class CartStorage {
  CacheController cache = CacheController();
  final String _key = CartId.cartId.name;

  Future<void> saveCarIdToStorage(Set<String> ids) async {
    await cache.setStringList(_key, ids.toList());
  }

  Future<List<String>> getAllCartCarIds() async {
    return await cache.getterMethod(_key) ?? [];
  }

  Future<void> clear() async {
    await cache.remove(_key);
  }
}
