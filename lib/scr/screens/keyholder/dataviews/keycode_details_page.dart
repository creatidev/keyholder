import 'package:auto_size_text/auto_size_text.dart';
import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/add_edit_keycode_page.dart';
import 'package:digitalkeyholder/scr/screens/widgets/password_field.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
  var keyWelcome = GlobalKey();
  var keyHelp = GlobalKey();
  var keyView = GlobalKey();
  var keyEdit = GlobalKey();
  List<TargetFocus> targets = [];
  var _demoMode = false;
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  String? _password;
  final prefs = new UserPreferences();
  CustomColors _colors = new CustomColors();
  bool _isEdited = false;
  bool _obscure = false;
  int? _actionId;
  String? _instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.keycodeModel != null) {
      _actionId = widget.keycodeModel!.action;
      _instance = widget.keycodeModel!.instance;
    }
    setTutorial();
    if (prefs.firstViewOrEdit == true) {
      showTutorial();
      prefs.firstViewOrEdit = false;
    }
  }

  void showTutorial() {
    TutorialCoachMark tutorial = TutorialCoachMark(context,
        targets: targets, // List<TargetFocus>
        colorShadow: Colors.black, // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        textSkip: "Omitir",
        // paddingFocus: 10,
        // focusAnimationDuration: Duration(milliseconds: 500),
        // pulseAnimationDuration: Duration(milliseconds: 500),
        // pulseVariation: Tween(begin: 1.0, end: 0.99),
        onFinish: () {
      setState(() => _demoMode = false);
    }, onClickTarget: (target) {
      print(target);
    }, onSkip: () {
      setState(() => _demoMode = false);
      EasyLoading.showInfo('Tutorial omitido por el usuario.',
          maskType: EasyLoadingMaskType.custom,
          duration: Duration(milliseconds: 1000));
    })
      ..show();
    // tutorial.skip();
    // tutorial.finish();
    // tutorial.next(); // call next target programmatically
    // tutorial.previous(); // call previous target programmatically
  }

  void setTutorial() {
    targets.clear();
    targets.add(TargetFocus(
        identify: "Target 0",
        keyTarget: keyHelp,
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.help_outline, color: Colors.cyanAccent),
                        ],
                      ),
                    ),
                    Text(
                      "Bienvenido",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          fontSize: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.deepPurpleAccent,
                      //height: 200,
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "A continuación verá la pantalla de detalles de la llave seleccionada.",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Toque en cualquier parte para continuar.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 1",
        //keyTarget: keyList,
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 180), Offset(0.0, 120.0)),
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Información",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.deepPurpleAccent,
                      //height: 200,
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Visualice la información básica de la llave seleccionada.",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Toque en cualquier parte para continuar.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 2",
        keyTarget: keyView,
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Ver usuario y contraseña",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.deepPurpleAccent,
                      //height: 200,
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Para visualizar el usuario y la contraseña, presione este botón, ingrese su contraseña de inicio de sesión para habilitar la visualización y la edición de la llave, si presiona de nuevo este botón se le retiraran los permisos y debe de ingresar nuevamente la contraseña.",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Toque en cualquier parte para continuar.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 3",
        keyTarget: keyEdit,
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Editar información llave",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.deepPurpleAccent,
                      //height: 200,
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Para editar la información de la llave, presione este botón,  ingrese su contraseña de inicio de sesión para habilitar la visualización y la edición de la llave, si presiona de nuevo este botón se le redireccionará a la pantalla de edición de la llave",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Toque en cualquier parte para continuar.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    var langWords = LangWords();
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        lightSource: LightSource.topLeft,
        accentColor: NeumorphicColors.accent,
        appBarTheme: NeumorphicAppBarThemeData(
            buttonStyle: NeumorphicStyle(
              color: _colors.iconsColor(context),
              shadowLightColor: _colors.iconsColor(context),
              boxShape: NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.flat,
              depth: 2,
              intensity: 0.9,
            ),
            textStyle:
                TextStyle(color: _colors.textColor(context), fontSize: 12),
            iconTheme:
                IconThemeData(color: _colors.textColor(context), size: 25)),
        depth: 1,
        intensity: 5,
      ),
      child: Scaffold(
        appBar: NeumorphicAppBar(
          leading: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5),
              child: NeumorphicIcon(
                Icons.vpn_key,
                size: 50,
                style: NeumorphicStyle(
                    color: _colors.iconsColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 1,
                    intensity: 0.7),
              ),
            ),
          ),
          title: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                AutoSizeText(
                  'Detalles: ${widget.keycodeModel!.label}',
                  maxLines: 2,
                  minFontSize: 6,
                  style: TextStyle(
                      color: _colors.iconsColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                FormHelper.showMessage(
                  context,
                  "QBayes NOC",
                  "¿Ver tutorial de la sección?",
                  "Si",
                  () {
                    setTutorial();
                    showTutorial();
                    setState(() => _demoMode = true);
                    Navigator.of(context).pop();
                  },
                  buttonText2: "No",
                  isConfirmationDialog: true,
                  onPressed2: () {
                    setState(() => _demoMode = false);
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: NeumorphicIcon(
                      Icons.help_outline,
                      key: keyHelp,
                      size: 40,
                      style: NeumorphicStyle(
                          color: _colors.iconsColor(context),
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10)),
                          shadowLightColor: _colors.shadowColor(context),
                          depth: 1,
                          intensity: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
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
                      Visibility(
                        visible: _obscure,
                        child: Text(
                          widget.keycodeModel!.user!,
                          style: TextStyle(color: _colors.iconsColor(context)),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Text('Contraseña :'),
                      Visibility(
                        visible: _obscure,
                        child: Text(
                          widget.keycodeModel!.password!,
                          style: TextStyle(
                            color: _colors.iconsColor(context),
                          ),
                        ),
                      )
                    ]),
                    TableRow(children: [
                      Text('Puerto :'),
                      Text(widget.keycodeModel!.port.toString()),
                    ]),
                    TableRow(children: [
                      Text('Instancia :'),
                      Text((_instance != null) ? _instance! : ''),
                    ]),
                    TableRow(children: [
                      Text('Fecha de creación :'),
                      Text(widget.keycodeModel!.regDate!),
                    ]),
                    TableRow(children: [
                      Text('Registrada por acción :'),
                      Text((_actionId != null)
                          ? _actionId.toString()
                          : 'Manual'),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NeumorphicButton(
                    key: keyView,
                    onPressed: () {
                      if (prefs.showPassword == true) {
                        setState(() {
                          _obscure = !_obscure;
                          prefs.showPassword = _obscure;
                        });
                      } else {
                        _changePasswordInputDialog(context);
                      }
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
                            color: _colors.iconsColor(context),
                            size: 25,
                          )
                        : Icon(
                            Icons.remove_red_eye_rounded,
                            color: _colors.iconsColor(context),
                            size: 25,
                          ),
                  ),
                  NeumorphicButton(
                    key: keyEdit,
                    onPressed: () {
                      if (prefs.showPassword == true) {
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
                      } else {
                        _changePasswordInputDialog(context);
                      }
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
                      color: _colors.iconsColor(context),
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
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
                  Navigator.pop(context, _isEdited);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePasswordInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ver o editar información'),
            content: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Container(
                height: 90,
                //color: Colors.deepPurpleAccent,
                child: Column(
                  children: [
                    Text(
                      'Ingrese su contraseña de inicio de sesión',
                      style: TextStyle(
                          color: _colors.textColor(context), fontSize: 12),
                    ),
                    PasswordField(
                      onSaved: (input) {},
                      controller: _newPasswordController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText:
                                "Por favor ingrese su contraseña de inicio"),
                      ]),
                      labelText: 'Contraseña',
                      onFieldChange: (value) {
                        _password = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState!.saveAndValidate()) {
                      if (prefs.password == _password) {
                        prefs.showPassword = true;
                        Navigator.pop(context);
                        EasyLoading.showInfo(
                            'Ver o editar información habilitado',
                            duration: Duration(milliseconds: 3000),
                            dismissOnTap: true);
                      } else {
                        EasyLoading.showInfo('Contraseña incorrecta',
                            duration: Duration(milliseconds: 3000),
                            dismissOnTap: true);
                      }
                    }
                    //codeDialog = valueText;
                  });
                },
              ),
            ],
          );
        });
  }
}
