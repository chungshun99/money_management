import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:money_management/AddCategoryForm.dart';
import 'package:money_management/AddCategoryPage.dart';
import 'package:money_management/Class/Category.dart';
import 'package:money_management/Constants.dart';
import 'package:money_management/DB/DB_Category.dart';
import 'package:money_management/DB/DB_Models/DB_CategoryModel.dart';
import 'package:money_management/DB/DatabaseHelper.dart';
import 'package:money_management/ErrorDialog.dart';
import 'package:money_management/ProgressDialog.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  //List<Category> categories = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  List<Category> categories = [Category("categoryName", "color", "categoryIcon"), Category("categoryName2", "color2", "categoryIcon2")];
  late List<CategoryModel> categoryListTemp;
  List<CategoryModel> categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    /*SchedulerBinding.instance!.addPostFrameCallback((_) {
      showProgressDialog(context);
    });*/


    loadCategory();

    //dismiss progress dialog
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: Colors.blue[200],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => addCategoryPage(),
          )
        ],
      ),
      //Floating Button
      /*floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.lightGreenAccent,
          foregroundColor: Colors.black,
          onPressed: () {
            addCategoryPage();
          },
          child: const Icon(Icons.add)
      ),*/
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          strokeWidth: 2.5,
          //color: Colors.red,
          //backgroundColor: Colors.green,
          onRefresh: loadCategory,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: _listViewItemBuilder
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index){
    var category = categoryList[index];
    int id = category.id!;
    String categoryName = category.categoryName;
    String categoryType = category.categoryType;
    String categoryIcon = category.categoryIcon;
    var categoryIconData = Constants.icons[categoryIcon];

    return Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(category.categoryName),
        onDismissed: (direction) {
          setState(() {
            categories.removeAt(index);
          });
        },
        child: Card(
            margin: const EdgeInsets.only(left:6,right: 6,top: 10,bottom: 1),
            color: (categoryType == Constants.incomeType) ? Colors.greenAccent : Colors.yellow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 50,
                            height: 70,
                            child: Icon(
                              categoryIconData,
                              size: 30,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2,right: 3,top: 3,bottom: 3),
                                child:Text(categoryName,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                              )),
                          //update button
                          IconButton(
                            icon: const Icon(Icons.edit_note),
                            iconSize: 24,
                            color: Colors.blueAccent,
                            onPressed: () {
                              //update category
                              updateCategoryPage(id, categoryName, categoryType, categoryIcon);
                              //updateCategory(id, categoryName, categoryType);
                            },
                          ),
                          //Delete Button
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            iconSize: 24,
                            color: Colors.red,
                            onPressed: () {
                              //delete category
                              deleteCategory(id, categoryName, categoryType);
                            },
                          ),
                        ]),
                  ),
                ]
            )
        ),
    );


    /*return Container(
        child: Card(
            margin: const EdgeInsets.only(left:6,right: 6,top: 10,bottom: 1),
            color: Colors.cyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13)
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            width: 30,
                            height:  70,
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 40,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3,right: 3,top: 3,bottom: 3),
                                child:Text(categoryName,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                              )),
                          // edit button
                          IconButton(
                            icon:  Icon(Icons.read_more),
                            iconSize: 24,
                            color: Colors.blue,
                            onPressed: () {
                              // move to item list
                              //_ItemsScreen(cycleCountDtl, Constants.MODE_MANUAL);
                            },
                          ),
                          IconButton(
                            icon:  Icon(Icons.read_more),
                            iconSize: 24,
                            color: Colors.red,
                            onPressed: () {
                              // move to item list
                              //_ItemsScreen(cycleCountDtl, Constants.MODE_MANUAL);
                            },
                          ),
                          *//*Visibility(
                            child:
                            IconButton(
                              icon:  Icon(Icons.read_more),
                              iconSize: 24,
                              color: Colors.blue,
                              onPressed: () {
                                // move to item list
                                //_ItemsScreen(cycleCountDtl, Constants.MODE_MANUAL);
                              },
                            ),
                          ),*//*
                        ]),
                  ),
                ]
            )
        )
    );*/
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


  Future<void> loadCategory() async {

    /*SchedulerBinding.instance!.addPostFrameCallback((_) {
      showProgressDialog(context);
    });*/

    //showProgressDialog(context);

    categoryList = [];
    this.categoryListTemp = await DatabaseHelper.instance.readAllCategory();

    if (categoryListTemp.isEmpty) {
      this.categoryListTemp = [];
      print("Category List is Empty.");

      //dismiss progress dialog
      Navigator.pop(context);
    }
    else {
      for (var category in categoryListTemp) {
        CategoryModel categoryModel = new CategoryModel(
            id: category.id,
            categoryName: category.categoryName,
            categoryType: category.categoryType,
            categoryIcon: category.categoryIcon
        );
        setState(() {
          categoryList.add(categoryModel);
        });
      }

      // dismiss progress dialog
      //Navigator.pop(context);
    }
  }

  /*addCategoryPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddCategoryPage())
    );
  }*/

  /*Future<void> showCustomDialog(BuildContext context, String message) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return CustomDialog(title:Constants.info, desc: message,
              tvBtnYes:Constants.ok, tvBtnNo: '');
        }
    );
  }*/

  addCategoryPage() {
    return showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          //return ErrorDialog(errorText: Constants.errorDatabaseCreate);
          return AddCategoryForm(action: Constants.actionCreate);
        }
    ).then((value) {
      loadCategory();
    });
  }

  updateCategoryPage(int id, String categoryName, String categoryType, String categoryIcon) {
    CategoryModel categoryModel = CategoryModel(
        id: id,
        categoryName: categoryName,
        categoryIcon: categoryIcon,
        categoryType: categoryType
    );

    return showDialog(
      //barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AddCategoryForm(action: Constants.actionUpdate, categoryModel: categoryModel);
        }
    ).then((value) {
      //showProgressDialog(context);
      loadCategory();

      // dismiss progress dialog
      //Navigator.pop(context);

    });
  }

  Future<void> deleteCategory(int id, String categoryName, String categoryType) async {
    try {
      await DatabaseHelper.instance.deleteCategory(id, categoryName, categoryType);
      await loadCategory();

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

}
