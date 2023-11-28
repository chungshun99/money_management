import 'dart:ffi';

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
    ${DB_RecordDBField.id} $idType,
    ${DB_RecordDBField.Name} $textNullType,
    ${DB_RecordDBField.Category} $textNotNullType,
    ${DB_RecordDBField.Amount} $realType,
    ${DB_RecordDBField.Day} $intNotNullType,
    ${DB_RecordDBField.Month} $intNotNullType,
    ${DB_RecordDBField.Year} $intNotNullType,
    ${DB_RecordDBField.Type} $textNotNullType
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

  Future<List<DB_RecordFilterModel>> getFilteredTotalRecord() async {
    final db = await instance.database;

    //custom query
    final result = await db.rawQuery('SELECT Count(*) as NumberOfRecords, Day, Month, Year FROM $recordTableName '
        'GROUP BY Day, Month, Year');

    return result.map((json) => DB_RecordFilterModel.fromJson(json)).toList();
  }

  Future<List<DB_RecordDBModel>> getFilteredRecordsList(int day) async {
    final db = await instance.database;

    //custom query
    final result = await db.rawQuery('SELECT * FROM $recordTableName WHERE Day = $day');

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