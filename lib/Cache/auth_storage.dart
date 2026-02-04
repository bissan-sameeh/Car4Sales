  import 'package:carmarketapp/Cache/cache_controller.dart';
import 'package:carmarketapp/core/utils/enums.dart';
import 'package:carmarketapp/models/api/auth/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage{
  Future<void> saveAuth(AuthResponseModel? user) async {
    await CacheController().setter(User.username, user?.user.username ?? '');
    await CacheController().setter(User.token, user?.token ?? '');
    await CacheController().setter(User.email, user?.user.email ?? '');
    await CacheController().setter(User.whatsApp, user?.user.whatsapp ?? '');
    await CacheController().setter(User.loggedIn, true);
    await CacheController().setter(User.isSeller, user?.user.isSeller ?? false);
  }
 bool getRole() {
   final role = CacheController().getter(User.isSeller);
   return role == true;
 }


 get isLoggedIn=> CacheController().getter(User.loggedIn) ??false;

 getToken(){

  return CacheController().getter(User.token) ??'';
 }
 String? get getName=>

   CacheController().getter(User.username) ??'';
  String?get  getEmail=>

   CacheController().getter(User.email) ??'';


 String? get getWhatsAppNumber =>

   CacheController().getter(User.whatsApp) ??'';


 setUserName(String username){
   CacheController().setter(User.username, username?? '');

 }
 setWhatsApp(String whatsApp){
   CacheController().setter(User.whatsApp, whatsApp?? '');

 }

}