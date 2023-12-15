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

  /*
  **************************
  //Table Creation Functions
  **************************
  */

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

  //only run on first time, to add the default categories
  Future<void> _createDefaultCategories(Database database) async {
    List<CategoryModel> defaultCategories = Constants.defaultCategories;

    for(var category in defaultCategories) {
      await database.insert('Category', category.toJson());
    }

  }


  /*
  **************************
  //Record Table Functions
  **************************
  */

  Future<RecordModel> createRecord(RecordModel recordModel) async {
    final db = await instance.database;

    final id = await db.insert(recordTableName, recordModel.toJson());
    return recordModel.copy(id: id);

  }

  Future<List<RecordModel>> readAllRecord() async {
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
          'INNER JOIN $categoryTableName ON $recordTableName.CategoryID = $categoryTableName._id '
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

  // update record
  Future<int> updateRecord(int id, String name, String category, double amount, int day, int month, int year) async {
    final db = await instance.database;

    return db.rawUpdate(
        'UPDATE $recordTableName SET Name = "$name", Category = "$category", Amount = $amount, Day = $day, Month = $month, Year = $year '
            'WHERE _id = $id'
    );

  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;

    return await db.delete(
      recordTableName,
      where: '${DB_RecordField.id} = ?',
      whereArgs: [id],
    );
  }


  /*
  **************************
  //Category Table Functions
  **************************
  */

  Future<CategoryModel> createCategory(CategoryModel categoryModel) async {
    final db = await instance.database;

    final id = await db.insert(categoryTableName, categoryModel.toJson());

    return categoryModel.copy(id: id);
  }

  Future<List<CategoryModel>> readAllCategory() async {
    final db = await instance.database;

    final result = await db.query(categoryTableName);

    return result.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<List<CategoryModel>> getCategoryBasedOnType(String categoryType) async {
    final db = await instance.database;

    final result = await db.query(
      categoryTableName,
      where: '${DB_CategoryField.CatergoryType} = ? ',
      whereArgs: [categoryType],
    );

    return result.map((json) => CategoryModel.fromJson(json)).toList();
  }

  /*Future<String> getCategoryBasedOnId(int categoryId) async {
    final db = await instance.database;

    List<Map> results = await db.query(categoryTableName, columns: Story.columns, where: "id = ?", whereArgs: [storyId]);

    Story story = Story.fromMap(results[0]);
    story.user = await fetchUser(story.user_id);

    return story;
  }*/


  Future<int> updateCategory(int id, String categoryName, String categoryIcon, String categoryType) async {
    final db = await instance.database;

    return db.rawUpdate(
        'UPDATE $categoryTableName SET CategoryName = "$categoryName", CategoryIcon = "$categoryIcon", CategoryType = "$categoryType" '
            'WHERE _id = $id'
    );
  }

  Future<int> deleteCategory(int id, String categoryName, String categoryType) async {
    final db = await instance.database;

    return await db.delete(
      categoryTableName,
      where: '${DB_CategoryField.id} = ? AND ${DB_CategoryField.CategoryName} = ? AND ${DB_CategoryField.CatergoryType} = ? ' ,
      whereArgs: [id, categoryName, categoryType],
    );
  }

}