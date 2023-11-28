import 'package:flutter/material.dart';

class Constants {

  static const String expenseType = "Expense";
  static const String incomeType = "Income";

  static const String actionCreate = "Create New";
  static const String actionUpdate = "Update";

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
}