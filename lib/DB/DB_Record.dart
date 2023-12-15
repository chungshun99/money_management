import 'dart:ffi';

import 'package:money_management/Constants.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';
import 'package:money_management/DB/DB_Models/DB_RecordModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB_Record {

  static final DB_Record instance = DB_Record._init();

  static Database? _database;

  DB_Record._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('Record.db');
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
    ${DB_RecordField.id} $idType,
    ${DB_RecordField.Name} $textNullType,
    ${DB_RecordField.CategoryID} $textNotNullType,
    ${DB_RecordField.Amount} $realType,
    ${DB_RecordField.Day} $intNotNullType,
    ${DB_RecordField.Month} $intNotNullType,
    ${DB_RecordField.Year} $intNotNullType,
    ${DB_RecordField.Type} $textNotNullType
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

    await _createDefaultCategories(db);

  }

  Future<void> _createDefaultCategories(Database database) async {
    List<CategoryModel> defaultCategories = Constants.defaultCategories;

    for(var category in defaultCategories) {
      await database.insert('Category', category.toJson());
    }

  }

  Future<RecordModel> create(RecordModel recordModel) async {
    final db = await instance.database;

    final id = await db.insert(recordTableName, recordModel.toJson());
    return recordModel.copy(id: id);

  }

  Future<List<RecordModel>> readAllData() async {
    final db = await instance.database;

    //custom query
    /*final result = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');*/

    final result = await db.query(recordTableName);

    return result.map((json) => RecordModel.fromJson(json)).toList();
  }

  Future<List<RecordFilterModel>> getFilteredTotalRecord(String sort) async {
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

    return result.map((json) => RecordFilterModel.fromJson(json)).toList();
  }

  Future<List<RecordModel>> getFilteredRecordsList(String sortBy, int day, int month, int year) async {
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

    return result.map((json) => RecordModel.fromJson(json)).toList();
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
      where: '${DB_RecordField.id} = ?',
      whereArgs: [id],
    );
  }

}