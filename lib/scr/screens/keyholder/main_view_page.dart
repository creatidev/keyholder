import 'dart:io';

import 'package:badges/badges.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/add_edit_category_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/about_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/query_data.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/registered_keycodes_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/registered_category_add_option.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/user_info_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/user_request_page.dart';
import 'package:digitalkeyholder/scr/services/theme_notifier.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:digitalkeyholder/scr/services/api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:we_slide/we_slide.dart';
import 'add_edit_keycode_page.dart';
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
  var keyPause = GlobalKey();
  var keyPlay = GlobalKey();
  var keyCancel = GlobalKey();
  final WeSlideController _controller = WeSlideController();
  List<TargetFocus> targets = [];
  final prefs = new UserPreferences();
  CustomColors _colors = new CustomColors();
  var _textController = TextEditingController();
  var _title = 'Acciones pendientes';
  var _demoMode = false;
  var _currentIndex = 0;
  var _status = true;
  var _showBadge = true;
  var langWords;
  DBService? dbService;
  Categories? model;
  var visibleText = true;
  Icon _icon = Icon(Icons.refresh);
  var _groupValue = 1;
  List<Categories>? requestedCategories = [];
  String badgeText = '0';
  String? filePath;

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
    // TODO: implement initState
    super.initState();
    langWords = LangWords();
    dbService = new DBService();
    model = new Categories();

    Future.delayed(Duration(microseconds: 1000)).then((value) {
      final request = Provider.of<APIService>(context, listen: false);
      request.selectedStatus = "2";
    });

    setTutorial();
    prefs.showPassword = false;
    if (prefs.firstRun == true) {
      _demoMode = true;
      Future.delayed(Duration(microseconds: 3000)).then((value) {
        showTutorial();
      });
      prefs.firstRun = false;
    }
  }

  void setTutorial() {
    targets.clear();
    targets.add(TargetFocus(
        identify: "Target 0",
        //keyTarget: keyList,
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 80), Offset(0.0, 165.0)),
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
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
                        Icon(Icons.live_help_outlined,
                            color: Colors.cyanAccent),
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
                                    "A continuación se iniciará el tutorial del llavero QBayes NOC, aunque se recomienda que sea visualizado por completo la primera vez, puede omitirlo y verlo cuando lo desee tocando en el icono ",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.help_outline,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " en la part superior derecha de la pantalla. Recuerde que los tutoriales se dividen por sección.",
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
              ))
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
        keyTarget: keyFilter,
        shape: ShapeLightFocus.RRect,
        //targetPosition: TargetPosition(Size(400, 20), Offset(0.0, 125.0)),
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
                      "Estado de las acciones",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.grey,
                      height: 200,
                      width: 400,
                      child: Table(
                        border: TableBorder.all(color: Colors.white12),
                        columnWidths: {
                          0: FlexColumnWidth(10),
                          1: FlexColumnWidth(90)
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pause,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Acción pendiente por completar',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
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
                                  Icon(
                                    Icons.history,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Historial de acciones',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
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
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 3",
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
                      "Acciones en espera...",
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
                                      "Actualice acciones, administre las llaves y categorías almacenadas.",
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
                                      "La burbuja amarilla mostrará la cantidad de acciones asignadas a su cuenta.",
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
        identify: "Target 6", // Offset(330.0, 192.0)),
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 80), Offset(0.0, 165.0)),
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
                      "Acción pendiente",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.grey,
                      height: 200,
                      width: 400,
                      child: Table(
                        border: TableBorder.all(color: Colors.white12),
                        columnWidths: {
                          0: FlexColumnWidth(10),
                          1: FlexColumnWidth(90)
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pause,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Acción en espera',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
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
                                  Icon(
                                    Icons.stop,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cancelar acción seleccionada',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
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
                                  Icon(
                                    Icons.skip_next,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Enviar acción seleccionada',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
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
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(160, 45), Offset(80.0, 185.0)),
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
                      "Información de la acción",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Id, Categoría, Ip y tiempo recorrido desde asignación.",
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
                                      "A continuación verá la pantalla de llaves registradas...",
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
                                      "Administre las llaves registradas desde esta pantalla.",
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
                                      "A continuación verá la pantalla de categorías registradas...",
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
                                      "Administre las categorías registradas desde esta pantalla.",
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
        targetPosition: TargetPosition(Size(25, 25), Offset(295.0, 233.0)),
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
    if (_controller.isOpened == true) {
      _controller.hide();
    }
    setState(() {
      _currentIndex = index!;
      switch (_currentIndex) {
        case 0:
          {
            _status ? _title = 'Acciones en espera...' : _title = 'Historial';
            _icon = Icon(Icons.refresh);
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
    print(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<APIService>(context);
    final double _panelMinSize = 60.0;
    final double _panelMaxSize = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldMessengerState> messengerKey =
        new GlobalKey<ScaffoldMessengerState>();

    final _kTabPages = <Widget>[
      (_status == true)
          ? UserRequestList(
              key: keyList,
              status: _status,
              demoMode: _demoMode,
            )
          : QueryData(
              demoMode: true,
              status: true,
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
      AboutPage()
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
        //backgroundColor: _colors.contextColor(context),
        appBar: NeumorphicAppBar(
          leading: GestureDetector(
            onTap: () async {
              if (_controller.isOpened == true) {
                _controller.hide();
              } else {
                _controller.show();
              }
            },
            child: Container(
              key: keyLogo,
              width: 50,
              height: 50,
              //color: Colors.lightBlue,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  NeumorphicIcon(
                    QuanticLogo.logon,
                    size: 48,
                    style: NeumorphicStyle(
                        color: Colors.redAccent,
                        shadowLightColor: Colors.red,
                        depth: 1,
                        intensity: 0.7),
                  ),
                  NeumorphicIcon(
                    Icons.person_pin,
                    size: 14,
                    style: NeumorphicStyle(
                        color: _colors.textColor(context),
                        shadowLightColor: _colors.shadowTextColor(context),
                        depth: 1,
                        intensity: 0.7),
                  ),
                ],
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
                  depth: 1,
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
                if (_currentIndex == 3) {
                  EasyLoading.showInfo(
                      'No hay tutoriales disponibles para esta sección.',
                      maskType: EasyLoadingMaskType.custom,
                      duration: Duration(milliseconds: 3000),
                      dismissOnTap: true);
                } else {
                  FormHelper.showMessage(
                    context,
                    "QBayes NOC",
                    "¿Ver tutorial de la sección?",
                    "Si",
                    () {
                      if (_controller.isOpened == true) {
                        _controller.hide();
                      }
                      final counter =
                          Provider.of<CounterProvider>(context, listen: false);
                      if (_currentIndex == 0) {
                        showTutorial();
                        setState(() => _demoMode = true);
                        Navigator.of(context).pop();
                      }

                      if (_currentIndex == 1) {
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

                      if (_currentIndex == 2) {
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
                }
              },
              child: NeumorphicIcon(
                Icons.help_outline,
                size: 40,
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
                    _showBadge == true
                        ? Container(
                            height: 50,
                            color: _colors.contextColor(context),
                            padding: EdgeInsets.all(1),
                            child: Row(
                              key: keyFilter,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                NeumorphicRadio(
                                  child: SizedBox(
                                    height: 40,
                                    width: 180,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          NeumorphicIcon(
                                            Icons.pause,
                                            size: 40,
                                            style: NeumorphicStyle(
                                                color: _groupValue == 1
                                                    ? Colors.orange
                                                    : _colors
                                                        .borderColor(context),
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            10)),
                                                shadowLightColor: _groupValue ==
                                                        1
                                                    ? Colors.orange
                                                    : _colors
                                                        .borderColor(context),
                                                depth: 1,
                                                intensity: 0.7),
                                          ),
                                          Text(
                                            "En espera...",
                                            style: TextStyle(
                                                color: _groupValue == 1
                                                    ? Colors.orange
                                                    : _colors
                                                        .borderColor(context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  value: 1,
                                  groupValue: _groupValue,
                                  style: NeumorphicRadioStyle(
                                      intensity: 0.5,
                                      selectedDepth: 1,
                                      unselectedDepth: 1.5,
                                      selectedColor:
                                          _colors.contextColor(context),
                                      unselectedColor:
                                          _colors.contextColor(context)),
                                  onChanged: (value) {
                                    setState(() {
                                      request.selectedStatus = "2";
                                      _status = true;
                                      _groupValue = 1;
                                    });
                                  },
                                ),
                                SizedBox(width: 26),
                                NeumorphicRadio(
                                  child: SizedBox(
                                    height: 40,
                                    width: 180,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          NeumorphicIcon(
                                            Icons.history,
                                            size: 40,
                                            style: NeumorphicStyle(
                                                color: _groupValue == 2
                                                    ? Colors.orange
                                                    : _colors
                                                        .borderColor(context),
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            10)),
                                                shadowLightColor: _groupValue ==
                                                        2
                                                    ? Colors.orange
                                                    : _colors
                                                        .borderColor(context),
                                                depth: 1,
                                                intensity: 0.7),
                                          ),
                                          Text(
                                            "Historial",
                                            style: TextStyle(
                                                color: _groupValue == 2
                                                    ? Colors.orange
                                                    : _colors
                                                        .borderColor(context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  value: 2,
                                  groupValue: _groupValue,
                                  style: NeumorphicRadioStyle(
                                      intensity: 0.5,
                                      selectedDepth: 1,
                                      unselectedDepth: 1.5,
                                      selectedColor:
                                          _colors.contextColor(context),
                                      unselectedColor:
                                          _colors.contextColor(context)),
                                  onChanged: (value) {
                                    setState(() {
                                      _status = false;
                                      _groupValue = 2;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 40,
                            color: _colors.contextColor(context),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _status = !_status;
                                      if (_status == true) {
                                        request.selectedStatus = "2";
                                      }
                                      _status
                                          ? _title = 'Acciones en espera...'
                                          : _title = 'Historial';
                                    });
                                  },
                                  child: Visibility(
                                    key: keyFilter,
                                    visible: _showBadge,
                                    child: NeumorphicIcon(
                                      _status == true
                                          ? Icons.pause
                                          : Icons.query_builder,
                                      size: 35,
                                      style: NeumorphicStyle(
                                          color: Colors.orange,
                                          shape: NeumorphicShape.flat,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(10)),
                                          shadowLightColor: Colors.deepPurple,
                                          depth: 1,
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
                                          child: _currentIndex == 1
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
                                              : _currentIndex == 2
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
                                          fontSize: 16,
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
                                  child: _kTabPages[_currentIndex],
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
          badgeContent: (request.count > 0)
              ? Text('${request.count}', style: TextStyle(color: Colors.white))
              : Text('0'),
          badgeColor: Colors.orange,
          //position: BadgePosition.topEnd(),
          child: FloatingActionButton(
            key: keyActionButton,
            onPressed: () {
              switch (_currentIndex) {
                case 0:
                  {
                    if (_status == false) {
                      //getCsv(request.request!);
                      print('Estado: $_status');
                    } else {
                      EasyLoading.show(
                          status: 'Sincronizando acciones...',
                          maskType: EasyLoadingMaskType.custom);
                      Future.delayed(Duration(milliseconds: 2000))
                          .then((value) => {
                                setState(() {
                                  request.selectedStatus = "2";
                                  _status = true;
                                  _title = 'Acciones';
                                }),
                                EasyLoading.dismiss()
                              });
                    }
                    if (_controller.isOpened == true) {
                      _controller.hide();
                    }
                  }
                  break;
                case 1:
                  {
                    Navigator.push(context, MaterialPageRoute<Keycode>(
                      builder: (BuildContext context) {
                        return AddEditKeycodePage(
                          isCreateMode: true,
                          isEditMode: false,
                          isAutoMode: false,
                        );
                      },
                    )).then((result) {
                      if (result != null) {
                        setState(() {
                          super.widget;
                        });
                        print('Devuelve');
                      }
                    });
                  }
                  break;
                case 2:
                  {
                    Navigator.push(context, MaterialPageRoute(
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
          currentIndex: _currentIndex,
          onTap: changePage,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
          //border radius doesn't work when the notch is enabled.
          elevation: 8,
          hasInk: true,
          inkColor: Colors.black12,
          //tilesPadding: EdgeInsets.symmetric(vertical: 8.0,),
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.notification_important,
                color: _colors.iconsColor(context),
              ),
              activeIcon: Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              title: Text("Acciones"),
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
                  Icons.info,
                  color: _colors.iconsColor(context),
                ),
                activeIcon: Icon(
                  Icons.info,
                  color: Colors.green,
                ),
                title: Text("Acerca"))
          ],
        ),
      ),
    );
  }
}
