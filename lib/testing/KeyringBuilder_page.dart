import 'dart:convert';
import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/Progress.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/AddEditKeycode_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/KeycodeDetails_Page.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class KeyringBuilder extends StatefulWidget {
  const KeyringBuilder({
    Key? key,
    required this.borderColor,
    this.textColor,
    this.iconColor,
    this.shadowColor,
    this.isAutoMode,
    this.mapedCategories,
    required this.keyringIndex,
    required this.client,
  }) : super(key: key);
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;
  final int? keyringIndex;
  final String? client;
  final mapedCategories;
  final bool? isAutoMode;
  @override
  _KeyringBuilderState createState() => _KeyringBuilderState();
}

class _KeyringBuilderState extends State<KeyringBuilder> {
  DBService? dbService;
  Categories? categoryModel;
  int? keyCount;
  String? getKeys;
  String? getCategory;
  bool isApiCallProcess = false;
  final prefs = new UserPreferences();
  String _title = 'Preparando llavero...';
  var _found = 0;
  var _notFound = 0;
  var _actionId;
  bool _status = true;
  bool _success = false;
  Categories? _categoriesFromJson;
  Categories? _categoriesToJson;
  String? _jsonCategories;
  List<Keycode>? _foundCategories;
  List<Keycode>? _requestCategories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Iniciar Keyring');
    categoryModel = new Categories();
    dbService = new DBService();
    _foundCategories = <Keycode>[];
    if (widget.mapedCategories != null) {
      print(widget.mapedCategories);
      _categoriesFromJson = new Categories.fromJson(widget.mapedCategories);
    }
    if (widget.isAutoMode == true) {
      setJson(_categoriesFromJson!);
    }
  }

  Keycode keyNotFound(String name, String ip) {
    return Keycode(
      label: 'No disponible',
      name: name,
      ip: ip,
      user: '',
      password: '',
      regDate: '0',
    );
  }

  Future cancelOperation(Categories categories) async {}

  Future setJson(Categories categories) async {
    _actionId = categories.actionId;
    var index = 0;
    _notFound = 0;
    _requestCategories = categories.categories;
    print('Llaves solicitadas: ${categories.categories!.length}');
    _title = 'Llaves solicitadas: ${categories.categories!.length}';
    EasyLoading.show(
        status: 'Buscando las llaves...', maskType: EasyLoadingMaskType.custom);

    for (final value in _requestCategories!) {
      var selectedValue = value;
      await Future.delayed(Duration(milliseconds: 1000));
      getCategory = "SELECT * FROM categorytable WHERE category = "
          "'${selectedValue.name}'";

      await dbService!.getKeycodeByCategory(getCategory).then((value) {
        if (value.length == 0) {
          categoryModel!.category = selectedValue.name;
          dbService!.addCategory(categoryModel!);
        }
      });
      print(_actionId);
      getKeys = "SELECT * FROM keycodetable WHERE name ="
          " '${value.name}' AND ip = '${value.ip}'";
      await dbService!.getKeycodeByCategory(getKeys).then((value) {
        //print(_requestCategories![index].name!);

        if (value.length == 1) {
          _found++;

          print('Nombre llave encontrada: ${value.first.name}');
          print('Llaves ingresada: ${value.first.name}');
          setState(() => _foundCategories!.add(value.first));
        } else {
          _notFound++;
          setState(() => _foundCategories!.add(keyNotFound(
              _requestCategories![index].name!,
              _requestCategories![index].ip!)));
          print('Llave no encontrada: ${_requestCategories!.first.name}');
        }
        index++;
      });
    }

    if (_notFound > 0) {
      _title = 'Llaves faltantes...';
      EasyLoading.showError('Por favor registre las llaves faltantes',
          maskType: EasyLoadingMaskType.custom,
          duration: Duration(milliseconds: 2000));
    }

    if (_notFound == 0) {
      _title = 'Llavero pendiente por envío...';
      _success = true;
      _status = true;
      _categoriesToJson = new Categories(
          actionId: _actionId, status: _status, categories: _foundCategories);
      print('Llaves ingresadas $_found');
      _jsonCategories = jsonEncode(_categoriesToJson);
      print('Llavero disponible');
    }

    print(_jsonCategories);
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressIndication(
      child: uiBuild(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget uiBuild(BuildContext context) {
    final request = Provider.of<APIService>(context);
    var langWords = LangWords();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //color: Colors.lightBlueAccent,
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
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
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _title,
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
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                //color: Colors.lightBlueAccent,
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: _foundCategories!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _keycodeView(_foundCategories!, index);
                    }),
              ),
              Container(
                padding: EdgeInsets.all(10),
                //color: Colors.grey,
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                child: Table(
                  border: TableBorder.all(color: widget.borderColor!),
                  columnWidths: {
                    0: FlexColumnWidth(50),
                    1: FlexColumnWidth(50)
                  },
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Id de la acción',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: widget.textColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${_categoriesFromJson!.actionId}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Cliente',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: widget.textColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.client}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Llaves solicitadas',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${_categoriesFromJson!.categories!.length}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Llaves encontradas',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$_found',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              )
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
                  shadowLightColor: widget.shadowColor,
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
                Navigator.of(context).pop();
              },
            ),
            NeumorphicFloatingActionButton(
              style: NeumorphicStyle(
                  color: widget.iconColor,
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: widget.shadowColor,
                  depth: 3,
                  intensity: 3),
              tooltip: 'Enviar llavero',
              child: Container(
                margin: EdgeInsets.all(2),
                child: _success == true
                    ? Icon(
                        Icons.skip_next,
                        color: Colors.green,
                        size: 30,
                      )
                    : Icon(
                        Icons.search,
                        color: Colors.green,
                        size: 30,
                      ),
              ),
              onPressed: () {
                if (_success == true) {
                  EasyLoading.show(
                    status: 'Enviando llavero...',
                    maskType: EasyLoadingMaskType.custom,
                  );
                  APIService apiService = new APIService();
                  apiService.sendData(_jsonCategories!).then((value) {
                    request.selectedStatus = "2";
                    EasyLoading.showSuccess(
                        'Llavero enviado con éxito al Id: $_actionId',
                        maskType: EasyLoadingMaskType.custom);
                    final snackBar = SnackBar(content: Text(value.message!));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _success = false;
                      _jsonCategories = null;
                      Navigator.pop(context, 0);
                    });
                  });
                } else {
                  _found = 0;
                  _foundCategories!.clear();
                  setJson(_categoriesFromJson!);
                }
                //getDataFromFakeServer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Card _keycodeView(List<Keycode> keycodes, int index) {
    return Card(
      child: ListTile(
        title: Text(keycodes[index].label!),
        subtitle: Text(keycodes[index].name!),
        leading: Icon(
          Icons.vpn_key,
          size: 30,
        ),
        trailing: keycodes[index].user == ''
            ? Icon(
                Icons.turned_in_not,
                color: Colors.redAccent,
              )
            : Icon(
                Icons.turned_in,
                color: Colors.green,
              ),
        onTap: () {
          if (keycodes[index].user == '') {
            Navigator.push(context, MaterialPageRoute<Keycode>(
              builder: (BuildContext context) {
                return AddEditKeycodePage(
                  textColor: widget.textColor,
                  iconColor: widget.iconColor,
                  shadowColor: widget.shadowColor,
                  keycodeModel: keycodes[index],
                  action: _categoriesFromJson!.actionId,
                  isCreateMode: true,
                  isEditMode: false,
                  isAutoMode: true,
                );
              },
            )).then((result) {
              if (result != null) {
                keycodes[index].user = 'Añadida';
                keycodes[index].ip = result.ip;
                keycodes[index].label = 'Disponible';

                setState(() =>
                    _categoriesFromJson!.categories![index].ip = result.ip!);

                print('Retorna ${result.ip}');
              }else{
                print('Sin editar');
              }
            });
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => KeycodeDetails(
                      textColor: widget.textColor,
                      iconColor: widget.iconColor,
                      shadowColor: widget.shadowColor,
                      keycodeModel: keycodes[index],
                    )));
          }
        },
      ),
    );
  }
}
