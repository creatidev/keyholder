import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/add_edit_keycode_page.dart';
import 'package:digitalkeyholder/scr/services/theme_notifier.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:provider/provider.dart';
import 'keycode_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class RegisteredKeycodesPage extends StatefulWidget {
  const RegisteredKeycodesPage(
      {Key? key,
      required this.iconsColor,
      required this.textColor,
      required this.shadowColor,
      this.keyringModel})
      : super(key: key);
  final Color? textColor;
  final Color? iconsColor;
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
  final prefs = new UserPreferences();

  Future<List<Keycode>> getRegisteredKeys() async {
    final counter = Provider.of<CounterProvider>(context);

    var data = dbService!.getKeycodes();
    await data.then((value) {
      keyCount = value.length;
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                                  color: widget.iconsColor),
                            )),
                            DataColumn(
                              label: Text(
                                "Etiqueta",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: widget.iconsColor),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Acciones",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: widget.iconsColor),
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
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: widget.iconsColor,
                                                  ),
                                                  onPressed: () {
                                                    if (prefs.showPassword ==
                                                        true) {
                                                      keycodeModel!.id =
                                                          data.id;

                                                      Navigator.push(context,
                                                          MaterialPageRoute<
                                                              Keycode>(
                                                        builder: (BuildContext
                                                            context) {
                                                          return AddEditKeycodePage(
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
                                                    } else {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  KeycodeDetails(
                                                                    keycodeModel:
                                                                        data,
                                                                  )));
                                                    }
                                                  },
                                                ),
                                                new IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  icon: Icon(
                                                    Icons.clear,
                                                    color: widget.iconsColor,
                                                  ),
                                                  onPressed: () {
                                                    FormHelper.showMessage(
                                                      context,
                                                      "QBayes NOC",
                                                      "¿Desea eliminar esta llave?",
                                                      "Si",
                                                      () {
                                                        dbService!
                                                            .deleteKeycode(data)
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
    );
  }
}
