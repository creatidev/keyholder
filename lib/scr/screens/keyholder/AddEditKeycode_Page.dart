import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/widgets/PasswordField.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class AddEditKeycodePage extends StatefulWidget {
  AddEditKeycodePage(
      {Key? key,
      this.action,
      this.iconColor,
      this.textColor,
      this.shadowColor,
      this.categoryModel,
      this.keycodeModel,
      this.isEditMode,
      required this.isAutoMode,
      this.isCreateMode})
      : super(key: key);
  final int? action;
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;
  final Categories? categoryModel;
  final Keycode? keycodeModel;
  final bool? isCreateMode;
  final bool? isEditMode;
  final bool? isAutoMode;

  @override
  _AddEditKeycodePageState createState() => _AddEditKeycodePageState();
}

class _AddEditKeycodePageState extends State<AddEditKeycodePage> {
  Categories? categoryModel;
  Keycode? keycodeModel;
  DBService? dbService;
  String actualKeycode = '';
  String? actualCategory = 'Sin asignación';
  int _port = 0;
  String? _instance;
  final _formKeyCard = GlobalKey<FormBuilderState>();
  final _keyLabelController = TextEditingController();
  final _keyIpAddressController = TextEditingController();
  final _keyUserNameController = TextEditingController();
  final _keyPassController = TextEditingController();
  final _keyPortController = TextEditingController();
  final _keyInstanceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    dbService = new DBService();
    categoryModel = new Categories();
    keycodeModel = new Keycode();

    if (widget.categoryModel != null) {
      categoryModel = widget.categoryModel;
    }

    if (widget.keycodeModel != null) {
      keycodeModel = widget.keycodeModel;

      print(keycodeModel!.label);
      print('Modo edición: ${widget.isEditMode}');

      if (widget.isCreateMode!) {
        categoryModel!.category = keycodeModel!.name;
      }

      if (widget.isEditMode!) {
        actualKeycode = keycodeModel!.id.toString();
        actualCategory = keycodeModel!.name.toString();
        if (keycodeModel!.name != null) {
          categoryModel!.category = keycodeModel!.name;
        }
        if (keycodeModel!.port != null) {
          _keyPortController.text = keycodeModel!.port.toString();
        }

        if (keycodeModel!.instance != null) {
          _keyInstanceController.text = keycodeModel!.instance!;
        }

        _keyLabelController.text = keycodeModel!.label!;
        _keyIpAddressController.text = keycodeModel!.ip!;
        _keyUserNameController.text = keycodeModel!.user!;
        _keyPassController.text = keycodeModel!.password!;
      }
      if (widget.isAutoMode!) {
        categoryModel!.category = keycodeModel!.name;
        _keyIpAddressController.text = keycodeModel!.ip!;
      }
    }
  }

  @override
  void dispose() {
    _keyLabelController.dispose();
    _keyIpAddressController.dispose();
    _keyUserNameController.dispose();
    _keyPassController.dispose();
    _keyPortController.dispose();
    _keyInstanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var langWords = LangWords();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            //color: Colors.pinkAccent,
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FormBuilder(
                    key: _formKeyCard,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.isEditMode!
                                            ? 'Editar llave: $actualKeycode'
                                            : 'Crear llave: $actualKeycode',
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
                        Divider(),
                        Container(
                          //color: Colors.white70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Categoría actual:'),
                              Text(actualCategory ?? 'Sin asignar',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: widget.textColor)),
                            ],
                          ),
                        ),
                        Divider(),
                        FutureBuilder<List<Categories>>(
                          future: dbService!.getCategory(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Categories>> snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  FormBuilderDropdown<String>(
                                    name: 'category',
                                    initialValue: categoryModel!.category,
                                    decoration: InputDecoration(
                                        labelText: 'Categoría',
                                        prefixIcon: Icon(Icons.vpn_key_outlined,
                                            color: Colors.deepPurpleAccent,
                                            size: 18)),
                                    hint: Text('Seleccionar categoría'),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context,
                                          errorText: langWords.requiredCategory)
                                    ]),
                                    items: snapshot.data!
                                        .map((data) => DropdownMenuItem<String>(
                                              child: Text(
                                                  data.category.toString()),
                                              value: data.category,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      _keyLabelController.text = value!;
                                      actualCategory = value;
                                      keycodeModel!.name = value;
                                      categoryModel!.category = value;
                                    },
                                  ),
                                ],
                              );
                            }
                            return Center(child: Icon(Icons.hourglass_empty));
                          },
                        ),
                        FormBuilderTextField(
                          controller: _keyLabelController,
                          name: "keylabel",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.label,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: langWords.label),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: langWords.requiredField)
                          ]),
                          maxLength: 20,
                          onChanged: (value) {
                            keycodeModel!.label = value;
                          },
                        ),
                        FormBuilderTextField(
                          controller: _keyIpAddressController,
                          name: "keyip",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.web,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: langWords.ip),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: "Este campo no puede estar vacío"),
                            FormBuilderValidators.ip(context,
                                errorText:
                                    "Introduzca una dirección ip válida"),
                          ]),
                          maxLength: 15,
                          onChanged: (value) {
                            keycodeModel!.ip = value;
                          },
                        ),
                        FormBuilderTextField(
                          controller: _keyUserNameController,
                          name: "userName",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.label,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: langWords.userName),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: langWords.requiredField)
                          ]),
                          onChanged: (value) {
                            keycodeModel!.user = value;
                          },
                        ),
                        PasswordField(
                          controller: _keyPassController,
                          //helperText: 'No más de 15 caracteres.',
                          labelText: langWords.hintLoginPassword,
                          onFieldChange: (value) {
                            keycodeModel!.password = value;
                          },
                        ),
                        FormBuilderTextField(
                          controller: _keyPortController,
                          name: "keyPort",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.vpn_lock,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: langWords.port,
                              hintText: 'Opcional'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.numeric(context,
                                errorText:
                                    'Este campo solo admite datos númericos')
                          ]),
                          onChanged: (value) {
                            _port = int.parse(value!);
                            print(value);
                          },
                        ),
                        FormBuilderTextField(
                          controller: _keyInstanceController,
                          name: "keyInstance",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.remove_from_queue_rounded,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: langWords.instance,
                              hintText: 'Opcional'),
                          onChanged: (value) {
                            _instance = value;
                            print(value);
                          },
                        ),
                        Text(widget.action.toString(), style: TextStyle(fontSize: 8),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                Navigator.pop(context);
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
              tooltip: langWords.addkey,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Icon(
                  Icons.add_circle,
                  color: widget.textColor,
                  size: 30,
                ),
              ),
              onPressed: () async {
                var now = DateTime.now();
                keycodeModel!.regDate =
                    DateFormat('yyyy-MM-dd -- hh:mm a').format(now);
                keycodeModel!.name = categoryModel!.category;
                keycodeModel!.port = _port;
                keycodeModel!.instance = _instance;
                keycodeModel!.action = widget.action;
                if (widget.isEditMode!) {
                  dbService!.updateKeycode(keycodeModel!).then((value) {
                    EasyLoading.showInfo('Llave actualizada correctamente',
                        maskType: EasyLoadingMaskType.custom,
                        duration: Duration(milliseconds: 2000));

                    Navigator.pop(context, keycodeModel!.ip);
                  });
                } else {
                  print(keycodeModel!.name);
                  print(keycodeModel!.label);
                  print(keycodeModel!.ip);
                  print(keycodeModel!.user);
                  print(keycodeModel!.password);
                  print(keycodeModel!.port);
                  print(keycodeModel!.instance);
                  print(keycodeModel!.regDate);
                  print(keycodeModel!.action);
                  if (_formKeyCard.currentState!.saveAndValidate()) {
                    dbService!.addKeycode(keycodeModel!).then((value) {
                      EasyLoading.showInfo('Llave registrada correctamente',
                          maskType: EasyLoadingMaskType.custom,
                          duration: Duration(milliseconds: 2000));
                      Navigator.pop(context, keycodeModel!);
                    });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
