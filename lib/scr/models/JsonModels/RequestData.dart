// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

Request requestFromJson(String str) => Request.fromJson(json.decode(str));

String requestToJson(Request data) => json.encode(data.toJson());

class Request {
  Request({
    this.status,
    this.message,
    this.actions,
  });

  bool? status;
  String? message;
  List<ActionDetails>? actions;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        status: json["status"],
        message: json["message"],
        actions: List<ActionDetails>.from(
            json["actions"].map((x) => ActionDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "actions": List<dynamic>.from(actions!.map((x) => x.toJson())),
      };
}

class ActionDetails {
  ActionDetails({
    this.id,
    this.name,
    this.ip,
    this.creationDate,
    this.status,
  });

  int? id;
  String? name;
  String? ip;
  DateTime? creationDate;
  String? status;

  factory ActionDetails.fromJson(Map<String, dynamic> json) => ActionDetails(
        id: json["id"],
        name: json["nombre"],
        ip: json["ip"],
        creationDate: DateTime.parse(json["fecha_creacion"]),
        status: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": name,
        "ip": ip,
        "fecha_creacion": creationDate!.toIso8601String(),
        "estado": status,
      };
}
