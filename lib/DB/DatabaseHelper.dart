import 'dart:ffi';

import 'package:money_management/Constants.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';
import 'package:money_management/DB/DB_Models/DB_RecordModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('MoneyManager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final pkIntType = 'INTEGER PRIMARY KEY';
    final pkTextType = 'TEXT PRIMARY KEY';
    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'INTEGER NULL';
    final realType = 'REAL NOT NULL';
    final intNotNullType = 'INTEGER NOT NULL';
    final textNullType = 'TEXT NULL';
    final textNotNullType = 'TEXT NOT NULL';


    await db.execute('''
    CREATE TABLE $recordTableName (
    ${DB_RecordDBField.id} $idType,
    ${DB_RecordDBField.Name} $textNullType,
    ${DB_RecordDBField.CategoryID} $textNotNullType,
    ${DB_RecordDBField.Amount} $realType,
    ${DB_RecordDBField.Day} $intNotNullType,
    ${DB_RecordDBField.Month} $intNotNullType,
    ${DB_RecordDBField.Year} $intNotNullType,
    ${DB_RecordDBField.Type} $textNotNullType
    )
    ''');

    await db.execute('''
    CREATE TABLE $categoryTableName (
    ${DB_CategoryField.id} $idType,
    ${DB_CategoryField.CategoryName} $textNotNullType,
    ${DB_CategoryField.CategoryIcon} $textNotNullType,
    ${DB_CategoryField.CatergoryType} $textNotNullType
    )
    ''');

  }

  Future<DB_RecordDBModel> create(DB_RecordDBModel recordModel) async {
    final db = await instance.database;

    final id = await db.insert(recordTableName, recordModel.toJson());
    return recordModel.copy(id: id);

  }

  Future<List<DB_RecordDBModel>> readAllData() async {
    final db = await instance.database;

    //custom query
    /*final result = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');*/

    final result = await db.query(recordTableName);

    return result.map((json) => DB_RecordDBModel.fromJson(json)).toList();
  }

  Future<List<DB_RecordFilterModel>> getFilteredTotalRecord(String sort) async {
    final db = await instance.database;

    //custom query
    List<Map<String, Object?>> result = [];

    if (sort == Constants.sortDay) {
      result = await db.rawQuery('SELECT Count(*) as NumberOfRecords, Day, Month, Year FROM $recordTableName '
          'GROUP BY Day, Month, Year');
    } else if (sort == Constants.sortMonth) {
      result = await db.rawQuery('SELECT Count(*) as NumberOfRecords, Day, Month, Year FROM $recordTableName '
          'GROUP BY Month, Year');
    } else if (sort == Constants.sortYear) {
      result = await db.rawQuery('SELECT Count(*) as NumberOfRecords, Day, Month, Year FROM $recordTableName '
          'GROUP BY Year');
    }

    /*final result = await db.rawQuery('SELECT Count(*) as NumberOfRecords, Day, Month, Year FROM $recordTableName '
        'GROUP BY Day, Month, Year');*/

    return result.map((json) => DB_RecordFilterModel.fromJson(json)).toList();
  }

  Future<List<DB_RecordDBModel>> getFilteredRecordsList(String sortBy, int day, int month, int year) async {
    final db = await instance.database;

    //custom query
    //final result = await db.rawQuery('SELECT * FROM $recordTableName WHERE Day = $day');

    List<Map<String, Object?>> result = [];

    if (sortBy == Constants.sortDay) {
      result = await db.rawQuery('SELECT * FROM $recordTableName '
          'INNER JOIN $categoryTableName ON $recordTableName.Category = $categoryTableName.CategoryName '
          'WHERE Day = $day AND Month = $month AND Year = $year'
      );
    }
    else if (sortBy == Constants.sortMonth) {
      result = await db.rawQuery('SELECT * FROM $recordTableName WHERE Month = $month AND Year = $year');
    }
    else if (sortBy == Constants.sortYear) {
      result = await db.rawQuery('SELECT * FROM $recordTableName WHERE Year = $year');
    }

    //final result = await db.query(recordTableName);

    return result.map((json) => DB_RecordDBModel.fromJson(json)).toList();
  }



  // update expense
  Future<int> updateRecord(int id, String name, String category, double amount, int day, int month, int year) async {
    final db = await instance.database;

    return db.rawUpdate(
        'UPDATE $recordTableName SET Name = "$name", Category = "$category", Amount = $amount, Day = $day, Month = $month, Year = $year '
            'WHERE _id = $id'
    );

  }


  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      recordTableName,
      where: '${DB_RecordDBField.id} = ?',
      whereArgs: [id],
    );
  }

}