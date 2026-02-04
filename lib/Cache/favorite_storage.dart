import 'package:carmarketapp/models/api/favorite/favorite_model.dart';

import '../core/utils/enums.dart';
import 'cache_controller.dart';

class FavoriteStorage{
 CacheController cache =CacheController();
 final String _key = Favorite.favoriteId.name;

 void saveFavoriteIdsToStorage(Map<String,Favorites> favMap) async {
   final List<String> encodedMap=favMap.entries.map((e) => '${e.key}:${e.value}',).toList();
   await cache.setStringList(_key, encodedMap);
    // cache.setStringList(Favorite.favoriteId.name,ids);
  }
  Future<void> saveCarIdToStorage(Set<String> ids) async {
  await cache.setStringList(_key, ids.toList());
  }

  Future<List<String>?> getAllFavCarIds() async {
   return await cache.getterMethod(_key) ??[];
  }
  void clear(){
     cache.remove(_key) ;

  }





}