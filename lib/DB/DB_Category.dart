import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB_Category {
  static final DB_Category instance = DB_Category._init();

  static Database? _database;

  DB_Category._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('Category.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final exist = await databaseExists(path);
    if (!exist) {
      //database does not exist and create new
      print("Category database does not exist and creating a copy of Category db from assets.");

      ByteData data = await rootBundle.load(join("assets", "DefaultCategory.db"));
      List<int> bytes = data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);

      //Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

      print("db copied");
    }

    return await openDatabase(path);

    //return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Future<List<DB_CategoryModel>> getAllCategory() async {
  //   final db = await instance.database;
  //   if (db == null) {
  //     throw "bd is not initiated, initiate using [init(db)] function";
  //   }
  //   List<Map> categories;
  //
  //   await db.transaction((txn) async {
  //     categories = await txn.query(
  //       "Category",
  //       columns: [
  //         "id",
  //         "CategoryName",
  //         "CategoryIcon",
  //         "CategoryType",
  //       ],
  //     );
  //   });
  //
  //   //return result.map((json) => DB_RecordDBModel.fromJson(json)).toList();
  //   return categories.map((e) => DB_CategoryModel.fromJson2(e)).toList();
  // }


  /*Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final exist = await databaseExists(path);
    if (exist) {
      //database exists
      //open database
      print("Category already existed.");

      return await openDatabase(path);
    } else {
      //database does not exist and create new
      print("Creating a copy of Category db from assets");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch(_) {}

      ByteData data = await rootBundle.load(join("assets", "Category.db"));
      List<int> bytes = data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      
      print("db copied");
    }

    return await openDatabase(path);

    //return await openDatabase(path, version: 1, onCreate: _createDB);
  }*/



  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final pkIntType = 'INTEGER PRIMARY KEY';
    final pkTextType = 'TEXT PRIMARY KEY';
    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'INTEGER NULL';
    final textNullType = 'TEXT NULL';
    final textNotNullType = 'TEXT NOT NULL';


    await db.execute('''
    CREATE TABLE $categoryTableName (
    ${DB_CategoryField.CategoryID} $idType,
    ${DB_CategoryField.CategoryName} $textNotNullType,
    ${DB_CategoryField.CategoryIcon} $textNotNullType,
    ${DB_CategoryField.CatergoryType} $textNotNullType
    )
    ''');

    //await _createDefaultCategories(db);

  }

  /*Future<void> _createDefaultCategories(Database database) async {
    await database.insert('Category', Category(id: 1).toMap());
  }*/

  Future<CategoryModel> create(CategoryModel categoryModel) async {
    final db = await instance.database;

    final categoryID = await db.insert(categoryTableName, categoryModel.toJson());

    return categoryModel.copy(CategoryID: categoryID);
  }

  Future<List<CategoryModel>> readAllData() async {
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


  Future<int> updateCategory(int categoryID, String categoryName, String categoryIcon, String categoryType) async {
    final db = await instance.database;

    return db.rawUpdate(
        'UPDATE $categoryTableName SET CategoryName = "$categoryName", CategoryIcon = "$categoryIcon", CategoryType = "$categoryType" '
            'WHERE CategoryID = $categoryID'
    );
  }

  Future<int> delete(int categoryID, String categoryName, String categoryType) async {
    final db = await instance.database;

    return await db.delete(
      categoryTableName,
      where: '${DB_CategoryField.CategoryID} = ? AND ${DB_CategoryField.CategoryName} = ? AND ${DB_CategoryField.CatergoryType} = ? ' ,
      whereArgs: [categoryID, categoryName, categoryType],
    );
  }

}