import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/AddEditKeycode_Page.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'KeycodeDetails_Page.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails(
      {Key? key,
      required this.categoryModel,
      required this.textColor,
      required this.iconColor,
      required this.shadowColor})
      : super(key: key);

  final Categories? categoryModel;
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;
  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  DBService? dbService;
  Keycode? model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbService = new DBService();
  }

  @override
  Widget build(BuildContext context) {
    var langWords = LangWords();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Detalles categoría: ${widget.categoryModel!.category}',
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
              Container(
                padding: EdgeInsets.all(20),
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      Text('Key'),
                      Text('Value'),
                    ]),
                    TableRow(children: [
                      Text('Id de categoría:'),
                      Text(widget.categoryModel!.id.toString()),
                    ]),
                    TableRow(children: [
                      Text('Etiqueta:'),
                      Text(widget.categoryModel!.category!),
                    ]),
                  ],
                ),
              ),
              Container(
                  //color: Colors.deepPurpleAccent,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<List<Keycode>>(
                    future: dbService!.getKeycodeByCategory(
                        "SELECT * FROM keycodetable WHERE name = '${widget.categoryModel!.category}'"),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Keycode>> snapshot) {
                      var keyCount = dbService!.length;
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Llaves asociadas: $keyCount',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: widget.textColor),
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
                                )),
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
                                                        KeycodeDetails(
                                                          iconColor:
                                                              widget.iconColor,
                                                          textColor:
                                                              widget.textColor,
                                                          shadowColor: widget
                                                              .shadowColor,
                                                          keycodeModel: data,
                                                        )));
                                          },
                                          cells: <DataCell>[
                                            DataCell(Text(data.id.toString())),
                                            DataCell(Text(data.name!)),
                                            DataCell(
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    IconButton(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(Icons.edit),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute<
                                                                int>(
                                                          builder: (BuildContext
                                                              context) {
                                                            return AddEditKeycodePage(
                                                              textColor: widget
                                                                  .textColor,
                                                              iconColor: widget
                                                                  .iconColor,
                                                              shadowColor: widget
                                                                  .shadowColor,
                                                              keycodeModel:
                                                                  data,
                                                              isCreateMode: false,
                                                              isEditMode: true,
                                                              isAutoMode: false,
                                                            );
                                                          },
                                                        )).then((result) {
                                                          if (result != null) {
                                                            setState(() {
                                                              super.widget;
                                                            });
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    IconButton(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(Icons.clear),
                                                      onPressed: () {
                                                        FormHelper.showMessage(
                                                          context,
                                                          "QBayes Step Up!",
                                                          "¿Desea eliminar esta llave?",
                                                          "Si",
                                                          () {
                                                            dbService!
                                                                .deleteKeycode(
                                                                    data)
                                                                .then((value) {
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                            });
                                                          },
                                                          buttonText2: "No",
                                                          isConfirmationDialog:
                                                              true,
                                                          onPressed2: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
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
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NeumorphicFloatingActionButton(
              style: NeumorphicStyle(
                  color: widget.iconColor,
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: widget.textColor,
                  depth: 3,
                  intensity: 3),
              tooltip: langWords.cancel,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Icon(
                  Icons.cancel,
                  color: widget.textColor,
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, 0);
              },
            ),
            NeumorphicFloatingActionButton(
              style: NeumorphicStyle(
                  color: widget.iconColor,
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: widget.textColor,
                  depth: 3,
                  intensity: 3),
              tooltip: langWords.addCategory,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Icon(
                  Icons.add_circle,
                  color: widget.textColor,
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => AddEditKeycodePage(
                              textColor: widget.textColor,
                              iconColor: widget.iconColor,
                              shadowColor: widget.shadowColor,
                              categoryModel: widget.categoryModel,
                              isEditMode: false,
                              isAutoMode: false,
                            )))
                    .then((value) {
                  if (value != null) {
                    super.widget;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
