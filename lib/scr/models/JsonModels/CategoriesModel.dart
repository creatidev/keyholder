// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

import 'package:digitalkeyholder/scr/models/model.dart';

List<Categories> listCategoriesFromJson(String str) =>
    List<Categories>.from(json.decode(str).map((x) {
      print(x.runtimeType);
      Categories.fromJson(x);
    }));

String listCategoriesToJson(List<Categories> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Categories categoriesFromJson(String str) =>
    Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories extends Model {
  static String table = 'categorytable';

  int? id;
  int? actionId;
  bool? status;
  String? category;
  List<Keycode>? categories;

  Categories({
    this.id,
    this.actionId,
    this.status,
    this.category,
    this.categories,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'category': category,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Categories fromMap(Map<String, dynamic> map) {
    return Categories(id: map['id'], category: map['category']);
  }

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        actionId: json['actionid'] as int,
        status: json['status'] as bool,
        category: json['category'],
        categories: List<Keycode>.from(
            json['categories'].map((x) => Keycode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'actionid': actionId,
        'status': status,
        'categories': List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Keycode extends Model {
  static String table = 'keycodetable';

  int? id;
  String? name;
  String? label;
  String? ip;
  String? user;
  String? password;
  dynamic port;
  String? instance;
  String? regDate;
  int? action;
  String? uses;

  Keycode({
    this.id,
    this.name,
    this.label,
    this.ip,
    this.user,
    this.password,
    this.port,
    this.instance,
    this.regDate,
    this.action,
    this.uses,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'label': label,
      'ip': ip,
      'user': user,
      'password': password,
      'port': port,
      'instance': instance,
      'regdate': regDate,
      'action': action,
      'uses': uses,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Keycode fromMap(Map<String, dynamic> map) {
    return Keycode(
      id: map['id'],
      name: map['name'],
      label: map['label'],
      ip: map['ip'],
      user: map['user'],
      password: map['password'],
      port: map['port'],
      instance: map['instance'],
      regDate: map['regdate'],
      action: map['action'],
      uses: map['uses'],
    );
  }

  factory Keycode.fromJson(Map<String, dynamic> json) => Keycode(
      id: json['id'],
      name: json['name'],
      label: json['label'],
      ip: json['ip'],
      user: json['user'],
      password: json['password'],
      port: json['port'],
      instance: json['instance'],
      regDate: json['regdate'],
      action: json['action'],
      uses: json['uses']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'ip': ip,
        'user': user,
        'password': password,
        'port': port,
        'instance': instance
      };
}

class CancelDataModel {
  CancelDataModel({
    this.actionid,
    this.status,
  });

  int? actionid;
  bool? status;

  factory CancelDataModel.fromJson(Map<String, dynamic> json) =>
      CancelDataModel(
        actionid: json["actionid"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "actionid": actionid,
        "status": status,
      };
}
