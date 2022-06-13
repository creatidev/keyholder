import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/add_edit_keycode_page.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'keycode_details_page.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({
    Key? key,
    required this.categoryModel,
  }) : super(key: key);

  final Categories? categoryModel;
  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  DBService? dbService;
  Keycode? model;
  final prefs = new UserPreferences();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbService = new DBService();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors _colors = new CustomColors();
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
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.97,
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(5),
                          1: FlexColumnWidth(90)
                        },
                        children: [
                          TableRow(children: [
                            Icon(
                              Icons.label,
                              color: _colors.iconsColor(context),
                            ),
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
                                        color: _colors.textColor(context)),
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
                  border: TableBorder.all(color: Colors.black12),
                  children: [
                    /*TableRow(children: [
                      Text('Key'),
                      Text('Value'),
                    ]),*/
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
                  height: MediaQuery.of(context).size.height * 0.80,
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
                                        color: _colors.iconsColor(context)),
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
                                      color: _colors.iconsColor(context)),
                                )),
                                DataColumn(
                                  label: Text(
                                    "Etiqueta",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: _colors.iconsColor(context)),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Acciones",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: _colors.iconsColor(context)),
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
                                                          keycodeModel: data,
                                                        )));
                                          },
                                          cells: <DataCell>[
                                            DataCell(Text(data.id.toString())),
                                            DataCell(Text(data.label!)),
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
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color:
                                                            _colors.iconsColor(
                                                                context),
                                                      ),
                                                      onPressed: () {
                                                        if (prefs
                                                                .showPassword ==
                                                            true) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  int>(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AddEditKeycodePage(
                                                                keycodeModel:
                                                                    data,
                                                                isCreateMode:
                                                                    false,
                                                                isEditMode:
                                                                    true,
                                                                isAutoMode:
                                                                    false,
                                                              );
                                                            },
                                                          )).then((result) {
                                                            if (result !=
                                                                null) {
                                                              setState(() {
                                                                super.widget;
                                                              });
                                                            }
                                                          });
                                                        } else {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          KeycodeDetails(
                                                                            keycodeModel:
                                                                                data,
                                                                          )));
                                                        }
                                                      },
                                                    ),
                                                    IconButton(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(
                                                        Icons.clear,
                                                        color:
                                                            _colors.iconsColor(
                                                                context),
                                                      ),
                                                      onPressed: () {
                                                        FormHelper.showMessage(
                                                          context,
                                                          "QBayes NOC",
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
                  color: _colors.contextColor(context),
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: _colors.shadowColor(context),
                  depth: 2,
                  intensity: 1),
              tooltip: langWords.cancel,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Icon(
                  Icons.cancel,
                  color: _colors.iconsColor(context),
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, 0);
              },
            ),
            NeumorphicFloatingActionButton(
              style: NeumorphicStyle(
                  color: _colors.contextColor(context),
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: _colors.shadowColor(context),
                  depth: 2,
                  intensity: 1),
              tooltip: langWords.addCategory,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Icon(
                  Icons.add_circle,
                  color: _colors.iconsColor(context),
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => AddEditKeycodePage(
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
