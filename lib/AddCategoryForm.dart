import 'package:flutter/material.dart';
import 'package:money_management/Constants.dart';
import 'package:money_management/DB/DB_Category.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';
import 'package:money_management/ErrorDialog.dart';
import 'package:sqflite/sqflite.dart';


class AddCategoryForm extends StatefulWidget {

  AddCategoryForm({Key? key, required this.action, this.categoryModel}) : super(key: key);
  String action;
  CategoryModel? categoryModel;

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {

  //constructor
  _AddCategoryFormState(){
    _selectedCategoryType = categoryTypes[0];
    //_selectedIcon = iconList[0].toString();
    //_selectedIcon = iconList[0].toString();
    _selectedIcon = iconList.keys.toList().first;
  }

  TextEditingController categoryNameController = TextEditingController();
  //TextEditingController categoryController = TextEditingController();
  String _selectedCategoryType = "";
  String _selectedIcon = "";
  List<String> categoryTypes = ['Expense', 'Income'];
  //List<IconData> iconList = Constants.icons;
  Map<String, IconData> iconList = Constants.icons;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.categoryModel != null) {
      categoryNameController.text = widget.categoryModel!.categoryName;
      _selectedCategoryType = widget.categoryModel!.categoryType;
      _selectedIcon = widget.categoryModel!.categoryIcon;

    }

  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      elevation: 0,
      //backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget> [
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child:
                  Text(
                      "${widget.action} Category",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500), textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Category Name",
                    //filled: false,
                    border: OutlineInputBorder(),
                  ),
                  controller: categoryNameController,
                ),
                const SizedBox(height: 20,),
                //Category Type Dropdown
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    //filled: false,
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategoryType,
                  items: categoryTypes.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategoryType = val as String;
                    });
                  },
                ),
                const SizedBox(height: 20,),
                //Icon Dropdown List
                DropdownButtonFormField<String>(
                  //isDense: false,
                  isExpanded: true,
                  //itemHeight: 50,
                  decoration: const InputDecoration(
                    labelText: "Icon",
                    //filled: false,
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedIcon,
                  /*items: iconList.map((iconName, iconValue) => DropdownMenuItem(
                    value: iconName,
                    child: Icon(iconValue),
                  )).toList(),*/
                  items: iconList.map((iconName, iconValue) {
                    return MapEntry(
                        iconName,
                        DropdownMenuItem<String>(
                          value: iconName,
                          child: Icon(iconValue),
                        ));
                  }).values.toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedIcon = val as String;
                    });
                  },
                ),
                const SizedBox(height: 20,),
                //Submit button
                OutlinedButton(
                  onPressed: () async {
                    if (await checkValidation()) {
                      if (widget.action == Constants.actionCreate) {
                        await addNewCategory();
                      }
                      else {
                        await updateCategory();
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    //padding: const EdgeInsets.all(25),
                    minimumSize:Size(180, 45),
                    foregroundColor: Colors.green,
                    side: const BorderSide(
                      color: Colors.lightGreen,
                    ),
                  ),
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }


  Future<bool> checkValidation() async {
    if (categoryNameController.text == "") {
      showErrorDialog(context, Constants.emptyItemField);
      return false;
    }
    if (_selectedCategoryType == "") {
      showErrorDialog(context, Constants.emptyCategoryField);
      return false;
    }

    return true;
  }

  Future addNewCategory() async {
    String categoryName = categoryNameController.text;
    String categoryType = _selectedCategoryType;
    String categoryIcon = _selectedIcon;
    print("Selected Icon:: " + categoryIcon);
    IconData firstIcon = iconList.values.toList().first;
    //print("Selected Icon:: " + firstIcon.toString());

    CategoryModel categoryModel = new CategoryModel(
        categoryName: categoryName,
        categoryType: categoryType,
        categoryIcon: categoryIcon
    );

    print("Data: " + categoryModel.categoryType);
    try {
      await DB_Category.instance.create(categoryModel);
      Navigator.pop(context);
    }
    catch(e) {
      print(e);
      showErrorDialog(context, Constants.errorDatabaseCreate);
      Navigator.pop(context);
    }

  }

  Future updateCategory() async {
    int? id = widget.categoryModel!.id;
    String categoryName = categoryNameController.text;
    String categoryType = _selectedCategoryType;
    String categoryIcon = _selectedIcon;

    try {
      await DB_Category.instance.updateCategory(id!, categoryName, categoryIcon, categoryType);
      Navigator.pop(context);
    }
    catch(e) {
      //print();
      print(e);
      showErrorDialog(context, Constants.errorDatabaseUpdate);
      Navigator.pop(context);
    }

  }

  //new showAlertDialog
  Future<void> showErrorDialog(BuildContext context, String message) {
    return showDialog(
      //barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return ErrorDialog(errorText: message);
        }
    );
  }

  //Old showAlertDialog
  /*Future<void> showAlertDialog(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${message}cannot be empty!'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/

}
