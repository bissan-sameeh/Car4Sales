import 'package:carmarketapp/Cache/favorite_storage.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/reprositories/customer/favorite_repository/favorite_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/errors/excpations.dart';
import '../../../core/errors/failure.dart';
import '../../../models/api/favorite/favorite_model.dart';

class FavoriteProvider extends ChangeNotifier {
  late FavoriteRepository _favoriteRepository;
  ApiResponse<List<Favorites>?> _getAllFavorites=ApiResponse.loading("loading cars");
  ApiResponse<void> _toggleFavorite=ApiResponse.loading("loading cars");
  Set<String> _carIdS = {};
  bool isFavoriteScreen =false;
  // Map<String,Favorites > _favoriteMap={};
  Map<String,bool> _loadingFavorites={}; //متابعة حالة اللودينغغغ للعنصر الواجد
  bool isLoadingFavorite(String id)=> _loadingFavorites[id]??false;



  bool addedFavorite= false;
  late FavoriteStorage favoriteStorage;

  FavoriteProvider(){
    _favoriteRepository=FavoriteRepository();
    favoriteStorage=FavoriteStorage();
    // notifyListeners();
  }





  ApiResponse<List<Favorites>?> get allFavorites=> _getAllFavorites;
  ApiResponse<void> get toggleFavoriteStatus=> _toggleFavorite;
  void addToFavorite(String id){
    _carIdS.add(id);
    favoriteStorage.saveCarIdToStorage(_carIdS);
    notifyListeners();
  }
  void removeFromLocalFavorite(String id){
    _carIdS.remove(id);
    favoriteStorage.saveCarIdToStorage(_carIdS);


    notifyListeners();
  }

  isFavScreen(bool isFav){
    isFavoriteScreen=isFav;
    notifyListeners();
  }

  Future<void> loadFavoriteFromStorage() async {
    final List<String>? favList=await favoriteStorage.getAllFavCarIds() ??[];
    _carIdS=favList!.toSet();
    notifyListeners();
  }

  bool isFavorite(String id){
    return _carIdS.contains(id);

  }

  Future<void> toggleFavorite({required int id}) async {
    final idStr=id.toString();
    final wasFav=isFavorite(idStr);
    if(wasFav ){
      removeFromLocalFavorite(idStr);
    }else{
      addToFavorite(idStr);
    }
    try{

      if(wasFav){ //remove fav
        _loadingFavorites[idStr] = true;
        print("car id $id");

        final response=await  deleteFavoriteItem(id:id.toString());
        if (isFavoriteScreen) {
          _getAllFavorites.data?.removeWhere((e) => e.carId.toString() == idStr);
          _loadingFavorites[idStr] = false;

        }
        // await fetchAllFavorites();

        _toggleFavorite=ApiResponse.completed(response);
      }else{
        final response= await AddFavoriteItem(id: id);
        _toggleFavorite=ApiResponse.completed(response);

      }
    }catch (e){
      print("catchhhhhhhhh fav");
      if(wasFav){
        addToFavorite(idStr);
      }else{
        removeFromLocalFavorite(idStr);
      }

      print("errr $e" );


      if (e is Failure) {

        _toggleFavorite = ApiResponse.error(mapFailureToMessage(e));
        print("errrrrrror");
        print(_toggleFavorite);
      }
      else {
        _toggleFavorite = ApiResponse.error("Unexpected error");
      }
    } finally {
      _loadingFavorites[idStr] = false;
      notifyListeners();
    }
  }

  void clear() {
    _getAllFavorites = ApiResponse.initial("initial");
    _toggleFavorite = ApiResponse.initial("initial");

    _carIdS.clear();
    _loadingFavorites.clear();
    isFavoriteScreen = false;
    addedFavorite = false;

    favoriteStorage.clear(); // تمسح الفيفوريت من التخزين فقط

    notifyListeners();
  }



  void syncLocalWithServer() {
    final serverFavIds = _getAllFavorites.data
        ?.map((e) => e.carId.toString())
        .toSet() ?? {};

    _carIdS = serverFavIds;
    favoriteStorage.saveCarIdToStorage(_carIdS);
    print("fav ids $_carIdS");
    notifyListeners();
  }


  Future<List<Favorites>?> fetchAllFavorites() async {
    _getAllFavorites = ApiResponse.loading("Loading fav");
    notifyListeners();
    try {
      final response = await _favoriteRepository.getAllFavorites();


      _getAllFavorites = ApiResponse.completed(response);
      notifyListeners();

    } catch (error) {
      if (error is Failure) {
        String message = mapFailureToMessage(error);

        _getAllFavorites = ApiResponse.error(message);
        notifyListeners();
      }

      notifyListeners();
    }
    return null;
  }



  Future<void> AddFavoriteItem({required int id}) async {
    _toggleFavorite = ApiResponse.loading("add fav!");
    print(_toggleFavorite);
    notifyListeners();
    //api request
    final response = await _favoriteRepository.AddFavoriteItem(id);
    _toggleFavorite = ApiResponse.completed(response);
    //cache
    addToFavorite(id.toString());
    notifyListeners();



  }


  Future<void> deleteFavoriteItem({required String id}) async {
    final favs = await _favoriteRepository.getAllFavorites();

    final favorite = favs?.firstWhere(
          (e) => e.carId.toString() == id,
    );

    final favId = favorite?.id;
    if (favId == null) {
      throw ServerFailure("Favorite not found");
    }

    await _favoriteRepository.deleteFavoriteItem(favId.toString());
  }
}

