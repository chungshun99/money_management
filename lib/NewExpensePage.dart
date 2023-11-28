import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:money_management/Constants.dart';
import 'package:money_management/DB/DB_Category.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';
import 'package:money_management/DB/DB_Record.dart';
import 'package:money_management/DB/DB_Models/DB_RecordModel.dart';
import 'package:money_management/ProgressDialog.dart';

class NewExpensePage extends StatefulWidget {
  String type;
  NewExpensePage({Key? key, required this.type}) : super(key: key);

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {

  //constructor
  _NewExpensePageState(){
    //_selectedCategory = categories[0];
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String _selectedCategory = "";
  List<String> categories = ['Category 1', 'Category 2', 'Category 3', 'Category 4'];
  late List<DB_CategoryModel> categoryListTemp;
  List<DB_CategoryModel> categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadCategory(widget.type);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New ${widget.type}"),
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
                    labelText: "Name",
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
                  //value: _selectedCategory,
                  /*items: categories.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),*/
                  items: categoryList.map((e) => DropdownMenuItem(
                    value: e.categoryName,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 35,
                          height: 70,
                          child: Icon(
                            Constants.icons[e.categoryIcon],
                            size: 30,
                          ),
                        ),
                        Text(e.categoryName),
                      ],
                    ),
                  )).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val as String;
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
                padding: EdgeInsets.only(bottom: 3),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Amount",
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: amountController,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 3),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () {
                    selectDate();
                  },
                  controller: dateController,
                ),
              ),
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
                    if (await checkValidation()) {
                      addNewExpense();
                    }
                  },
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }


  Future<void> loadCategory(String type) async {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      showProgressDialog(context);
    });

    //this.categoryListTemp = await DB_Category.instance.readAllData();
    this.categoryListTemp = await DB_Category.instance.getCategoryBasedOnType(type);

    if (categoryListTemp.isEmpty) {
      this.categoryListTemp = [];
      print("Category List is Empty.");

      //dismiss progress dialog
      Navigator.pop(context);
    }
    else {
      for (var category in categoryListTemp) {
        DB_CategoryModel categoryModel = new DB_CategoryModel(
            id: category.id,
            categoryName: category.categoryName,
            categoryType: category.categoryType,
            categoryIcon: category.categoryIcon
        );
        setState(() {
          categoryList.add(categoryModel);
        });
      }

      //dismiss progress dialog
      Navigator.pop(context);

    }

  }


  Future<void> showAlertDialog(BuildContext context, String message) {
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
  }



  Future<bool> checkValidation() async {
    if (nameController.text == "") {
      showAlertDialog(context, "Item ");
      return false;
    }
    if (_selectedCategory == "") {
      showAlertDialog(context, "Category ");
      return false;
    }
    if (amountController.text == "") {
      showAlertDialog(context, "Amount ");
      return false;
    }
    if (dateController.text == "") {
      showAlertDialog(context, "Date ");
      return false;
    }

    return true;
  }

  Future<void> selectDate() async {
    String selectedDate = dateController.text;
    DateTime selectedDateParsed;
    if (selectedDate != "") {
      selectedDateParsed = new DateFormat("dd/MM/yyyy").parse(selectedDate);
      print("selectedDateParsed:: " + selectedDateParsed.toString());
    }
    else {
      selectedDateParsed = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
        context: context,
        //initialDate: DateTime.now(),
        initialDate: selectedDateParsed,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );

    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        dateController.text = formattedDate;
      });
    }
  }

  static String getTodayDate(DateTime date) {
    return (date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString());
    //return DateTime(date.day, date.month, date.year);
  }

  Future addNewExpense() async {
    /*SchedulerBinding.instance!.addPostFrameCallback((_) {
      showProgressDialog(context);
    });*/

    showProgressDialog(context);

    String name = nameController.text;
    double amount = double.parse(amountController.text);
    String category = _selectedCategory;
    String date = dateController.text;
    print("selectedCategory: " + category);


    List<int> splitedDate = date.split('/').map((date) => int.parse(date)).toList();
    print("splitedDate:");
    splitedDate.forEach(print);
    //String date = getTodayDate(DateTime.now());
    //String type = Constants.expenseType;

    DB_RecordDBModel expenseModel = new DB_RecordDBModel(
        name: name,
        category: category,
        amount: amount,
        day: splitedDate[0],
        month: splitedDate[1],
        year: splitedDate[2],
        type: widget.type
    );

    print("Data: " + expenseModel.type);

    try {
      await DB_Record.instance.create(expenseModel);

      //dismiss progress dialog
      Navigator.pop(context);

      //back to homepage
      Navigator.pop(context);

    } catch (e) {
      print(e);

      //dismiss progress dialog
      Navigator.pop(context);
    }
  }


  Future<void> showProgressDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return const ProgressDialog();
        }
    );
  }


}
