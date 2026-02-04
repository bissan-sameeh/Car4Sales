import 'package:carmarketapp/DB/db_settings.dart';
import 'package:carmarketapp/core/utils/enums.dart';
import 'package:carmarketapp/models/db/brands_model.dart';
import 'package:sqflite/sqflite.dart';
class BrandsDbController{
  ///create
  final Database _database =DbSettings().database;
  final String _table=DbTable.brand.name;

  ///create
   Future<bool> create(BrandModel brand) async {
     print("object");
    var result= await _database.insert(_table, brand.toJson());
     print("objectsssssssssss");

     return result>0;
   }
  ///Read([])

   Future<List<BrandModel>?> read() async{
     var result=await _database.query(_table); //List of map
     if(result.isNotEmpty){

     return result.map((raw) =>BrandModel(brandName: raw['brandName'].toString(),isSelected: false) ,).toList(); //each row is a map that converted into BrandModel
     }else{
       return null;
     }
   }

   ///Show


  Future<List<BrandModel>?> show(String searchedValue) async{
    var result=await _database.rawQuery('SELECT * FROM $_table WHERE brandName="$searchedValue"'); //List of map
    if(result.isNotEmpty ) {
      return
        result.map((row) => BrandModel.fromJson(row),)
            .toList(); //each row is a map that converted into BrandModel
    }
    else {
      return null;
    }
  }



}