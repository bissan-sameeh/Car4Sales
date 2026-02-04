
import 'favorite_model.dart';

class FavoriteBaseResponse {
  int? length;
  List<Favorites>? favorites;

  FavoriteBaseResponse({this.length, this.favorites});

  FavoriteBaseResponse.fromJson(Map<String, dynamic> json) {
    length = json["length"];
    favorites = json["favorites"] == null ? null : (json["favorites"] as List).map((e) => Favorites.fromJson(e)).toList();
  }


}