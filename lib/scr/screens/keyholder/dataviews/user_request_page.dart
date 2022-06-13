import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/RequestData.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/keyring_builder_page.dart';
import 'package:digitalkeyholder/scr/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class UserRequestList extends StatefulWidget {
  const UserRequestList({
    Key? key,
    required this.status,
    required this.demoMode,
  }) : super(key: key);
  final bool? status;
  final bool? demoMode;

  //final
  @override
  _UserRequestListState createState() => _UserRequestListState();
}

class _UserRequestListState extends State<UserRequestList> {
  int? requirementStatus;
  bool? _statusId;
  var _actionId;
  CancelDataModel? cancelDataModel;
  String? jsonCategories;
  int keyCount = 0;
  CustomColors _colors = new CustomColors();
  APIService apiService = new APIService();
  List<TargetFocus> targets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future setJson(Categories? categories) async {
    _actionId = categories!.actionId;
    cancelDataModel = new CancelDataModel(
      actionid: _actionId,
      status: _statusId,
    );
    jsonCategories = jsonEncode(cancelDataModel);
  }

  //List<Keycode>? _requestCategories;
  Categories? mapedCategories;

  Future<Categories> getDataOfRequest(String actionId) async {
    Future.delayed(Duration(milliseconds: 1000));
    var categories;
    var data = apiService.getDataOfRequest(actionId);
    await data.then((value) {
      mapedCategories = value.information;
    });
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    String jsonDemo =
        '{"status":true,"message":"Consulta exitosa.","actions":[{"id":0,"nombre":"TUTORIAL DE DEMOSTRACIÓN EN PROCESO...","ip":"127.0.0.1","fecha_creacion":"${DateTime.now()}","estado":"generada"}]}';
    Request? _request;
    final ScrollController _scrollController = ScrollController();
    final request = Provider.of<APIService>(context).request;
    if (widget.demoMode == true) {
      _request = Request.fromJson(json.decode(jsonDemo));
    } else {
      _request = Provider.of<APIService>(context).request;
    }

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            (_request != null)
                ? Container(
                    padding: EdgeInsets.all(0),
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: _request.actions!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _requiredKeyringCard(
                              _request!.actions!, index);
                        }),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  Widget _requiredKeyringCard(List<ActionDetails> actionDetails, int index) {
    var status = widget.status;
    var actionStatus = actionDetails[index].status.toString();
    print(actionStatus);
    var time1 = actionDetails[index].creationDate!;
    final now = DateTime.now();
    final difference = now.difference(time1);
    final fifteenAgo = DateTime.now().subtract(difference);
    final request = Provider.of<APIService>(context);
    var actId = actionDetails[index].id.toString();
    var actIp = actionDetails[index].ip.toString();
    var actionName = actionDetails[index].name;

    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NeumorphicIcon(
                      Icons.pause,
                      size: 40,
                      style: NeumorphicStyle(
                          color: Colors.orange,
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10)),
                          shadowLightColor: Colors.deepOrange,
                          depth: 1,
                          intensity: 0.7),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                width: 110,
                height: 40,
                child: Visibility(
                  visible: status!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FormHelper.showMessage(
                            context,
                            "QBayes NOC",
                            "¿Desea cancelar esta acción?",
                            "Si",
                            () {
                              _statusId = false;
                              EasyLoading.show(
                                  status: 'Cancelando acción...',
                                  maskType: EasyLoadingMaskType.custom);

                              getDataOfRequest(actId).then((value) {
                                setJson(mapedCategories);
                                APIService apiService = new APIService();
                                print(jsonCategories);
                                apiService
                                    .sendData(jsonCategories!)
                                    .then((value) {
                                  setState(() => request.selectedStatus = "2");
                                  EasyLoading.showSuccess(
                                          "Acción cancelada por el usuario.",
                                          maskType: EasyLoadingMaskType.custom,
                                          duration:
                                              Duration(milliseconds: 1000))
                                      .then((value) =>
                                          {Navigator.of(context).pop()});
                                });
                              });
                            },
                            buttonText2: "No",
                            isConfirmationDialog: true,
                            onPressed2: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        child: NeumorphicIcon(
                          Icons.stop,
                          size: 40,
                          style: NeumorphicStyle(
                              color: Colors.red,
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: Colors.deepOrange,
                              depth: 1,
                              intensity: 0.7),
                        ),
                      ),
                      VerticalDivider(),
                      GestureDetector(
                        onTap: () {
                          print('Siguiente');
                          EasyLoading.show(
                              status: 'Obteniendo datos del servidor...',
                              maskType: EasyLoadingMaskType.custom);
                          Future.delayed(Duration(milliseconds: 1000))
                              .then((value) {
                            getDataOfRequest(actId).then((value) {
                              EasyLoading.dismiss();
                              Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return KeyringBuilder(
                                    client: actIp,
                                    keyringIndex: index,
                                    isAutoMode: true,
                                    mappedCategories: mapedCategories!.toJson(),
                                  );
                                },
                              ));
                            });
                          });
                        },
                        child: NeumorphicIcon(
                          Icons.skip_next,
                          size: 40,
                          style: NeumorphicStyle(
                              color: Colors.green,
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: Colors.lightGreen,
                              depth: 1,
                              intensity: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Container(
                width: 200,
                height: 60,
                padding: EdgeInsets.all(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      '$actId - $actionName',
                      maxLines: 2,
                      minFontSize: 7,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.computer,
                          color: _colors.iconsColor(context),
                          size: 15,
                        ),
                        Text(
                          actIp,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      timeago.format(fifteenAgo, locale: 'es'),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
