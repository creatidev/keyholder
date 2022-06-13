import 'package:flutter/cupertino.dart';

class LoginResponseModel {
  final String? token;
  final String? error;
  final String? message;

  LoginResponseModel({this.token, this.error, this.message});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json['token'] != null ? json['token'] : '',
        error: json['error'] != null ? json['error'] : '',
        message: json['message'] != null ? json['message'] : '');
  }
}

class LoginRequestModel {
  String? email;
  String? password;
  String? token;
  LoginRequestModel({this.email, this.password, @required this.token});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user': email!.trim(),
      'password': password!.trim(),
      'token': token!.trim()
    };

    return map;
  }
}

class StatusDataModel {
  StatusDataModel({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory StatusDataModel.fromJson(Map<String, dynamic> json) =>
      StatusDataModel(
        status: json['status'] != null ? json['status'] : '',
        message: json['message'] != null ? json['message'] : '',
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };
}
