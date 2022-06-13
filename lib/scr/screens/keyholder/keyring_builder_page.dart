import 'dart:convert';
import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/progress.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/add_edit_keycode_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/keycode_details_page.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:digitalkeyholder/scr/services/api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class KeyringBuilder extends StatefulWidget {
  const KeyringBuilder({
    Key? key,
    this.isAutoMode,
    this.mappedCategories,
    required this.keyringIndex,
    required this.client,
  }) : super(key: key);
  final int? keyringIndex;
  final String? client;
  final mappedCategories;
  final bool? isAutoMode;
  @override
  _KeyringBuilderState createState() => _KeyringBuilderState();
}

class _KeyringBuilderState extends State<KeyringBuilder> {
  final prefs = new UserPreferences();
  CustomColors _colors = new CustomColors();
  var keyHelp = GlobalKey();
  var keyLogo = GlobalKey();
  var keyActionButton = GlobalKey();
  var keyCancel = GlobalKey();
  var keyMessage = GlobalKey();
  DBService? dbService;
  Categories? categoryModel;
  int? keyCount;
  String? getKeys;
  String? getCategory;
  bool isApiCallProcess = false;
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
  List<TargetFocus> targets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Iniciar Keyring');

    categoryModel = new Categories();
    dbService = new DBService();

    _foundCategories = <Keycode>[];
    if (widget.mappedCategories != null) {
      print(widget.mappedCategories);
      _categoriesFromJson = new Categories.fromJson(widget.mappedCategories);
    }
    if (widget.isAutoMode == true) {
      setJson(_categoriesFromJson!);
    }

    setTutorial();
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
                      "Completar acción",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "En esta sección se procederá a realizar la recopilación de las llaves registradas para posteriormente realizar el envío. Este tutorial lo guiará a travéz de todo el proceso. Para volver a visualizarlo, presione sobre el icono señalado.",
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
        targetPosition: TargetPosition(Size(400, 240), Offset(0.0, 175.0)),
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
                      "Lista de llaves requeridas",
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
                                    Icons.turned_in,
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
                                    'Llave disponible o registrada',
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
                                    Icons.turned_in_not,
                                    color: Colors.redAccent,
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
                                    'Llave no disponible',
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
        identify: "Target 2",
        //keyTarget: keyList,
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 20), Offset(0.0, 130.0)),
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
                      "Estado de la acción",
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
                                    'Acción disponible para envíar',
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
                                    Icons.pause,
                                    color: Colors.redAccent,
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
                                    'Acción incompleta',
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
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(150, 35), Offset(90.0, 200.0)),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Categoría y estado de la llave.",
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
        identify: "Target 4",
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(350, 60), Offset(20.0, 190.0)),
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
                      "Llave",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Categoría y estado de la llave.",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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
                                      "Si presiona la llave requerida cuando el marcador indique ",
                                ),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.turned_in,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " podrá visualizar o editar la llave seleccionada.",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Si presiona la llave requerida cuando el marcador indique ",
                                ),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.turned_in_not,
                                    size: 14,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " 'No disponible' se procederá con la creación de la llave seleccionada. \n\n",
                                ),
                                TextSpan(
                                  text:
                                      "Siempre que se cree o edite una llave, la acción se refrescará de forma automática.",
                                ),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.refresh,
                                    size: 14,
                                    color: Colors.redAccent,
                                  ),
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
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 100), Offset(0.0, 580.0)),
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Detalles del llavero requerido",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Información detallada de la acción.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 6",
        shape: ShapeLightFocus.RRect,
        keyTarget: keyActionButton,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Acciones",
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
                          0: FlexColumnWidth(20),
                          1: FlexColumnWidth(80)
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.redAccent,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Verificar llaves disponibles',
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
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.skip_next,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Enviar acción completada',
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
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 7",
        shape: ShapeLightFocus.RRect,
        keyTarget: keyCancel,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Volver atrás",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Regresa a la pantalla anterior, no se cancelará el envío del llavero y no se perderá ningún cambio guardado, podrá enviarlo más adelante.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 8",
        keyTarget: keyMessage,
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
                      "Mensaje de estado actual",
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
                                      "Muestra una descripción del estado actual de la acción teniendo en cuenta las llaves solicitadas contra las llaves encontradas.\n\n",
                                ),
                                TextSpan(
                                  text:
                                      "Cuando el llavero esté disponible aparecerá un mensaje con pendiente por envío.",
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
  }

  void setRequest() {
    targets.clear();
    targets.add(TargetFocus(
        identify: "Target 0",
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(Size(400, 100), Offset(0.0, 580.0)),
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Llavero disponible para envío",
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
                                WidgetSpan(
                                    child: Icon(
                                  Icons.skip_next,
                                  color: Colors.green,
                                  size: 20,
                                )),
                                TextSpan(
                                  text:
                                      "Cuando las llaves solicitadas sean iguales a las llaves encontradas (Registradas o almacenadas), se habilitará el envío del llavero.\n\n",
                                ),
                                WidgetSpan(
                                    child: Icon(
                                  Icons.cancel,
                                  color: Colors.redAccent,
                                  size: 20,
                                )),
                                TextSpan(
                                  text:
                                      "...o bien puede cancelar de momento y envíar más adelante.",
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
        shape: ShapeLightFocus.RRect,
        keyTarget: keyActionButton,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Enviar llavero disponible",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "A continuación presione el botón para envíar.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
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
        onFinish: () {}, onClickTarget: (target) {
      print(target);
      print('Presionado');
    }, onSkip: () {
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
      await Future.delayed(Duration(milliseconds: 500));
      getCategory = "SELECT * FROM categorytable WHERE category = "
          "'${selectedValue.name}'";

      await dbService!.getKeycodeByCategory(getCategory).then((value) {
        if (value.length == 0) {
          categoryModel!.category = selectedValue.name;
          dbService!.addCategory(categoryModel!);
        }
      });

      if (value.ip != null) {
        getKeys = "SELECT * FROM keycodetable WHERE name ="
            " '${value.name}' AND ip = '${value.ip}'";
      }
      if (value.ip == '') {
        getKeys = "SELECT * FROM keycodetable WHERE name ="
            " '${value.name}' AND action = '$_actionId'";
      }

      await dbService!.getKeycodeByCategory(getKeys).then((value) {
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
      _status = false;
      EasyLoading.showError('Por favor registre las llaves faltantes',
          maskType: EasyLoadingMaskType.custom,
          duration: Duration(milliseconds: 1000));
      if (prefs.firstKeyring == true) {
        Future.delayed(Duration(microseconds: 3500)).then((value) {
          showTutorial();
        });
        prefs.firstKeyring = false;
      }
    }

    if (_notFound == 0) {
      _title = 'Llavero disponible para el envío...';
      _success = true;
      _status = true;
      _categoriesToJson = new Categories(
          actionId: _actionId, status: _status, categories: _foundCategories);
      print('Llaves ingresadas $_found');
      _jsonCategories = jsonEncode(_categoriesToJson);

      print('Llavero disponible');
      if (prefs.firstSend == true) {
        setRequest();
        showTutorial();
        prefs.firstSend = false;
      }
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

  Widget uiBuild(BuildContext context) {
    final request = Provider.of<APIService>(context);
    var langWords = LangWords();
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        lightSource: LightSource.topLeft,
        accentColor: NeumorphicColors.accent,
        appBarTheme: NeumorphicAppBarThemeData(
            buttonStyle: NeumorphicStyle(
              color: _colors.textColor(context),
              shadowLightColor: _colors.textColor(context),
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
          leading: Container(
              padding: EdgeInsets.all(8),
              child: Container(
                width: 55,
                height: 55,
                //color: Colors.lightBlue,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    NeumorphicIcon(
                      QuanticLogo.logon,
                      size: 45,
                      style: NeumorphicStyle(
                          color: Colors.redAccent,
                          shadowLightColor: Colors.red,
                          depth: 1,
                          intensity: 0.7),
                    ),
                    NeumorphicIcon(
                      Icons.skip_next,
                      size: 15,
                      style: NeumorphicStyle(
                          color: Colors.lightBlueAccent,
                          shadowLightColor: Colors.lightBlueAccent,
                          depth: 1,
                          intensity: 0.7),
                    ),
                  ],
                ),
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicText(
                langWords.mainName!,
                //key: keyWelcome,
                style: NeumorphicStyle(
                  color: _colors.iconsColor(context),
                  intensity: 0.7,
                  depth: 1.5,
                  shadowLightColor: _colors.shadowColor(context),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 16,
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
                  "¿Ver tutorial de la sección?",
                  "Si",
                  () {
                    setTutorial();
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
                            _status == true
                                ? GestureDetector(
                                    onTap: () {
                                      setRequest();
                                      showTutorial();
                                    },
                                    child: NeumorphicIcon(
                                      Icons.skip_next,
                                      size: 35,
                                      style: NeumorphicStyle(
                                          color: Colors.green,
                                          shape: NeumorphicShape.flat,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(10)),
                                          shadowLightColor: Colors.deepPurple,
                                          depth: 1.5,
                                          intensity: 0.7),
                                    ),
                                  )
                                : NeumorphicIcon(
                                    Icons.pause,
                                    size: 35,
                                    style: NeumorphicStyle(
                                        color: _status == false
                                            ? Colors.redAccent
                                            : Colors.green,
                                        shape: NeumorphicShape.flat,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(10)),
                                        shadowLightColor: Colors.deepPurple,
                                        depth: 1.5,
                                        intensity: 0.7),
                                  ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                    ],
                  ),
                ),
                Container(
                  //color: Colors.deepPurpleAccent,
                  padding: EdgeInsets.all(10),
                  //color: Colors.lightBlueAccent,
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: _foundCategories!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _keycodeView(_foundCategories!, index);
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  child: Table(
                    border:
                        TableBorder.all(color: _colors.borderColor(context)),
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: _colors.textColor(context)),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: _colors.textColor(context),
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
                                'IP',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: _colors.textColor(context)),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: _colors.textColor(context),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: _colors.textColor(context),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: _colors.textColor(context),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: _colors.textColor(context),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: _colors.textColor(context),
                                ),
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
                    intensity: 3),
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
                  Navigator.of(context).pop();
                },
              ),
              NeumorphicFloatingActionButton(
                key: keyActionButton,
                style: NeumorphicStyle(
                    color: _colors.contextColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 2,
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
                          Icons.refresh,
                          color: Colors.redAccent,
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
                          maskType: EasyLoadingMaskType.custom,
                          duration: Duration(milliseconds: 3000));
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
      ),
    );
  }

  Card _keycodeView(List<Keycode> keycodes, int index) {
    return Card(
      child: ListTile(
        title: Text(keycodes[index].label!),
        subtitle: Text(keycodes[index].name!),
        leading: NeumorphicIcon(
          Icons.vpn_key,
          size: 35,
          style: NeumorphicStyle(
              color: Colors.deepPurpleAccent,
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
              shadowLightColor: Colors.deepPurple,
              depth: 1.5,
              intensity: 0.7),
        ),
        trailing: keycodes[index].user == ''
            ? NeumorphicIcon(
                Icons.turned_in_not,
                size: 35,
                style: NeumorphicStyle(
                    color: Colors.redAccent,
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: Colors.redAccent,
                    depth: 1.5,
                    intensity: 0.7),
              )
            : NeumorphicIcon(
                Icons.turned_in,
                size: 35,
                style: NeumorphicStyle(
                    color: Colors.green,
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: Colors.green,
                    depth: 1.5,
                    intensity: 0.7),
              ),
        onTap: () {
          if (keycodes[index].user == '') {
            Navigator.push(context, MaterialPageRoute<Keycode>(
              builder: (BuildContext context) {
                return AddEditKeycodePage(
                  keycodeModel: keycodes[index],
                  actId: _categoriesFromJson!.actionId,
                  isCreateMode: true,
                  isEditMode: false,
                  isAutoMode: true,
                );
              },
            )).then((result) {
              if (result != null) {
                keycodes[index].ip = result.ip;
                setState(() => _found = 0);
                setState(() => _foundCategories!.clear());
                setJson(_categoriesFromJson!);
                setState(() =>
                    _categoriesFromJson!.categories![index].ip = result.ip!);

                print('Retorna ${result.ip}');
              } else {
                print('Sin editar');
              }
            });
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute<bool>(
                    builder: (context) => KeycodeDetails(
                          keycodeModel: keycodes[index],
                        )))
                .then((result) => {
                      if (result == true)
                        {
                          setState(() => _found = 0),
                          setState(() => _foundCategories!.clear()),
                          setJson(_categoriesFromJson!)
                        }
                    });
          }
        },
      ),
    );
  }
}
