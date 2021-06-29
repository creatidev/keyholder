import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/AddEditKeycode_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:scratcher/scratcher.dart';

class KeycodeDetails extends StatefulWidget {
  const KeycodeDetails({
    Key? key,
    required this.keycodeModel,
  }) : super(key: key);

  final Keycode? keycodeModel;
  @override
  _KeycodeDetailsState createState() => _KeycodeDetailsState();
}

class _KeycodeDetailsState extends State<KeycodeDetails> {
  CustomColors _colors = new CustomColors();
  bool _isEdited = false;
  bool _obscure = false;
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
                            Icon(Icons.vpn_key),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Detalles: ${widget.keycodeModel!.label}',
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
                      Text('Id de llave :'),
                      Text(widget.keycodeModel!.id.toString()),
                    ]),
                    TableRow(children: [
                      Text('Categoría :'),
                      Text(widget.keycodeModel!.name.toString()),
                    ]),
                    TableRow(children: [
                      Text('Etiqueta :'),
                      Text(widget.keycodeModel!.label!),
                    ]),
                    TableRow(children: [
                      Text('Dirección IP :'),
                      Text(widget.keycodeModel!.ip!),
                    ]),
                    TableRow(children: [
                      Text('Usuario :'),
                      Text(
                        widget.keycodeModel!.user!,
                        style: TextStyle(color: _colors.iconsColor(context)),
                      ),
                    ]),
                    TableRow(children: [
                      Text('Contraseña :'),
                      Text(
                        widget.keycodeModel!.password!,
                        style: TextStyle(color: _colors.iconsColor(context)),
                      ),
                    ]),
                    TableRow(children: [
                      Text('Puerto :'),
                      Text(widget.keycodeModel!.port.toString()),
                    ]),
                    TableRow(children: [
                      Text('Instancia :'),
                      Text(
                        widget.keycodeModel!.instance.toString(),
                      ),
                    ]),
                    TableRow(children: [
                      Text('Fecha de creación :'),
                      Text(widget.keycodeModel!.regDate!),
                    ]),
                    TableRow(children: [
                      Text('Acción :'),
                      Text(widget.keycodeModel!.action.toString()),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NeumorphicButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    tooltip: langWords.showPassword,
                    style: NeumorphicStyle(
                        color: _colors.contextColor(context),
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                        shadowLightColor: _colors.iconsColor(context),
                        depth: 2,
                        intensity: 1),
                    padding: const EdgeInsets.all(7.0),
                    child: _obscure
                        ? Icon(
                            Icons.remove_red_eye_outlined,
                            color: _colors.textColor(context),
                            size: 25,
                          )
                        : Icon(
                            Icons.remove_red_eye_rounded,
                            color: _colors.textColor(context),
                            size: 25,
                          ),
                  ),
                  NeumorphicButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute<Keycode>(
                        builder: (BuildContext context) {
                          return AddEditKeycodePage(
                            keycodeModel: widget.keycodeModel,
                            isCreateMode: false,
                            isEditMode: true,
                            isAutoMode: false,
                          );
                        },
                      )).then((result) {
                        if (result != null) {
                          setState(() {
                            _isEdited = true;
                            super.widget;
                          });
                        }
                      });
                    },
                    tooltip: langWords.save,
                    style: NeumorphicStyle(
                        color: _colors.contextColor(context),
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                        shadowLightColor: _colors.shadowColor(context),
                        depth: 2,
                        intensity: 1),
                    padding: const EdgeInsets.all(7.0),
                    child: Icon(
                      Icons.edit,
                      color: _colors.textColor(context),
                      size: 25,
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: _obscure,
                      child: Scratcher(
                        color: _colors.iconsColor(context),
                        child: Container(
                          //color: Colors.black,
                          height: 80,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.keycodeModel!.user!,
                                style: TextStyle(
                                    color: _colors.textColor(context)),
                              ),
                              Text(
                                widget.keycodeModel!.password!,
                                style: TextStyle(
                                    color: _colors.textColor(context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                  color: _colors.textColor(context),
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, _isEdited);
              },
            ),
          ],
        ),
      ),
    );
  }
}
