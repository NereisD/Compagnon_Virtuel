import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ManageDatabase {
  ManageDatabase._();

  static final ManageDatabase instance = ManageDatabase._();
  static Database _database;

  Future<Database> get database async {
    if  (_database != null) return _database;
    _database = await initDB();
    return _database;
  }


  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'message_Database.db'),
      onCreate: (db, version){
        return db.execute(
          "Create table message(tittle TEXT)"
        );
      },
      version : 1,
    );
  }
}