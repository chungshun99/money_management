final String categoryTableName = "Category";

class DB_CategoryField {

  static final String id = '_id';
  static final String CategoryName = 'CategoryName';
  static final String CategoryIcon = 'CategoryIcon';
  static final String CatergoryType = 'CategoryType';
}

class DB_CategoryModel {
  final int? id;
  final String categoryName;
  final String categoryIcon;
  final String categoryType;

  DB_CategoryModel({
    this.id,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryType
  });

  DB_CategoryModel copy({
    int? id,
    String? CategoryName,
    String? CategoryIcon,
    String? CategoryType
  }) =>
      DB_CategoryModel(
        id: id ?? this.id,
        categoryName: this.categoryName,
        categoryIcon: this.categoryIcon,
        categoryType: this.categoryType
      );


  static DB_CategoryModel fromJson(Map<String, Object?> json) => DB_CategoryModel(
      id: json[DB_CategoryField.id] as int?,
      categoryName: json[DB_CategoryField.CategoryName] as String,
      categoryIcon: json[DB_CategoryField.CategoryIcon] as String,
      categoryType: json[DB_CategoryField.CatergoryType] as String
  );

  static DB_CategoryModel fromJson2(Map<String, dynamic> json) => DB_CategoryModel(
      id: json[DB_CategoryField.id] as int?,
      categoryName: json[DB_CategoryField.CategoryName] as String,
      categoryIcon: json[DB_CategoryField.CategoryIcon] as String,
      categoryType: json[DB_CategoryField.CatergoryType] as String
  );

  Map<String, Object?> toJson() => {
    DB_CategoryField.id : id,
    DB_CategoryField.CategoryName: categoryName,
    DB_CategoryField.CategoryIcon: categoryIcon,
    DB_CategoryField.CatergoryType: categoryType
  };

}
