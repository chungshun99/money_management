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
import 'package:money_management/ErrorDialog.dart';
import 'package:money_management/NewExpensePage.dart';
import 'package:money_management/UpdateRecordPage.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<DB_RecordDBModel> recordsListTemp = [];
  //late List<DB_RecordDBModel> recordsList;
  List<DB_RecordDBModel> recordsList = [];
  late List<DB_CategoryModel> categoryList;
  //List<Expense> expenses = [];
  List<DB_RecordDBModel> expenses = [];

  late Map<String, double> dataMap;

  String sortBy = Constants.sortDay;

 /* Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 4,
  };*/


  @override
  initState() {
    // TODO: implement initState
    super.initState();

    //loadRecords();

  }

  Future<List<DB_RecordDBModel>> loadRecords() async {
    var testRecords = await DB_Record.instance.readAllData();

    List<DB_RecordDBModel> testRecordsList = [];

    for(var records in testRecords) {
      DB_RecordDBModel recordRead = DB_RecordDBModel(
          id: records.id,
          name: records.name,
          category: records.category,
          amount: records.amount,
          day: records.day,
          month: records.month,
          year: records.year,
          type: records.type
      );

      testRecordsList.add(recordRead);
    }

    return testRecordsList;
  }

  Future<List<DB_RecordFilterModel>> loadRecords2(String sort) async {
    var testRecords = await DB_Record.instance.getFilteredTotalRecord(sort);

    List<DB_RecordFilterModel> testRecordsList = [];

    for(var records in testRecords) {
      DB_RecordFilterModel recordRead = DB_RecordFilterModel(
          numberOfRecords: records.numberOfRecords,
          day: records.day,
          month: records.month,
          year: records.year
      );

      testRecordsList.add(recordRead);
    }

    return testRecordsList;
  }

  Future<List<DB_RecordDBModel>> loadRecords3(int day, int month, int year) async {
    var testRecords = await DB_Record.instance.getFilteredRecordsList(sortBy, day, month, year);

    List<DB_RecordDBModel> testRecordsList = [];

    for(var records in testRecords) {
      DB_RecordDBModel recordRead = DB_RecordDBModel(
          id: records.id,
          name: records.name,
          category: records.category,
          amount: records.amount,
          day: records.day,
          month: records.month,
          year: records.year,
          type: records.type
      );

      testRecordsList.add(recordRead);
    }

    return testRecordsList;
  }


  /*Future loadRecords() async {

    recordsListTemp = await DB_Record.instance.readAllData();

    setState(() {
      recordsList = recordsListTemp;
    });

    return recordsList;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        backgroundColor: Colors.blue[200],
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.sort),
              itemBuilder: (context){
                return [
                  const PopupMenuItem<String>(
                    value: Constants.sortDay,
                    child: Text(Constants.sortDay),
                  ),
                  const PopupMenuItem<String>(
                    value: Constants.sortMonth,
                    child: Text(Constants.sortMonth),
                  ),
                  const PopupMenuItem<String>(
                    value: Constants.sortYear,
                    child: Text(Constants.sortYear),
                  ),
                ];
              },
              onSelected:(value){
                if(value == Constants.sortDay) {
                  setState(() {
                    sortBy = Constants.sortDay;
                  });
                } else if(value == Constants.sortMonth) {
                  setState(() {
                    sortBy = Constants.sortMonth;
                  });
                } else if(value == Constants.sortYear) {
                  setState(() {
                    sortBy = Constants.sortYear;
                  });
                }

              }
          ),
        ],
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
                //color: Colors.green,
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
      future: loadRecords2(sortBy),
      //future: loadRecords(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //print("SNAPSHOT DATA:: " + snapshot.data);
        if(snapshot.hasData){
          //return createListView(context, snapshot);
          return createPageView(context, snapshot);
        } else {
          return const Center(
              child: Text("Loading...")
          );
        }

        // IF IT WORKS IT GOES HERE!
        /*return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: _listViewItemBuilder
        );*/

      },
    );
  }

  Widget _futureBuilder2(int day, int month, int year){
    return FutureBuilder(
      future: loadRecords3(day, month, year),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //print("SNAPSHOT DATA:: " + snapshot.data);
        if(snapshot.hasData){
          return createExpandableTile(context, snapshot);
          //return createListView(context, snapshot);
          //return createPageView(context, snapshot);
        } else {
          return const Center(
              child: Text("Loading...")
          );
        }

        // IF IT WORKS IT GOES HERE!
        /*return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: _listViewItemBuilder
        );*/

      },
    );
  }

  Widget createPageView(BuildContext context, AsyncSnapshot snapshot){
    List<DB_RecordFilterModel> values = snapshot.data;

    return PageView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {

        var expense = snapshot.data[index];
        int day = expense.day;
        int month = expense.month;
        int year = expense.year;
        //var recordsList = loadRecords3();

        //return createListView(context, expense);

        return Container(
          height: 30,
          //color: Colors.green,
          //Future Builder
          child: _futureBuilder2(day, month, year),
        );


      },
    );
  }

  /*Widget createPageView(BuildContext context, AsyncSnapshot snapshot){
    List<DB_RecordDBModel> values = snapshot.data;

    return PageView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        //var expense = expenses[index];
        var expense = snapshot.data[index];
        int id = expense.id!;
        String? expenseName = expense.name;
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
                                child:Text(expenseName!,
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
                              updateRecordScreen(expense);
                            },
                          ),
                          // delete button
                          IconButton(
                            icon:  Icon(Icons.delete_outline),
                            iconSize: 10,
                            color: Colors.red,
                            onPressed: () {
                              // delete item
                              deleteRecord(id);
                            },
                          ),
                        ]),
                  ),

                ]
            )
        );
      },
    );
  }*/

  Widget _pageViewItemBuilder(BuildContext context, int index){
    //var expense = expenses[index];
    var record = recordsList[index];
    String? recordName = record.name;
    String recordCategory = record.category;
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


  /*Widget _pageViewItemBuilder(BuildContext context, int index){
    //var expense = expenses[index];
    var record = recordsList[index];
    String? recordName = record.name;
    String recordCategory = record.category;
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
  }*/


  Widget createExpandableTile(BuildContext context, AsyncSnapshot snapshot){
    List<DB_RecordDBModel> values = snapshot.data;

    //to get all the categories in the record
    List<String> categories = values.map((records) => records.category).toList();

    //to remove duplicated values
    categories = categories.toSet().toList();

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        //var expense = expenses[index];
        String category = categories[index];

        return ExpansionTile(
          title: Text(category, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          children: [
              createListView(context, snapshot)
            /*SizedBox(
              height: 400,
              child: createListView(context, snapshot),
            )*/
          ],
          /*children: <Widget>[
            Column(
              children: createListView(context, snapshot),
            ),
          ],*/
        );
      },
    );
  }


  Widget createListView(BuildContext context, AsyncSnapshot snapshot){
    List<DB_RecordDBModel> values = snapshot.data;

    final List<String> categories = values.map((records) => records.category).toList();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        //var expense = expenses[index];
        var expense = snapshot.data[index];
        int id = expense.id!;
        String? expenseName = expense.name;
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
                                child:Text(expenseName!,
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
                              updateRecordScreen(expense);
                            },
                          ),
                          // delete button
                          IconButton(
                            icon:  Icon(Icons.delete_outline),
                            iconSize: 10,
                            color: Colors.red,
                            onPressed: () {
                              // delete item
                              deleteRecord(id);
                            },
                          ),
                        ]),
                  ),

                ]
            )
        );
      },
    );
  }


  Widget _listViewItemBuilder(BuildContext context, int index){
    var expense = expenses[index];
    String? expenseName = expense.name;
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
                            child:Text(expenseName!,
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

  sortingRecords(String sort) {
    if(sort == Constants.sortDay){
      setState(() {

      });
      sortBy = Constants.sortDay;
      print("My account menu is selected.");
    }else if(sort == Constants.sortMonth){
      print("Settings menu is selected.");
    }else if(sort == Constants.sortYear){
      print("Logout menu is selected.");
    }
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

  Future<void> deleteRecord(int id) async {
    try {
      await DB_Record.instance.delete(id);

      //using setState to force refresh the widgets
      setState(() { });
      //  await loadRecords();
    }
    catch (e) {
      showErrorDialog(context, Constants.errorDatabaseDelete);
      print(e);
    }
  }

  Future<void> showErrorDialog(BuildContext context, String message) {
    return showDialog(
      //barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return ErrorDialog(errorText: message);

        }
    );
  }



  void newExpenseScreen(String type) {
    Navigator.push(
        context,
      MaterialPageRoute(builder: (context) => NewExpensePage(type: type,))
      //MaterialPageRoute(builder: (context) => AddCategoryPage())
    )
    .then((value){
      //using setState to force refresh the widgets
      setState(() { });
    });
  }


  void updateRecordScreen(DB_RecordDBModel recordModel) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateRecordPage(recordModel: recordModel,))
    )
    .then((value){
      //using setState to force refresh the widgets
      setState(() { });
    });
  }


  void categoryScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoryPage())
    );
  }

}
