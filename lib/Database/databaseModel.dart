import 'dart:async' show Future;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:a/Database/database.dart';
//enum DatabaseEntryType {INTEGER, TEXT }

class DatabaseModel extends DBInterface{
  final String dbName;
  final Map<String, String> dbColumns;

  factory DatabaseModel(String dbName, Map<String, String> dbColumns){
    if(_this == null) _this = DatabaseModel._getInstance(dbName, dbColumns);
    return _this;
  }

  /// Make only one instance of this class.
  static DatabaseModel _this;

  DatabaseModel._getInstance(this.dbName, this.dbColumns): super();

  @override
  get name => 'main.db';

  @override
  get version => 1;

  @override
  Future onCreate(Database db, int version) async {
    String userColumns = dbColumnsToSQL();
    await db.execute("""
     CREATE TABLE $dbName(
              id INTEGER PRIMARY KEY,
              $userColumns
              )
     """);
  }

  String dbColumnsToSQL(){
    String m = "";
    dbColumns.forEach((k,v){
      m+= k+" "+v+",";
    });
    return m;
  }

  void save(String table){
    saveRec(table);
  }

  Future<List<Map>> getDatabaseModel() async {
    return await this.rawQuery('SELECT * FROM $dbName');
  }
}