import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';

final String recordTableName = "Record";

class DB_RecordField {

  static final String id = "_id";
  static final String Name = "Name";
  static final String CategoryID = "CategoryID";
  static final String CategoryName = "CategoryID";
  static final String Amount = "Amount";
  //static final String Date = "Date";
  static final String Day = "Day";
  static final String Month = "Month";
  static final String Year = "Year";
  static final String Type = "Type";

  static final String NumberOfRecords = "NumberOfRecords";
}

class RecordModel {
  final int? id;
  final String? name;
  final int categoryID;
  final String? categoryName;
  final String? categoryIcon;
  final String? categoryType;
  final double amount;
  final int day;
  final int month;
  final int year;
  final String type;

  RecordModel({
    this.id,
    this.name,
    required this.categoryID,
    this.categoryName,
    this.categoryIcon,
    this.categoryType,
    required this.amount,
    required this.day,
    required this.month,
    required this.year,
    required this.type
  });

  RecordModel copy({
    int? id,
    String? Name,
    int? CategoryID,
    double? Amount,
    int? Day,
    int? Month,
    int? Year,
    String? Date,
    String? Type,
  }) =>
      RecordModel(
        id: id ?? this.id,
        name: Name ?? this.name,
        categoryID: CategoryID ?? this.categoryID,
        amount: Amount ?? this.amount,
        day: Day ?? this.day,
        month: Month ?? this.month,
        year: Year ?? this.year,
        type: Type ?? this.type,
      );

  /*DB_ExpenseDBModel(
    this.id,
    this.name,
    this.category,
    this.amount,
    this.date
  );

  DB_ExpenseDBModel copy({
    int? id,
    String? Name,
    String? Category,
    double? Amount,
    String? Date,
  }) =>
      DB_ExpenseDBModel(
        this.id,
        this.name,
        this.category,
        this.amount,
        this.date,
      );*/


  static RecordModel fromJson(Map<String, Object?> json) => RecordModel(
    id: json[DB_RecordField.id] as int?,
    name: json[DB_RecordField.Name] as String?,
    categoryID: json[DB_RecordField.CategoryID] as int,
    categoryName: json[DB_RecordField.CategoryName] as String?,
    categoryIcon: json[DB_CategoryField.CategoryIcon] as String?,
    categoryType: json[DB_CategoryField.CatergoryType] as String?,
    amount: json[DB_RecordField.Amount] as double,
    day: json[DB_RecordField.Day] as int,
    month: json[DB_RecordField.Month] as int,
    year: json[DB_RecordField.Year] as int,
    type: json[DB_RecordField.Type] as String,
  );

  Map<String, Object?> toJson() => {
    DB_RecordField.id : id,
    DB_RecordField.Name : name,
    DB_RecordField.CategoryID: categoryID,
    DB_RecordField.Amount : amount,
    DB_RecordField.Day : day,
    DB_RecordField.Month : month,
    DB_RecordField.Year : year,
    DB_RecordField.Type : type,
  };

}


class RecordFilterModel {
  final int? numberOfRecords;
  final int day;
  final int month;
  final int year;

  RecordFilterModel({
    this.numberOfRecords,
    required this.day,
    required this.month,
    required this.year
  });


  static RecordFilterModel fromJson(Map<String, Object?> json) => RecordFilterModel(
    numberOfRecords: json[DB_RecordField.NumberOfRecords] as int?,
    day: json[DB_RecordField.Day] as int,
    month: json[DB_RecordField.Month] as int,
    year: json[DB_RecordField.Year] as int,
  );


}

