// To parse this JSON data, do
//
//     final webDataModel = webDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';

WebDataModel webDataModelFromJson(String str) => WebDataModel.fromJson(json.decode(str));

String webDataModelToJson(WebDataModel data) => json.encode(data.toJson());

class WebDataModel {
  WebDataModel({
    this.status,
    this.message,
    this.information,
  });

  bool? status;
  String? message;
  Categories? information;

  factory WebDataModel.fromJson(Map<String, dynamic> json) => WebDataModel(
    status: json["status"],
    message: json["message"],
    information: Categories.fromJson(json["information"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "information": information!.toJson(),
  };
}