import 'dart:io';

import 'package:carmarketapp/core/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
class DbSettings {
  ///Singleton
  DbSettings._();

  ///
  static final DbSettings _dbSettings = DbSettings._();

  factory DbSettings() => _dbSettings;

  ///DATABASE
   late Database database;

   Future<void> initDb() async{
     if(kIsWeb){
       return null;
     }
     Directory directory=await getApplicationDocumentsDirectory();
     String sqlName='app_db1.sql';
     String path= join(directory.path,sqlName);

    database=await openDatabase(path,version: 1,onCreate:(db, version) async {
    await  db.execute("CREATE TABLE ${DbTable.brand.name}("
        "brandName Text PRIMARY KEY "
        ")");
    }, );

   }
}
