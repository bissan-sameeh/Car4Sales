import '../core/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CacheController {
  ///Singleton
  CacheController._(); //لغيت الاكسيز هنا وخليته برافت وحذفت الديفولت يعني بنفعش اعمل اوبجيكت
  static CacheController cache = CacheController
      ._(); // اول حاجة عملناها هي وقفنا كل الكونستركتورز بعدين عملنا اوبجيكت منه
  factory CacheController() {
    return cache; //عشان اقدر ارجع اوبجيكت موجود بنفس الكلاس لازم يكون ستاتيك
  } //برجع اوبجيكت جديد او اوجيكت مبني مسبقا زي اللي فوق او برجع الابن
  ///Cache

  late SharedPreferences preferences;

  Future<void> initCache() async {
    preferences = await SharedPreferences.getInstance();
  }

  ///setter
  Future<void> setter(User keys, dynamic value) async {
    if (value is String) {
      await preferences.setString(keys.name, value);
    } else if (value is int) {
      await preferences.setInt(keys.name, value);
    } else if (value is double) {
      await preferences.setDouble(keys.name, value);
    } else if (value is bool) {
      await preferences.setBool(keys.name, value);
    }
  }

  dynamic getter(User keys) => preferences.get(keys.name);
  Future<List<String>?> getterMethod(String key) async {
    return preferences.getStringList(key);
  }

  logout(){
    print("cleaaaaaaaaaaaaaaaaaaaaaaaaaaaaar");
    preferences.clear();
  }

setStringList(dynamic key,List<String> list){

  preferences.setStringList(key, list);
}
remove(dynamic key){
    preferences.remove(key);
}

///Data
///
}
