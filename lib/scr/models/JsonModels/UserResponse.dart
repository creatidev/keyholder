// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
    this.status,
    this.message,
    this.user,
  });

  bool? status;
  String? message;
  User? user;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    status: json["status"],
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.id,
    this.document,
    this.name,
    this.lastname,
    this.nickname,
    this.email,
    this.phone,
    this.cellphone,
  });

  int? id;
  int? document;
  String? name;
  String? lastname;
  String? nickname;
  String? email;
  int? phone;
  int? cellphone;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    document: json["document"],
    name: json["name"],
    lastname: json["lastname"],
    nickname: json["nickname"],
    email: json["email"],
    phone: json["phone"],
    cellphone: json["cellphone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "document": document,
    "name": name,
    "lastname": lastname,
    "nickname": nickname,
    "email": email,
    "phone": phone,
    "cellphone": cellphone,
  };
}
