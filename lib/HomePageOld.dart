import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:money_management/AddCategoryPage.dart';
import 'package:money_management/CategoryPage.dart';
import 'package:money_management/Class/Expense.dart';
import 'package:money_management/Constants.dart';
import 'package:money_management/DB/DB_Category.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';
import 'package:money_management/DB/DB_Record.dart';
import 'package:money_management/DB/DB_Models/DB_RecordModel.dart';
import 'package:money_management/NewExpensePage.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<RecordModel> recordsListTemp = [];
  late List<RecordModel> recordsList;
  late List<CategoryModel> categoryList;
  List<Expense> expenses = [];

  late Map<String, double> dataMap;

 /* Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 4,
  };*/


  @override
  initState() {
    // TODO: implement initState
    super.initState();


    Future.delayed(Duration.zero,()async{
      recordsList = await DB_Record.instance.readAllData();
      print(recordsList);
    });

    loadRecords();
    //insertList();

    /*if (expenses.isEmpty) {
      Expense newExpense = new Expense("Mixed Rice", "Food", 4, DateTime.now());

      setState(() {
        for (int i = 0; i < 3; i++) {
          expenses.add(newExpense);
        }

      });

      /*dataMap = {
        "Food": 4,
      };*/
    }*/
    /*else {
      dataMap = Map.fromIterable(expenses,
          key: (e) => e.name, value: (e) => e.amount);
    }*/

    //print("dataMap:");
    //print(dataMap);

  }

  /*void asyncMethods() async {
    this.recordsListTemp = await DB_Record.instance.readAllData();

    setState(() {
      this.recordsList = this.recordsListTemp;
    });

    this.categoryList = await DB_Category.instance.readAllData();

    if (recordsList.isEmpty) {
      this.recordsList = [];
    }

    if (categoryList.isEmpty) {
      this.categoryList = [];
      print("Unable to read data in catagory db");
    }


  }*/

  Future loadRecords() async {

    recordsListTemp = await DB_Record.instance.readAllData();

    setState(() {
      recordsList = recordsListTemp;
    });

    return recordsList;
  }


  insertList() async {
    /*for (int i = 0; i < expensesList.length; i++) {


    }*/

    /*for (var eachExpense in recordsList) {
      Expense expense = Expense(
          eachExpense.name ?? "",
          eachExpense.category,
          eachExpense.amount,
          DateTime.parse(eachExpense.date)
      );
      setState(() {
        expenses.add(expense);
      });
    }*/

    /*for (int i = 0; i < 2; i++) {
      expenses.add(Expense("Rice " + i.toString(), "Food " + i.toString(), 3, DateTime.now()));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        backgroundColor: Colors.blue[200],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Categories"),
              onTap: () {
                categoryScreen();
              },
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          //Pie Chart
          /*Container(
            child: Center(
              child: PieChart(dataMap: dataMap),
            ),
          ),*/
          //List View
          Expanded(
            flex: 2,
              child: Container(
                height: 30,
                color: Colors.green,
                //Future Builder
                child: _futureBuilder(),
                /*child: ListView.builder(
                    itemCount: recordsList.length,
                    itemBuilder: _listViewItemBuilder
                ),*/
                /*child: PageView.builder(
                  //itemCount: expenses.length,
                  itemCount: recordsList.length,
                  itemBuilder: _pageViewItemBuilder,
                ),*/
              ),
          ),
          //Spacer(),
          Expanded(
            flex: 1,
              child: Container(
                height: 200,
                color: Colors.yellow,
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        //color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.red,
                              width: 10
                          )
                      ),
                      child: IconButton(
                        icon: Icon(FeatherIcons.minus),
                        iconSize: 60,
                        color: Colors.red,
                        //child: Text("-", style: TextStyle(color: Colors.red, fontSize: 60),),
                        //onPressed: () => {debugPrint('Deduct')},
                        onPressed: () {
                          newExpenseScreen(Constants.expenseType);
                        },
                      ),
                    ),
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        //color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green,
                            width: 10,
                          )
                      ),
                      child: TextButton(
                        child: Text("+", style: TextStyle(color: Colors.green, fontSize: 60),),
                        onPressed: () {
                          newExpenseScreen(Constants.incomeType);
                        },
                      ),
                    ),
                    /*Container(
                  height: 160,1
                  width: 160,
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red,
                      width: 10
                    )
                  ),
                  child: TextButton(
                    child: Text("-", style: TextStyle(color: Colors.red, fontSize: 60),),
                    onPressed: () => {debugPrint('Deduct')},
                  ),
                ),
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    //color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                      width: 10,
                    )
                  ),
                  child: TextButton(
                    child: Text("+", style: TextStyle(color: Colors.green, fontSize: 60),),
                    onPressed: () => {debugPrint('Add')},
                  ),
                ),*/
                  ],
                ),
              ),
          ),

        ],
      ),
    );
  }

  Widget _futureBuilder(){

    return FutureBuilder(
      builder: (context, snapshot) {

        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (ConnectionState.active != null && !snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (ConnectionState.done != null && snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        // IF IT WORKS IT GOES HERE!
        return ListView.builder(
            itemCount: recordsList.length,
            itemBuilder: _listViewItemBuilder
        );
      },
      future: loadRecords(),
    );
  }


  Widget _pageViewItemBuilder(BuildContext context, int index){
    //var expense = expenses[index];
    var record = recordsList[index];
    String? recordName = record.name;
    String recordCategory = record.categoryID.toString();
    double recordAmount = record.amount;

    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child:
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left:6, right: 6, top:6, bottom: 6),
                            child:Text(recordName!,
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: Colors.black, fontSize: 10)),
                          )),
                      // edit button
                      IconButton(
                        icon:  Icon(Icons.edit_outlined),
                        iconSize: 10,
                        color: Colors.blue,
                        onPressed: () {
                          // edit

                        },
                      ),
                      // delete button
                      IconButton(
                        icon:  Icon(Icons.delete_outline),
                        iconSize: 10,
                        color: Colors.red,
                        onPressed: () {
                          // delete item

                        },
                      ),
                    ]),
              ),

            ]
        )
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index){
    var expense = expenses[index];
    String expenseName = expense.name;
    String category = expense.category;
    double amount = expense.amount;

    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child:
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left:6, right: 6, top:6, bottom: 6),
                            child:Text(expenseName,
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: Colors.black, fontSize: 10)),
                          )),
                      // edit button
                      IconButton(
                        icon:  Icon(Icons.edit_outlined),
                        iconSize: 10,
                        color: Colors.blue,
                        onPressed: () {
                          // edit

                        },
                      ),
                      // delete button
                      IconButton(
                        icon:  Icon(Icons.delete_outline),
                        iconSize: 10,
                        color: Colors.red,
                        onPressed: () {
                          // delete item

                        },
                      ),
                    ]),
              ),

            ]
        )
    );
  }



  addExpense() async {
    /*DB_RecordDBModel newExpense = new DB_RecordDBModel(
      category: "",
      amount: 0,
      date: "",
      type: "",
    );

    await DB_Record.instance.create(newExpense);*/
  }

  void newExpenseScreen(String type) {
    Navigator.push(
        context,
      MaterialPageRoute(builder: (context) => NewExpensePage(type: type,))
      //MaterialPageRoute(builder: (context) => AddCategoryPage())
    )
    .then((value){

    });
  }

  void categoryScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoryPage())
    );
  }

}
