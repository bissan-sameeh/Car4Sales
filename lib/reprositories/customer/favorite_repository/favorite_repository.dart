import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/models/api/favorite/favorite_base_response.dart';
import 'package:carmarketapp/models/api/favorite/favorite_model.dart';
import '../../../core/errors/failure.dart';
import '../../../core/helpers/api_helpers/api_base_helper.dart';

class FavoriteRepository {
  late ApiBaseHelper _apiBaseHelper ;
  FavoriteRepository(){
    _apiBaseHelper=ApiBaseHelper();
  }
  Future<void> AddFavoriteItem(int id) async {
    print("id $id");
    final response=await _apiBaseHelper.post(addFavoriteUrl,{'carId' :id} );
    print("/////////////////////////////////////fav");
    print(response);
    print("here fav");
    // if (response is Map && response['success'] == false) {
    //   final errorMsg = response['error']?['message'] ?? 'Failed to add favorite.';
    //   print(errorMsg.toString());
    //   throw ServerFailure(errorMsg);
    // }
    // print(response);

  }
  Future<void> deleteFavoriteItem(String id) async {
    print(deleteCarUrl+id);
    final response=await _apiBaseHelper.delete(deleteFavoriteUrl+id );
    print("response $response ");
    // if (response is Map && response['success'] == false) {
    //   final errorMsg = response['error']?['message'] ?? 'Failed to delete favorite.';
    //   throw ServerFailure(errorMsg);
    // }
    print(response);

  }
  Future<List<Favorites>?> getAllFavorites() async {
    final response=await _apiBaseHelper.get(addFavoriteUrl );
    return FavoriteBaseResponse.fromJson(response).favorites;
    print(response);

  }

}
