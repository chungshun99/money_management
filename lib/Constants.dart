import 'package:flutter/material.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';

class Constants {

  static const String expenseType = "Expense";
  static const String incomeType = "Income";

  static const String actionCreate = "Create New";
  static const String actionUpdate = "Update";


  //Sorting
  static const String sortDay = "Day";
  static const String sortMonth = "Month";
  static const String sortYear = "Year";


  //Months
  static const Map<int, String> monthsInYear = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };

  //List of Icons
  static const Map<String, IconData>  icons = {
    "emergency_outlined": Icons.emergency_outlined,
    "medical_information_outlined": Icons.medical_information_outlined,
    "medication_liquid_outlined": Icons.medication_liquid_outlined,
    "restaurant_outlined": Icons.restaurant_outlined,
    "local_dining_outlined": Icons.local_dining_outlined,
    "lunch_dining_outlined": Icons.lunch_dining_outlined,
    "local_grocery_store_outlined": Icons.local_grocery_store_outlined,
    "checkroom_outlined": Icons.checkroom_outlined,
    "sports_esports_outlined": Icons.sports_esports_outlined,
    "sports_outlined": Icons.sports_outlined,
    "local_bar_outlined": Icons.local_bar_outlined,
    "flight_outlined": Icons.flight_outlined,
    "directions_car_outlined": Icons.directions_car_outlined,
    "train_outlined": Icons.train_outlined,
    "commute_outlined": Icons.commute_outlined,
    "paid_outlined": Icons.paid_outlined,
    "receipt_outlined": Icons.receipt_outlined,
    "receipt_long_outlined": Icons.receipt_long_outlined,
    "attach_money_outlined": Icons.attach_money_outlined,
    "savings_outlined": Icons.savings_outlined
  };

  //error message
  static const String emptyItemField = "Item cannot be empty.";
  static const String emptyCategoryField = "Category cannot be empty.";
  static const String emptyCategoryTypeField = "Category Type cannot be empty.";


  static const String errorDatabaseRead = "Failed to read.";
  static const String errorDatabaseCreate = "Failed to create.";
  static const String errorDatabaseUpdate = "Failed to update.";
  static const String errorDatabaseDelete = "Failed to delete.";


  //default categories
  static List<CategoryModel> defaultCategories = [
    CategoryModel(categoryName: "Eating Out", categoryIcon: "restaurant_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Food", categoryIcon: "lunch_dining_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Health", categoryIcon: "emergency_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Transport", categoryIcon: "train_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Car", categoryIcon: "directions_car_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Clothes", categoryIcon: "checkroom_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Bills", categoryIcon: "receipt_long_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Entertainment", categoryIcon: "local_bar_outlined", categoryType: "Expense"),
    CategoryModel(categoryName: "Salary", categoryIcon: "attach_money_outlined", categoryType: "Income"),
    CategoryModel(categoryName: "Savings", categoryIcon: "savings_outlined", categoryType: "Income")
  ];

}