final String categoryTableName = "Category";

class DB_CategoryField {

  static final String CategoryID = 'CategoryID';
  static final String CategoryName = 'CategoryName';
  static final String CategoryIcon = 'CategoryIcon';
  static final String CatergoryType = 'CategoryType';
}

class CategoryModel {
  final int? categoryID;
  final String categoryName;
  final String categoryIcon;
  final String categoryType;

  CategoryModel({
    this.categoryID,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryType
  });

  CategoryModel copy({
    int? CategoryID,
    String? CategoryName,
    String? CategoryIcon,
    String? CategoryType
  }) =>
      CategoryModel(
        categoryID: CategoryID ?? this.categoryID,
        categoryName: this.categoryName,
        categoryIcon: this.categoryIcon,
        categoryType: this.categoryType
      );


  static CategoryModel fromJson(Map<String, Object?> json) => CategoryModel(
      categoryID: json[DB_CategoryField.CategoryID] as int?,
      categoryName: json[DB_CategoryField.CategoryName] as String,
      categoryIcon: json[DB_CategoryField.CategoryIcon] as String,
      categoryType: json[DB_CategoryField.CatergoryType] as String
  );


  Map<String, Object?> toJson() => {
    DB_CategoryField.CategoryID : categoryID,
    DB_CategoryField.CategoryName: categoryName,
    DB_CategoryField.CategoryIcon: categoryIcon,
    DB_CategoryField.CatergoryType: categoryType
  };

}
