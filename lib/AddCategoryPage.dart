import 'package:flutter/material.dart';
import 'package:money_management/DB/DB_Category.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {

  //constructor
  _AddCategoryPageState(){
    _selectedCategoryType = categoryTypes[0];
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  String _selectedCategoryType = "";
  List<String> categoryTypes = ['Expense', 'Income'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Category"),
        backgroundColor: Colors.blue[200],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column (
            children: <Widget> [
              Container(
                padding: EdgeInsets.only(bottom: 3),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Category Name",
                    //filled: false,
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 3),
                child: DropdownButtonFormField<String>(
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
              ),
              /*Container(
                padding: EdgeInsets.only(bottom: 3),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  controller: categoryController,
                ),
              ),*/
              Container(
                //height: 160,
                //width: 160,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 3,
                    )
                ),
                child: TextButton(
                  child: Text("Add New Expense", style: TextStyle(color: Colors.green, fontSize: 20),),
                  onPressed: () async {
                    await addNewCategory();
                    /*if (await checkValidation()) {
                      addNewCategory();
                    }*/
                  },
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }


  Future addNewCategory() async {
    String name = nameController.text;
    String categoryType = _selectedCategoryType;

    CategoryModel categoryModel = new CategoryModel(
        categoryName: name,
        categoryType: categoryType,
        categoryIcon: "Icon 1"
    );

    print("Data: " + categoryModel.categoryType);
    await DB_Category.instance.create(categoryModel);
  }
}
