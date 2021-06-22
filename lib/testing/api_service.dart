import 'dart:convert';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/RequestData.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/UserResponse.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/WebDataModel.dart';
import 'package:digitalkeyholder/testing/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _urlMain = 'https://quanticdatacenternoc.asicamericas.com/qbayes_restapi';
final _apiKey = 'f4e3ff1b-ac39-4d97-8ec2-3165141dfcef';

class APIService with ChangeNotifier {
  Request? request;
  int count = 0;
  bool _isLoading = true;
  String _selectedStatus = "2";
  final prefs = new UserPreferences();
  APIService() {
    this.getRequestedActions(_selectedStatus);
    //print(_listActions!.first.name);
    print("Api consultada");
  }

  bool get isLoading => this._isLoading;

  String get selectedStatus => this._selectedStatus;

  set selectedStatus(String value) {
    this._selectedStatus = value;

    this._isLoading = true;
    this.getRequestedActions(value);
    notifyListeners();
  }

  getRequestedActions(String status) async {
    print('Obteniendo datos...');
    String? url = '$_urlMain/get_user_actions';
    final response = await http.post(Uri.parse(url),
        body: {"user_id": prefs.userId, "status": status},
        headers: {'X-API-KEY': _apiKey});

    final data = jsonDecode(response.body);
    var decodedInfo = utf8.decode(base64.decode(data['information']));
    print(decodedInfo);
    final categoriesResponse = requestFromJson(decodedInfo);
    count = categoriesResponse.actions!.length;
    request = categoriesResponse;

    print('Datos obtenidos...');

    notifyListeners();
  }

 Future<UserResponse> login(LoginRequestModel requestModel) async {
    String? url = '$_urlMain/user_login';
    final response = await http.post(Uri.parse(url),
        body: requestModel.toJson(), headers: {'X-API-KEY': _apiKey});

    if (response.statusCode == 200 || response.statusCode == 400) {
      print(response.statusCode);
      print(response.body + '***');

        return UserResponse.fromJson(json.decode(response.body));


    } else {
      throw Exception('No se pudieron cargar los datos');
    }
  }

  Future<StatusDataModel> logout() async {
    String? url = '$_urlMain/user_logout';
    final response = await http.post(Uri.parse(url),
        body: {"user_id": prefs.userId}, headers: {'X-API-KEY': _apiKey});
    print(response.statusCode);
    print(response.body + '***');
    if (response.statusCode == 200 || response.statusCode == 400) {
      return StatusDataModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudieron cargar los datos');
    }
  }

  Future<WebDataModel> getDataOfRequest(String actionId) async {
    String? url = '$_urlMain/get_params_action';
    final response = await http.post(Uri.parse(url), body: {
      "action_id": actionId,
    }, headers: {
      'X-API-KEY': _apiKey
    });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = jsonDecode(response.body);
      var decodedInfo = utf8.decode(base64.decode(data['information']));
      print(json.decode(decodedInfo));
      return WebDataModel.fromJson(json.decode(decodedInfo));
    } else {
      throw Exception('No se pudieron cargar los datos');
    }
  }

  Future<StatusDataModel> sendData(String categories) async {
    var bytes = utf8.encode(categories);
    var base64Str = base64.encode(bytes);
    String? url = '$_urlMain/set_robot_params';
    final response = await http.post(Uri.parse(url),
        body: {'params': base64Str}, headers: {'X-API-KEY': _apiKey});
    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = jsonDecode(response.body);
      var decodedInfo = utf8.decode(base64.decode(data['information']));
      print(json.decode(decodedInfo));
      return StatusDataModel.fromJson(json.decode(decodedInfo));
    } else {
      throw Exception('No se pudieron cargar los datos');
    }
  }
}
