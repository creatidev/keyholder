import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/AddEditKeycode_Page.dart';
import 'package:digitalkeyholder/scr/services/MainNotifier.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:provider/provider.dart';
import 'KeycodeDetails_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class RegisteredKeycodesPage extends StatefulWidget {
  const RegisteredKeycodesPage(
      {Key? key,
      required this.iconColor,
      required this.textColor,
      required this.shadowColor,
      this.keyringModel})
      : super(key: key);
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;
  final Categories? keyringModel;
  @override
  _RegisteredKeycodesPageState createState() => _RegisteredKeycodesPageState();
}

class _RegisteredKeycodesPageState extends State<RegisteredKeycodesPage> {
  var textController = TextEditingController();
  var langWords = LangWords();
  int currentIndex = 0;
  bool isEditMode = false;
  bool isSaveLabel = false;
  DBService? dbService;
  Keycode? keycodeModel;
  var visibleText = true;
  int keyCount = 0;

  Future<List<Keycode>> getRegisteredKeys() async {
    final counter = Provider.of<CounterProvider>(context);

    var data = dbService!.getKeycodes();
    await data.then((value) {
      setState(() => keyCount = value.length);
      counter.onChange(keyCount);
    });
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbService = new DBService();
    keycodeModel = new Keycode();
  }

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<CounterProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                              Icon(Icons.vpn_key),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Llaves registradas: ${counter.counter}',
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
                FutureBuilder<List<Keycode>>(
                  future: getRegisteredKeys(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Keycode>> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                                        textColor:
                                                            widget.textColor,
                                                        iconColor:
                                                            widget.iconColor,
                                                        shadowColor:
                                                            widget.shadowColor,
                                                        keycodeModel: data,
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
                                              data.label!,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  new IconButton(
                                                    padding: EdgeInsets.all(0),
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      keycodeModel!.id =
                                                          data.id;

                                                      Navigator.push(context,
                                                          MaterialPageRoute<
                                                              String>(
                                                        builder: (BuildContext
                                                            context) {
                                                          return AddEditKeycodePage(
                                                            textColor: widget
                                                                .textColor,
                                                            iconColor: widget
                                                                .iconColor,
                                                            shadowColor: widget
                                                                .shadowColor,
                                                            keycodeModel: data,
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
                                                  new IconButton(
                                                    padding: EdgeInsets.all(0),
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
                                                          Navigator.of(context)
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
