import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/add_edit_category_page.dart';
import 'package:digitalkeyholder/scr/screens/widgets/password_field.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AddEditKeycodePage extends StatefulWidget {
  AddEditKeycodePage(
      {Key? key,
      this.categoryModel,
      this.keycodeModel,
      this.isEditMode,
      required this.isAutoMode,
      this.isCreateMode,
      this.actId})
      : super(key: key);
  final Categories? categoryModel;
  final Keycode? keycodeModel;
  final bool? isCreateMode;
  final bool? isEditMode;
  final bool? isAutoMode;
  final int? actId;
  @override
  _AddEditKeycodePageState createState() => _AddEditKeycodePageState();
}

class _AddEditKeycodePageState extends State<AddEditKeycodePage> {
  final prefs = new UserPreferences();
  var keyHelp = GlobalKey();
  var keyLogo = GlobalKey();
  var keyCategory = GlobalKey();
  var keyLabel = GlobalKey();
  var keyIp = GlobalKey();
  var keyUserName = GlobalKey();
  var keyPassword = GlobalKey();
  var keyPort = GlobalKey();
  var keyInstance = GlobalKey();
  var keySave = GlobalKey();
  var keyCancel = GlobalKey();
  var keyNotes = GlobalKey();
  CustomColors _colors = new CustomColors();
  Categories? _categoryModel;
  Keycode? _keycodeModel;
  DBService? _dbService;
  int? _actionId;
  String _actualKeycode = '';
  String? _actualCategory = 'Sin asignaci??n';
  int _port = 0;
  String? _instance;
  var _demoMode = false;
  var _enableField = true;
  var _enableFieldIp = true;
  List<TargetFocus> targets = [];
  final _formKeyCard = GlobalKey<FormBuilderState>();
  final _keyLabelController = TextEditingController();
  final _keyIpAddressController = TextEditingController();
  final _keyUserNameController = TextEditingController();
  final _keyPassController = TextEditingController();
  final _keyPortController = TextEditingController();
  final _keyInstanceController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _dbService = new DBService();
    _categoryModel = new Categories();
    _keycodeModel = new Keycode();

    if (prefs.firstKey == true) {
      Future.delayed(Duration(microseconds: 200)).then((value) {
        setTuturial();
        showTutorial();
        prefs.firstKey = false;
      });
      print('Primera llave');
    }

    if (widget.actId != null) {
      _actionId = widget.actId;
    }

    if (widget.categoryModel != null) {
      _categoryModel = widget.categoryModel;
    }

    if (widget.keycodeModel != null) {
      _keycodeModel = widget.keycodeModel;
      if (widget.keycodeModel!.action != null) {
        _actionId = widget.keycodeModel!.action;
      }
      print(_keycodeModel!.label);
      print('Modo edici??n: ${widget.isEditMode}');

      if (widget.isCreateMode!) {
        _categoryModel!.category = _keycodeModel!.name;
      }

      if (widget.isEditMode!) {
        _actualKeycode = _keycodeModel!.id.toString();
        _actualCategory = _keycodeModel!.name.toString();

        if (_keycodeModel!.name != null) {
          _categoryModel!.category = _keycodeModel!.name;
        }
        if (_keycodeModel!.port != null) {
          _port = _keycodeModel!.port;
          _keyPortController.text = _keycodeModel!.port.toString();
        }

        if (_keycodeModel!.instance != null) {
          _instance = _keycodeModel!.instance!;
          _keyInstanceController.text = _keycodeModel!.instance!;
        }

        _keyLabelController.text = _keycodeModel!.label!;
        _keyIpAddressController.text = _keycodeModel!.ip!;
        _keyUserNameController.text = _keycodeModel!.user!;
        _keyPassController.text = _keycodeModel!.password!;
      }
      if (widget.isAutoMode! == true) {
        print('Modo llavero: ${widget.isAutoMode}');
        _enableField = false;
        _categoryModel!.category = _keycodeModel!.name;
        if (_keycodeModel!.ip != '') {
          _enableFieldIp = false;
          _keyIpAddressController.text = _keycodeModel!.ip!;
        }
      }
    }
  }

  void setTuturial() {
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
                      "Agregar llave",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Para agregar una llave v??lida, se requiere de completar varios campos, a continuaci??n se explicar?? a detalle la utilidad de cada elemento requerido.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Para volver a visualizar este tutorial, presione sobre el icono se??alado.",
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
        keyTarget: keyCategory,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
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
                      "Categor??a",
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
                                      "Muestra las categor??as registradas de forma autom??tica al iniciar la acci??n, se utilizan para filtrar su utilidad en la acci??n.\n\n",
                                ),
                                TextSpan(
                                  text:
                                      "Podr?? utilizarlas para administrar las llaves asignadas a dicha categor??a.",
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
        keyTarget: keyLabel,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
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
                      "Nota o etiqueta",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Agregue una peque??a nota o etiqueta para la llave.",
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
        keyTarget: keyIp,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
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
                      "Direcci??n IP",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ingrese la ip en el campo requerido de la categor??a solicitada, con el formato espec??fico IP V4 (Ejemplo: 123.23.254.234).",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: keyUserName,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
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
                      "Nombre de usuario",
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
                                      "Ingrese el nombre de usuario en el campo requerido de la categor??a solicitada.\n\n",
                                ),
                                TextSpan(
                                  text:
                                      "Se recomienda sea escrita tal y como se requiere en el sistema.",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
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
        keyTarget: keyPassword,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
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
                    Text(
                      "Contrase??a",
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
                                      "Ingrese la contrase??a en el campo requerido de la categor??a solicitada, este campo no cuenta con validaciones.\n\n",
                                ),
                                TextSpan(
                                  text:
                                      "Se recomienda sea escrita tal y como se requiere en el sistema.",
                                ),
                              ],
                            ),
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
        keyTarget: keyPort,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
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
                    Text(
                      "Puerto",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ingrese el puerto si la categor??a as?? lo requiere. Solo admite datos num??ricos.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: keyInstance,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
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
                    Text(
                      "Instancia",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ingrese la instancia si la categor??a as?? lo requiere. Las instancias se vinculan a categor??as de bases de datos.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: keySave,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
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
                    Text(
                      "Registrar llave",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
                                      "Se realizar?? la validaci??n del formulario y si todos los campos est??n correctos, se realizar?? el registro local de la llave, la cual podr?? ser administrada a trav??z del nombre de la categor??a o por llaves registradas.\n\n",
                                ),
                                TextSpan(
                                  text:
                                      "No se recomienda crear llaves personalizadas sin que hayan sido requeridas, ya que no ser??n consultadas.",
                                ),
                              ],
                            ),
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
        keyTarget: keyCancel,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
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
                    Text(
                      "Cancelar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Cancela el registro actual o actualizaci??n/modificaci??n de la llave. Retorna a la pantalla anterior.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: keyLogo,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
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
                      "Id de la acci??n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                                      "Muestra el id de la acci??n sobre la cual la llave fue solicitada, se guarda la primera vez que fue registrada.\n\n",
                                ),
                                TextSpan(
                                  text:
                                      "Si el ingreso no es a trav??s de una acci??n, se registrar?? como manual.",
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
            key: keyLogo,
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  NeumorphicIcon(
                    Icons.vpn_key,
                    size: 50,
                    style: NeumorphicStyle(
                        color: _colors.iconsColor(context),
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                        shadowLightColor: _colors.shadowColor(context),
                        depth: 1.5,
                        intensity: 0.7),
                  ),
                  Positioned(
                    right: 1,
                    top: 21,
                    child: Text(
                      (_actionId != null) ? _actionId.toString() : 'Manual',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: _colors.contextColor(context)),
                    ),
                  )
                ],
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicText(
                widget.isEditMode!
                    ? 'Editar llave: $_actualKeycode'
                    : 'Crear llave: $_actualKeycode',
                //key: keyWelcome,
                style: NeumorphicStyle(
                  color: _colors.iconsColor(context),
                  intensity: 0.7,
                  depth: 1.5,
                  shadowLightColor: _colors.shadowColor(context),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                FormHelper.showMessage(
                  context,
                  "QBayes NOC",
                  "??Ver tutorial de la secci??n?",
                  "Si",
                  () {
                    setTuturial();
                    showTutorial();
                    Navigator.of(context).pop();
                  },
                  buttonText2: "No",
                  isConfirmationDialog: true,
                  onPressed2: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Container(
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
                      depth: 1.5,
                      intensity: 0.7),
                ),
              ),
            ),
          ],
        ),
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
                            //color: Colors.white70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Categor??a actual:',
                                    style: TextStyle(
                                        color: _colors.iconsColor(context))),
                                Text(_actualCategory ?? 'Sin asignar',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: _colors.iconsColor(context))),
                              ],
                            ),
                          ),
                          Divider(),
                          FutureBuilder<List<Categories>>(
                            future: _dbService!.getCategory(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Categories>> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.length != 0) {
                                  return Column(
                                    children: [
                                      FormBuilderDropdown<String>(
                                        key: keyCategory,
                                        enabled: _enableField,
                                        name: 'category',
                                        initialValue: _categoryModel!.category,
                                        decoration: InputDecoration(
                                            labelText: 'Categor??a',
                                            prefixIcon: Icon(
                                                Icons.vpn_key_outlined,
                                                color: Colors.deepPurpleAccent,
                                                size: 18)),
                                        hint: Text('Seleccionar categor??a'),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText:
                                                  langWords.requiredCategory)
                                        ]),
                                        items: snapshot.data!
                                            .map((data) =>
                                                DropdownMenuItem<String>(
                                                  child: Text(
                                                      data.category.toString()),
                                                  value: data.category,
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          //_keyLabelController.text = value!;
                                          _actualCategory = value;
                                          _keycodeModel!.name = value;
                                          _categoryModel!.category = value;
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  return NeumorphicButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute<String>(
                                        builder: (BuildContext context) {
                                          return AddEditCategoryPage();
                                        },
                                      )).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _actualCategory = value;
                                            _keycodeModel!.name = value;
                                            _categoryModel!.category = value;
                                          });
                                          super.widget;
                                        }
                                      });
                                    },
                                    tooltip: 'Recuperar contrase??a',
                                    style: NeumorphicStyle(
                                        color: _colors.iconsColor(context),
                                        shape: NeumorphicShape.flat,
                                        boxShape: NeumorphicBoxShape.rect(),
                                        shadowLightColor:
                                            _colors.iconsColor(context),
                                        depth: 1,
                                        intensity: 1),
                                    padding: const EdgeInsets.all(7.0),
                                    child: NeumorphicText(
                                      'Crear categor??a',
                                      style: NeumorphicStyle(
                                        color: _colors.textButtonColor(context),
                                        intensity: 0.7,
                                        depth: 1,
                                        shadowLightColor:
                                            _colors.shadowTextColor(context),
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                          FormBuilderTextField(
                            key: keyLabel,
                            controller: _keyLabelController,
                            name: "keylabel",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.label,
                                    color: Colors.deepPurpleAccent, size: 18),
                                labelText: langWords.label),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: langWords.requiredField)
                            ]),
                            maxLength: 20,
                            onChanged: (value) {
                              _keycodeModel!.label = value;
                            },
                          ),
                          FormBuilderTextField(
                            key: keyIp,
                            enabled: _enableFieldIp,
                            controller: _keyIpAddressController,
                            name: "keyip",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.web,
                                    color: Colors.deepPurpleAccent, size: 18),
                                labelText: langWords.ip),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Este campo no puede estar vac??o"),
                              FormBuilderValidators.ip(
                                  errorText:
                                      "Introduzca una direcci??n ip v??lida"),
                            ]),
                            maxLength: 15,
                            onChanged: (value) {
                              _keycodeModel!.ip = value;
                            },
                          ),
                          FormBuilderTextField(
                            key: keyUserName,
                            controller: _keyUserNameController,
                            name: "userName",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.label,
                                    color: Colors.deepPurpleAccent, size: 18),
                                labelText: langWords.userName),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: langWords.requiredField)
                            ]),
                            onChanged: (value) {
                              _keycodeModel!.user = value;
                            },
                          ),
                          PasswordField(
                            fieldKey: keyPassword,
                            controller: _keyPassController,
                            //helperText: 'No m??s de 15 caracteres.',
                            labelText: langWords.hintLoginPassword,
                            validator: FormBuilderValidators.required(
                                errorText: langWords.requiredField),
                            onFieldChange: (value) {
                              _keycodeModel!.password = value;
                            },
                          ),
                          FormBuilderTextField(
                            key: keyPort,
                            controller: _keyPortController,
                            name: "keyPort",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_lock,
                                    color: Colors.deepPurpleAccent, size: 18),
                                labelText: langWords.port,
                                hintText: 'Opcional'),
                            onChanged: (value) {
                              _port = int.parse(value!);
                              print(value);
                            },
                          ),
                          FormBuilderTextField(
                            key: keyInstance,
                            controller: _keyInstanceController,
                            name: "keyInstance",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                    Icons.remove_from_queue_rounded,
                                    color: Colors.deepPurpleAccent,
                                    size: 18),
                                labelText: langWords.instance,
                                hintText: 'Opcional'),
                            onChanged: (value) {
                              _instance = value;
                              print(value);
                            },
                          ),
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
                key: keyCancel,
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
                  Navigator.pop(context);
                },
              ),
              NeumorphicFloatingActionButton(
                key: keySave,
                style: NeumorphicStyle(
                    color: _colors.contextColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 2,
                    intensity: 1),
                tooltip: langWords.addkey,
                child: Container(
                  margin: EdgeInsets.all(2),
                  child: Icon(
                    Icons.save,
                    color: _colors.iconsColor(context),
                    size: 30,
                  ),
                ),
                onPressed: () async {
                  var now = DateTime.now();
                  if (_keycodeModel!.name == null) {
                    EasyLoading.showError(langWords.requiredCategory!,
                        dismissOnTap: true,
                        maskType: EasyLoadingMaskType.custom,
                        duration: Duration(milliseconds: 1500));
                  } else {
                    _keycodeModel!.regDate =
                        DateFormat('yyyy-MM-dd -- hh:mm a').format(now);
                    _keycodeModel!.name = _categoryModel!.category;
                    _keycodeModel!.port = _port;
                    _keycodeModel!.instance = _instance;
                    _keycodeModel!.action = _actionId;
                    if (widget.isEditMode!) {
                      _dbService!.updateKeycode(_keycodeModel!).then((value) {
                        if (value == true) {
                          EasyLoading.showInfo(
                              'Llave actualizada correctamente',
                              maskType: EasyLoadingMaskType.custom,
                              duration: Duration(milliseconds: 2000));
                          Navigator.pop(context, _keycodeModel!);
                        }
                      });
                    } else {
                      print(_keycodeModel!.name);
                      print(_keycodeModel!.label);
                      print(_keycodeModel!.ip);
                      print(_keycodeModel!.user);
                      print(_keycodeModel!.password);
                      print(_keycodeModel!.port);
                      print(_keycodeModel!.instance);
                      print(_keycodeModel!.regDate);
                      print(_keycodeModel!.action);
                      if (_formKeyCard.currentState!.saveAndValidate()) {
                        var getIp = "SELECT * FROM keycodetable WHERE name ="
                            " '${_keycodeModel!.name}' AND ip = '${_keycodeModel!.ip}'";
                        print(getIp);
                        _dbService!.getKeycodeByCategory(getIp).then((value) {
                          if (value.length == 0) {
                            _dbService!
                                .addKeycode(_keycodeModel!)
                                .then((value) {
                              EasyLoading.showInfo(
                                  'Llave registrada correctamente',
                                  maskType: EasyLoadingMaskType.custom,
                                  duration: Duration(milliseconds: 2000));
                              Navigator.pop(context, _keycodeModel!);
                            });
                          } else {
                            _dbService!
                                .updateKeycode(_keycodeModel!)
                                .then((value) {
                              EasyLoading.showInfo(
                                  'Llave actualizada correctamente',
                                  maskType: EasyLoadingMaskType.custom,
                                  duration: Duration(milliseconds: 2000));
                              Navigator.pop(context, _keycodeModel!);
                            });
/*                            FormHelper.showMessage(
                                context,
                                'QBayes NOC',
                                'La llave con con categor??a ${_keycodeModel!.name} direcci??n IP ${_keycodeModel!.ip} ya se encuentra registrada.',
                                'Ok', () {
                              Navigator.of(context).pop();
                            });*/
                          }
                        });
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
