// ignore: import_of_legacy_library_into_null_safe
import 'package:badges/badges.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/AddEditCategory_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/Options_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/RegisteredKeycodes_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/RegisteredCategoryAddOption.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/UserInfo_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/UserRequest_Page.dart';
import 'package:digitalkeyholder/scr/services/ThemeNotifier.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:we_slide/we_slide.dart';
import 'AddEditKeycode_Page.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var keyWelcome = GlobalKey();
  var keyHelp = GlobalKey();
  var keyLogo = GlobalKey();
  var keyActionButton = GlobalKey();
  var keyBottomBar = GlobalKey();
  var keyFilter = GlobalKey();
  var keyList = GlobalKey();
  var keyCodeRegList = GlobalKey();
  var keyCatRegList = GlobalKey();
  var keyStatus = GlobalKey();
  var keyStop = GlobalKey();

  List<TargetFocus> targets = [];
  final prefs = new UserPreferences();
  CustomColors _colors = new CustomColors();
  var _textController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);
  var _title = 'Requerimientos';
  var _demoMode = false;
  var currentIndex = 0;
  var disEditMode = false;
  var isCreateMode = false;
  var _status = true;
  var _showBadge = true;

  DBService? dbService;
  Categories? model;
  var visibleText = true;
  Icon _icon = Icon(Icons.refresh);
  var langWords;
  List<Categories>? requestedCategories = [];
  String badgeText = '0';

  void showTutorial() {
    TutorialCoachMark tutorial = TutorialCoachMark(context,
        targets: targets, // List<TargetFocus>
        colorShadow: Colors.black, // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        textSkip: "Saltar",
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
      EasyLoading.showInfo('Tutorial cancelado por el usuario.',
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
    // TODO: implement initState
    super.initState();
    langWords = LangWords();
    dbService = new DBService();
    model = new Categories();

    setTutorial();

    if (prefs.firstRun == true) {
      _demoMode = true;
      Future.delayed(Duration(microseconds: 200)).then((value) {
        showTutorial();
      });
      prefs.firstRun = false;
    }
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
                                      "A continuación se iniciará el tutorial del llavero Qbayes Step Up!, aunque se recomienda que sea visualizado por completo la primera vez, puede saltarlo y verlo cuando lo desee en el icono seleccionado. Los tutoriales se dividen por sección.",
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
        keyTarget: keyLogo,
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
                      "Cuenta de usuario",
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
                                      "Seleccione el tema, visualice información de su usuario, reinicie tutoriales, cambie la contraseña y cierre de la sesión.",
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
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 2",
        keyTarget: keyActionButton,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.left,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Acciones",
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
                                      "Actualice requerimientos, administre las llaves y categorías almacenadas.",
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
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 200.0),
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
                      "Burbuja de notificación",
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
                                      "La burbuja amarilla mostrará la cantidad de requerimientos asignados a su cuenta.",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 3",
        keyTarget: keyFilter,
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
                      "Cambio de estado",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Seleccione por estado de requerimiento, por defecto se encuentran los requerimientos pendientes.",
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
              ))
        ]));
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: keyBottomBar,
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
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 200.0),
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
                    "Barra de navegación",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Inicio - Llaves - Categorías - Acerca de...",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
    ));
    targets.add(TargetFocus(
        identify: "Target 5",
        //keyTarget: keyList,
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 300), Offset(0.0, 185.0)),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
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
                      "Lista de requerimientos",
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
                                      "Lista de requerimientos filtrados, por defecto se encuentra establecido en requerimientos pendientes.",
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
        identify: "Target 6",
        targetPosition: TargetPosition(Size(40, 40), Offset(330.0, 192.0)),
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.left,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Envíar requerimiento",
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
                                      "Presione para enviar el requerimiento seleccionado, eso lo llevará a la siguiente etapa de creación del llavero.",
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
        identify: "Target 7",
        //keyTarget: keyActionButton,
        targetPosition: TargetPosition(Size(40, 40), Offset(255.0, 192.0)),
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
                      "Cancelar requerimiento",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Presione para cancelar el requerimiento seleccionado. Se enviará la notificación al servidor como cancelada.",
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
        identify: "Target 8",
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(150, 45), Offset(90.0, 190.0)),
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
                      "Información del requerimiento",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Id, Categoría, Cliente y tiempo recorrido desde asignación.",
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

  void setKeyTutorial() {
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
                                      "A continuación verá la ventana de llaves registradas...",
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
        targetPosition: TargetPosition(Size(400, 300), Offset(0.0, 140.0)),
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
                      "Lista de llaves registradas",
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
                                      "Administre las llaves registradas desde esta ventana.",
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
        //keyTarget: keyList,
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 30), Offset(0.0, 230.0)),
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
                      "Llave registrada",
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
                                      "Seleccione la llave para ver la información relacionada.",
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
        identify: "Target 3",
        targetPosition: TargetPosition(Size(25, 25), Offset(333.0, 233.0)),
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.bottomRight, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.left,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Eliminar llave registrada",
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
                                      "Presione para eliminar el registro de la llave seleccionada.",
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
        identify: "Target 4",
        targetPosition: TargetPosition(Size(25, 25), Offset(263.0, 233.0)),
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.bottomRight, 0.0),
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
                      "Editar llave registrada",
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
                                      "Presione para editar los datos de la llave seleccionada.",
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
        identify: "Target 5",
        keyTarget: keyActionButton,
        enableOverlayTab: true,
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
                    Text(
                      "Registrar llave",
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
                                      "Puede registrar una llave de forma local, esta llave no será requerida a menos de que se encuentre asociada a una categoría existente.",
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

  void setCatTutorial() {
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
                                  "A continuación verá la ventana de categorías registradas...",
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
        targetPosition: TargetPosition(Size(400, 300), Offset(0.0, 140.0)),
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
                      "Lista de categorías registradas",
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
                                      "Administre las categorías registradas desde esta ventana.",
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
        //keyTarget: keyList,
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 30), Offset(0.0, 230.0)),
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
                      "Categoría registrada",
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
                                  "Seleccione la categoría para ver la información relacionada.",
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
        identify: "Target 3",
        targetPosition: TargetPosition(Size(25, 25), Offset(285.0, 233.0)),
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
                      "Eliminar categoría registrada",
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
                                      "Presione para eliminar el registro de la categoría seleccionada.",
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
        identify: "Target 4",
        keyTarget: keyActionButton,
        enableOverlayTab: true,
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
                    Text(
                      "Registrar categoría",
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
                                      "Puede registrar una categoría de forma local, esta categoría no será requerida a menos de que se encuentre asociada a una categoría existente en el servidor.",
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
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void changePage(int? index) {
    final counter = Provider.of<CounterProvider>(context, listen: false);
    setState(() {
      currentIndex = index!;
      switch (currentIndex) {
        case 0:
          {
            _icon = Icon(Icons.refresh);
            _status ? _title = 'Requerimientos' : _title = 'Historial';
            setTutorial();
            _showBadge = true;
          }
          break;
        case 1:
          {
            _icon = Icon(Icons.add);
            _title = 'Llaves';
            setKeyTutorial();
            if (counter.counter > 0) {
              if (prefs.firstViewKey == true) {
                showTutorial();
                prefs.firstViewKey = false;
              }
            }
            _showBadge = false;
          }
          break;
        case 2:
          {
            _icon = Icon(Icons.add);
            _title = 'Categorías';
            setCatTutorial();
            if (counter.countCats > 0) {
              if (prefs.firstViewCategory == true) {
                showTutorial();
                prefs.firstViewCategory = false;
              }
            }
            _showBadge = false;
          }
          break;
        case 3:
          {
            _icon = Icon(Icons.save);
            _title = 'Acerca de...';
            _showBadge = false;
          }
          break;
      }
    });
    print(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final WeSlideController _controller = WeSlideController();
    final double _panelMinSize = 60.0;
    final double _panelMaxSize = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldMessengerState> messengerKey =
        new GlobalKey<ScaffoldMessengerState>();
    final request = Provider.of<APIService>(context);
    final _kTabPages = <Widget>[
      UserRequestList(
        key: keyList,
        iconColor: _colors.iconsColor(context),
        shadowColor: _colors.shadowColor(context),
        textColor: _colors.textColor(context),
        status: _status,
        demoMode: _demoMode,
      ),
      RegisteredKeycodesPage(
        key: keyCodeRegList,
        iconsColor: _colors.iconsColor(context),
        shadowColor: _colors.shadowColor(context),
        textColor: _colors.textColor(context),
      ),
      RegisteredCategoriesPage(
        iconColor: _colors.iconsColor(context),
        shadowColor: _colors.shadowColor(context),
        textColor: _colors.textColor(context),
      ),
      OptionsPage()
    ];

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
            onTap: () {
              if (_controller.isOpened == true) {
                _controller.hide();
              } else {
                _controller.show();
              }
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: NeumorphicIcon(
                QuanticLogo.logon,
                size: 50,
                style: NeumorphicStyle(
                    color: _colors.iconsColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 1.5,
                    intensity: 3),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicText(
                langWords!.mainName!,
                key: keyWelcome,
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
                  "QBayes Step Up!",
                  "¿Ver tutorial de la sección?",
                  "Si",
                  () {
                    if (_controller.isOpened == true) {
                      _controller.hide();
                    }
                    final counter =
                        Provider.of<CounterProvider>(context, listen: false);
                    if (currentIndex == 0) {
                      showTutorial();
                      setState(() => _demoMode = true);
                      Navigator.of(context).pop();
                    }

                    if (currentIndex == 1) {
                      if (counter.counter > 0) {
                        showTutorial();
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        EasyLoading.showError(
                            'Se requieren llaves registradas para mostrar el tutorial.',
                            maskType: EasyLoadingMaskType.custom,
                            duration: Duration(milliseconds: 1000));
                      }
                    }

                    if (currentIndex == 2) {
                      if (counter.countCats > 0) {
                        showTutorial();
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        EasyLoading.showError(
                            'Se requieren categorías registradas para mostrar el tutorial.',
                            maskType: EasyLoadingMaskType.custom,
                            duration: Duration(milliseconds: 1000));
                      }
                    }
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
                          depth: 1.5,
                          intensity: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        //endDrawer: _MyDrawer(isLead: false),
        body: WeSlide(
            controller: _controller,
            panelMinSize: _panelMinSize,
            panelMaxSize: _panelMaxSize,
            overlayColor: _colors.iconsColor(context),
            overlayOpacity: 0.9,
            overlay: true,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.only(right: 15),
                      child: Row(
                        children: [
                          Container(
                            color: Colors.deepPurple,
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    EasyLoading.show(
                                        status:
                                            'Sincronizando requerimientos...',
                                        maskType: EasyLoadingMaskType.custom);
                                    Future.delayed(Duration(milliseconds: 1000))
                                        .then((value) => {
                                              if (request.selectedStatus == "1")
                                                {
                                                  request.selectedStatus = "2",
                                                  _status = true,
                                                  _title = 'Requerimientos'
                                                }
                                              else
                                                {
                                                  request.selectedStatus = "1",
                                                  _status = false,
                                                  _title = 'Historial'
                                                },
                                              EasyLoading.dismiss()
                                            });
                                  },
                                  child: Visibility(
                                    key: keyFilter,
                                    visible: _showBadge,
                                    child: NeumorphicIcon(
                                      Icons.wifi_protected_setup,
                                      size: 35,
                                      style: NeumorphicStyle(
                                          color: Colors.orange,
                                          shape: NeumorphicShape.flat,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(10)),
                                          shadowLightColor: Colors.deepPurple,
                                          depth: 1.5,
                                          intensity: 0.7),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Visibility(
                                          visible: !_showBadge,
                                          child: currentIndex == 1
                                              ? Consumer<CounterProvider>(
                                                  builder: (context, notifier,
                                                          child) =>
                                                      Text(
                                                          notifier.counter
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .orange)),
                                                )
                                              : currentIndex == 2
                                                  ? Consumer<CounterProvider>(
                                                      builder: (context,
                                                              notifier,
                                                              child) =>
                                                          Text(
                                                              notifier.countCats
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .orange)),
                                                    )
                                                  : Image.asset(
                                                      'assets/logo.png',
                                                      height: 20,
                                                      width: 20)),
                                      NeumorphicText(
                                        ' $_title',
                                        style: NeumorphicStyle(
                                          color: _colors.iconsColor(context),
                                          intensity: 0.7,
                                          depth: 1.5,
                                          shadowLightColor:
                                              _colors.shadowColor(context),
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.700,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.700,
                                  child: _kTabPages[currentIndex],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            panel: UserInfo()),
        floatingActionButton: Badge(
          showBadge: _showBadge ? true : false,
          badgeContent: (request != null)
              ? Text('${request.count}', style: TextStyle(color: Colors.white))
              : Text('0'),
          badgeColor: Colors.orange,
          //position: BadgePosition.topEnd(),
          child: FloatingActionButton(
            key: keyActionButton,
            onPressed: () {
              switch (currentIndex) {
                case 0:
                  {
                    if (_controller.isOpened == true) {
                      _controller.hide();
                    }
                    EasyLoading.show(
                        status: 'Sincronizando requerimientos...',
                        maskType: EasyLoadingMaskType.custom);
                    Future.delayed(Duration(milliseconds: 3000))
                        .then((value) => {
                              setState(() {
                                request.selectedStatus = "2";
                                _status = true;
                                _title = 'Requerimientos';
                              }),
                              EasyLoading.dismiss()
                            });

                    final snackBar = SnackBar(
                      content: Text('Requerimientos sincronizados.'),
                    );
                    messengerKey.currentState?.showSnackBar(snackBar);
                  }
                  break;
                case 1:
                  {
                    Navigator.push(context, MaterialPageRoute<String>(
                      builder: (BuildContext context) {
                        return AddEditKeycodePage(
                          isCreateMode: true,
                          isEditMode: false,
                          isAutoMode: false,
                        );
                      },
                    )).then((result) {
                      if (result != null) {
                        if (result != '') {
                          setState(() {
                            super.widget;
                          });
                        }
                        print('Devuelve');
                      }
                    });
                  }
                  break;
                case 2:
                  {
                    Navigator.push(context, MaterialPageRoute<bool>(
                      builder: (BuildContext context) {
                        return AddEditCategoryPage();
                      },
                    ));
                  }
                  break;
                case 3:
                  {}
                  break;
              }
            },
            child: _icon,
            backgroundColor: _colors.iconsColor(context),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          key: keyBottomBar,
          backgroundColor: _colors.contextColor(context),
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          opacity: .2,
          currentIndex: currentIndex,
          onTap: changePage,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ), //border radius doesn't work when the notch is enabled.
          elevation: 8,
          hasInk: true,
          inkColor: Colors.black12,
          //tilesPadding: EdgeInsets.symmetric(vertical: 8.0,),
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.home,
                color: _colors.iconsColor(context),
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("Inicio"),
            ),
            BubbleBottomBarItem(
                backgroundColor: Colors.deepPurpleAccent,
                icon: Icon(
                  Icons.vpn_key,
                  color: _colors.iconsColor(context),
                ),
                activeIcon: Icon(
                  Icons.vpn_key,
                  color: Colors.deepPurpleAccent,
                ),
                title: Text("Llaves")),
            BubbleBottomBarItem(
                backgroundColor: Colors.lightBlue,
                icon: Icon(
                  Icons.label,
                  color: _colors.iconsColor(context),
                ),
                activeIcon: Icon(
                  Icons.label,
                  color: Colors.lightBlue,
                ),
                title: Text("Categorías")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  Icons.menu,
                  color: Colors.deepPurpleAccent,
                ),
                activeIcon: Icon(
                  Icons.menu,
                  color: Colors.green,
                ),
                title: Text("Menú"))
          ],
        ),
      ),
    );
  }
}
