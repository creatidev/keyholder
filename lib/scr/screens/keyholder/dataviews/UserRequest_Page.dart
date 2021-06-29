import 'dart:convert';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/RequestData.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:digitalkeyholder/testing/KeyringBuilder_page.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserRequestList extends StatefulWidget {
  const UserRequestList({
    Key? key,
    this.textColor,
    this.iconColor,
    this.shadowColor,
    required this.status,
    required this.demoMode,
  }) : super(key: key);
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;
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
  //bool? demoMode = false;
  CancelDataModel? cancelDataModel;
  String? jsonCategories;
  int keyCount = 0;
  CustomColors _colors = new CustomColors();

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
    APIService apiService = new APIService();
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
        '{"status":true,"message":"Consulta exitosa.","actions":[{"id":0,"nombre":"Demostración","ip":"127.0.0.1","fecha_creacion":"${DateTime.now()}","estado":"generada"}]}';
    Request? _request;
    final ScrollController _scrollController = ScrollController();
    //final request = Provider.of<APIService>(context).request;
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
    IconData leadingIcon = Icons.hourglass_bottom;
    Color leadingIconColor = _colors.iconsColor(context);
    Color leadingShadowIconColor = _colors.shadowColor(context);
    switch (actionStatus) {
      case 'generada':
        {
          leadingIcon = Icons.hourglass_bottom;
          leadingIconColor = _colors.iconsColor(context);
          leadingShadowIconColor = _colors.shadowColor(context);
        }
        break;
      case 'rechazada':
        {
          leadingIcon = Icons.stop;
          leadingIconColor = Colors.redAccent;
          leadingShadowIconColor = Colors.red;
        }
        break;
      case 'ejecucion':
        {
          leadingIcon = Icons.skip_next;
          leadingIconColor = Colors.green;
          leadingShadowIconColor = Colors.green;
        }
        break;
      case 'falla':
        {
          leadingIcon = Icons.error;
          leadingIconColor = Colors.redAccent;
          leadingShadowIconColor = Colors.red;
        }
        break;
      case 'pendiente':
        {
          leadingIcon = Icons.pause;
          leadingIconColor = Colors.deepOrangeAccent;
          leadingShadowIconColor = Colors.deepOrange;
        }
        break;
    }

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
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NeumorphicIcon(
                      leadingIcon,
                      size: 40,
                      style: NeumorphicStyle(
                          color: leadingIconColor,
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10)),
                          shadowLightColor: leadingShadowIconColor,
                          depth: 1.5,
                          intensity: 0.7),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                width: 120,
                height: 50,
                child: Visibility(
                  visible: status!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FormHelper.showMessage(
                            context,
                            "QBayes Step Up!",
                            "¿Desea cancelar este requerimiento?",
                            "Si",
                            () {
                              _statusId = false;
                              EasyLoading.show(
                                  status: 'Cancelando requerimiento...',
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
                                          "Requerimiento cancelado por el usuario.",
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
                          size: 45,
                          style: NeumorphicStyle(
                              color: Colors.redAccent,
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: Colors.red,
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                      ),
                      VerticalDivider(),
                      GestureDetector(
                        onTap: () {
                          print('Siguiente');
                          EasyLoading.show(
                              status: 'Preparando requerimiento...',
                              maskType: EasyLoadingMaskType.custom);
                          getDataOfRequest(actId).then((value) {
                            EasyLoading.dismiss();
                            Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                                return KeyringBuilder(
                                  client: actIp,
                                  keyringIndex: index,
                                  isAutoMode: true,
                                  mapedCategories: mapedCategories!.toJson(),
                                );
                              },
                            ));
                          });
                        },
                        child: NeumorphicIcon(
                          Icons.skip_next,
                          size: 45,
                          style: NeumorphicStyle(
                              color: Colors.green,
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: Colors.lightGreen,
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('$actId - ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(
                        actionName!.length > 15
                            ? actionName.substring(0, 14) + '...'
                            : '$actionName',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Ip destino: ',
                          style: TextStyle(color: _colors.iconsColor(context))),
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
          ],
        ),
      ),
    );
  }
}
