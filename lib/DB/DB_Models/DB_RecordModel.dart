final String recordTableName = "Record";

class DB_RecordDBField {

  static final String id = "_id";
  static final String Name = "Name";
  static final String Category = "Category";
  static final String Amount = "Amount";
  //static final String Date = "Date";
  static final String Day = "Day";
  static final String Month = "Month";
  static final String Year = "Year";
  static final String Type = "Type";

  static final String NumberOfRecords = "NumberOfRecords";
}

class DB_RecordDBModel {
  final int? id;
  final String? name;
  final String category;
  final double amount;
  final int day;
  final int month;
  final int year;
  final String type;

  DB_RecordDBModel({
    this.id,
    this.name,
    required this.category,
    required this.amount,
    required this.day,
    required this.month,
    required this.year,
    required this.type
  });

  DB_RecordDBModel copy({
    int? id,
    String? Name,
    String? Category,
    double? Amount,
    int? Day,
    int? Month,
    int? Year,
    String? Date,
    String? Type,
  }) =>
      DB_RecordDBModel(
        id: id ?? this.id,
        name: Name ?? this.name,
        category: Category ?? this.category,
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


  static DB_RecordDBModel fromJson(Map<String, Object?> json) => DB_RecordDBModel(
    id: json[DB_RecordDBField.id] as int?,
    name: json[DB_RecordDBField.Name] as String?,
    category: json[DB_RecordDBField.Category] as String,
    amount: json[DB_RecordDBField.Amount] as double,
    day: json[DB_RecordDBField.Day] as int,
    month: json[DB_RecordDBField.Month] as int,
    year: json[DB_RecordDBField.Year] as int,
    type: json[DB_RecordDBField.Type] as String,
  );

  Map<String, Object?> toJson() => {
    DB_RecordDBField.id : id,
    DB_RecordDBField.Name : name,
    DB_RecordDBField.Category: category,
    DB_RecordDBField.Amount : amount,
    DB_RecordDBField.Day : day,
    DB_RecordDBField.Month : month,
    DB_RecordDBField.Year : year,
    DB_RecordDBField.Type : type,
  };

}


class DB_RecordFilterModel {
  final int? numberOfRecords;
  final int day;
  final int month;
  final int year;

  DB_RecordFilterModel({
    this.numberOfRecords,
    required this.day,
    required this.month,
    required this.year
  });


  static DB_RecordFilterModel fromJson(Map<String, Object?> json) => DB_RecordFilterModel(
    numberOfRecords: json[DB_RecordDBField.NumberOfRecords] as int?,
    day: json[DB_RecordDBField.Day] as int,
    month: json[DB_RecordDBField.Month] as int,
    year: json[DB_RecordDBField.Year] as int,
  );


}

