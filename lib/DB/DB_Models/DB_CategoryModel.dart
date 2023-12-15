final String categoryTableName = "Category";

class DB_CategoryField {

  static final String id = '_id';
  static final String CategoryName = 'CategoryName';
  static final String CategoryIcon = 'CategoryIcon';
  static final String CatergoryType = 'CategoryType';
}

class CategoryModel {
  final int? id;
  final String categoryName;
  final String categoryIcon;
  final String categoryType;

  CategoryModel({
    this.id,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryType
  });

  CategoryModel copy({
    int? id,
    String? CategoryName,
    String? CategoryIcon,
    String? CategoryType
  }) =>
      CategoryModel(
        id: id ?? this.id,
        categoryName: this.categoryName,
        categoryIcon: this.categoryIcon,
        categoryType: this.categoryType
      );


  static CategoryModel fromJson(Map<String, Object?> json) => CategoryModel(
      id: json[DB_CategoryField.id] as int?,
      categoryName: json[DB_CategoryField.CategoryName] as String,
      categoryIcon: json[DB_CategoryField.CategoryIcon] as String,
      categoryType: json[DB_CategoryField.CatergoryType] as String
  );

  static CategoryModel fromJson2(Map<String, dynamic> json) => CategoryModel(
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
