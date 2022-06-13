import 'dart:convert';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/RequestData.dart';
import 'package:digitalkeyholder/scr/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class QueryData extends StatefulWidget {
  const QueryData({
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
  _QueryDataState createState() => _QueryDataState();
}

class _QueryDataState extends State<QueryData> {
  var myFormat = DateFormat('d-MM-yyyy');
  List<String> _listStatus = ['Pendiente', 'Otros'];
  CustomColors _colors = new CustomColors();
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? requirementStatus;
  bool? _statusId;
  var _actionId;
  CancelDataModel? cancelDataModel;
  String? jsonCategories;
  int keyCount = 0;
  //String? filePath;
  var _sortAscending = true;

/*
  Future setJson(Categories? categories) async {
    _actionId = categories!.actionId;
    cancelDataModel = new CancelDataModel(
      actionid: _actionId,
      status: _statusId,
    );
    jsonCategories = jsonEncode(cancelDataModel);
  }
*/

  //Categories? mapedCategories;

/*  Future<Categories> getDataOfRequest(String actionId) async {
    APIService apiService = new APIService();
    Future.delayed(Duration(milliseconds: 1000));
    var categories;

    var data = apiService.getDataOfRequest(actionId);
    await data.then((value) {
      mapedCategories = value.information;
    });
    return categories;
  }*/

  @override
  Widget build(BuildContext context) {
    String jsonDemo =
        '{"status":true,"message":"Consulta exitosa.","actions":[{"id":0,"nombre":"Demostración","ip":"127.0.0.1","fecha_creacion":"${DateTime.now()}","estado":"generada"}]}';
    Request? _request;

    if (widget.demoMode == false) {
      _request = Request.fromJson(json.decode(jsonDemo));
    } else {
      _request = Provider.of<APIService>(context).request;
    }

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: FormBuilderDropdown(
                name: 'status',
                //icon: Icon(Icons.sort),
                decoration: InputDecoration(labelText: 'Estado'),
                hint: Text('Selecione estado'),
                initialValue: _listStatus[0],
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                items: _listStatus
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text('$status')))
                    .toList(),
                onChanged: (status) {
                  setState(() {
                    final request =
                        Provider.of<APIService>(context, listen: false);
                    if (status == _listStatus[0]) {
                      print(status);
                      request.selectedStatus = "2";
                    } else if (status == _listStatus[1]) {
                      request.selectedStatus = "1";
                      print(status);
                    }
                  });
                },
              ),
            ),
            (_request != null)
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: PaginatedDataTable(
                      header: Text(
                        'Acciones',
                        style: TextStyle(color: Colors.orange),
                      ),
                      rowsPerPage: _rowsPerPage,
                      sortAscending: _sortAscending,
                      sortColumnIndex: 0,
                      availableRowsPerPage: <int>[5, 10, 20],
                      onRowsPerPageChanged: (value) {
                        setState(() {
                          _rowsPerPage = value!;
                        });
                      },
                      source: KeyDataSource(_request.actions!),
                      columns: [
                        DataColumn(
                            label: Text(
                              'Id',
                              style:
                                  TextStyle(color: _colors.textColor(context)),
                            ),
                            numeric: true,
                            onSort: (index, sortAscending) {
                              setState(() {
                                _sortAscending = sortAscending;
                                if (sortAscending) {
                                  _request!.actions!
                                      .sort((a, b) => a.id!.compareTo(b.id!));
                                } else {
                                  _request!.actions!
                                      .sort((a, b) => b.id!.compareTo(a.id!));
                                }
                              });
                            }),
                        DataColumn(
                          label: Text(
                            'Nombre',
                            style: TextStyle(color: _colors.textColor(context)),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'Dirección Ip',
                            style: TextStyle(color: _colors.textColor(context)),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'Fecha de creación',
                            style: TextStyle(color: _colors.textColor(context)),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'Estado',
                            style: TextStyle(color: _colors.textColor(context)),
                          ),
                          numeric: true,
                        ),
                      ],
                    ),
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
}

////// Data source class for obtaining row data for PaginatedDataTable.
class KeyDataSource extends DataTableSource {
  final List<ActionDetails> _listActionDetails;
  KeyDataSource(this._listActionDetails);

  int _selectedCount = 0;
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final ActionDetails actionDetails = _listActionDetails[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${actionDetails.id}')),
      DataCell(Text('${actionDetails.name}')),
      DataCell(Text('${actionDetails.ip}')),
      DataCell(Text(DateFormat('yyyy-MM-dd -- hh:mm a')
          .format(actionDetails.creationDate!))),
      DataCell(Text('${actionDetails.status}')),
    ]);
  }

  @override
  int get rowCount => _listActionDetails.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
