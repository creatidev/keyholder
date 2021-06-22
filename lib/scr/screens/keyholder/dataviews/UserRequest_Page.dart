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
    required this.requirementStatus,
  }) : super(key: key);
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;
  final int? requirementStatus;
  @override
  _UserRequestListState createState() => _UserRequestListState();
}

class _UserRequestListState extends State<UserRequestList> {
  int? requirementStatus;
  bool? _status;
  var actionId;
  CancelDataModel? cancelDataModel;
  String? jsonCategories;
  int keyCount = 0;
  CustomColors _colors = new CustomColors();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.requirementStatus != null) {
      requirementStatus = widget.requirementStatus;
    }
  }

  Future setJson(Categories? categories) async {
    actionId = categories!.actionId;
    cancelDataModel = new CancelDataModel(
      actionid: actionId,
      status: _status,
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
    final ScrollController _scrollController = ScrollController();
    final request = Provider.of<APIService>(context).request;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            (request != null)
                ? Container(
                    padding: EdgeInsets.all(0),
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: request.actions!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _requiredKeyringCard(request.actions!, index);
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
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 70,
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageIcon(
                      AssetImage("assets/order.png"),
                      color: _colors.textColor(context),
                      size: 45.0,
                    ),
                  ],
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
                      Text('Cliente: ',
                          style: TextStyle(color: _colors.textColor(context))),
                      Text(
                        actIp,
                        style: TextStyle(
                          fontSize: 14,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    FormHelper.showMessage(
                      context,
                      "QBayes Step Up!",
                      "¿Desea cancelar este requerimiento?",
                      "Si",
                      () {
                        _status = false;
                        EasyLoading.show(
                            status: 'Cancelando requerimiento...',
                            maskType: EasyLoadingMaskType.custom);
                        getDataOfRequest(actId).then((value) {
                          setJson(mapedCategories);
                          APIService apiService = new APIService();
                          print(jsonCategories);
                          apiService.sendData(jsonCategories!).then((value) {
                            setState(() => request.selectedStatus = "2");
                            EasyLoading.showSuccess(
                                    "Requerimiento cancelado por el usuario.",
                                    maskType: EasyLoadingMaskType.custom,
                                    duration: Duration(milliseconds: 1000))
                                .then((value) => {Navigator.of(context).pop()});
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
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Siguiente'),
                  onPressed: () {
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
                            borderColor: _colors.borderColor(context),
                            iconColor: _colors.iconsColor(context),
                            shadowColor: _colors.shadowColor(context),
                            textColor: _colors.textColor(context),
                            mapedCategories: mapedCategories!.toJson(),
                          );
                        },
                      ));
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
