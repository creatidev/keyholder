import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'CategoryDetails_Page.dart';

class RegisteredCategoriesPage extends StatefulWidget {
  const RegisteredCategoriesPage(
      {Key? key,
      required this.iconColor,
      required this.textColor,
      required this.shadowColor})
      : super(key: key);
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;

  @override
  _RegisteredCategoriesPageState createState() => _RegisteredCategoriesPageState();
}

class _RegisteredCategoriesPageState extends State<RegisteredCategoriesPage> {
  var textController = TextEditingController();
  LangWords? langWords;
  int currentIndex = 0;
  bool isEditMode = false;
  bool isSaveLabel = false;
  DBService? dbService;
  Categories? categoryModel;
  int categoryCount = 0;


  Future<List<Categories>> getRegisteredCategories() async {
    var data = dbService!.getCategory();
    await data.then((value) {
      categoryCount = value.length;
    });
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbService = new DBService();
    categoryModel = new Categories();
  }

  @override
  Widget build(BuildContext context) {
    langWords = LangWords();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: FutureBuilder<List<Categories>>(
            future: getRegisteredCategories(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Categories>> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.97,
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(5),
                                1: FlexColumnWidth(90)
                              },
                              children: [
                                TableRow(children: [
                                  Icon(Icons.label),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Categorías registradas: $categoryCount',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              color: widget.textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                          label: Text(
                            "ID",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Etiqueta",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Acciones",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: widget.textColor),
                          ),
                        ),
                      ],
                      sortColumnIndex: 1,
                      rows: snapshot.data!
                          .map((data) => DataRow(
                                  onSelectChanged: (value) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryDetails(
                                                  textColor: widget.textColor,
                                                  iconColor: widget.iconColor,
                                                  shadowColor:
                                                      widget.shadowColor,
                                                  categoryModel: data,
                                                )));
                                  },
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(
                                        data.id.toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        data.category!,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            IconButton(
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                FormHelper.showMessage(
                                                  context,
                                                  "QBayes Step Up!",
                                                  "¿Desea eliminar esta categoría?",
                                                  "Si",
                                                  () {
                                                    dbService!
                                                        .deleteCategory(data)
                                                        .then((value) {
                                                      setState(() {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    });
                                                  },
                                                  buttonText2: "No",
                                                  isConfirmationDialog: true,
                                                  onPressed2: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]))
                          .toList(),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          )),
        ),
      ),
    );
  }
}
