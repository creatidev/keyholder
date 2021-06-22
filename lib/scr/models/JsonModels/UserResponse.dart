// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
    this.status,
    this.message,
    this.user,
    this.groups,
  });

  bool? status;
  String? message;
  User? user;
  List<Group>? groups;

  bool checkIfAnyIsNull() {
    return [status, message, user, groups].contains(null);
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        status: json["status"] != null ? json["status"] : '',
        message: json["message"] != null ? json["message"] : '',
        user: User.fromJson(json["user"]),
        groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user!.toJson(),
        "groups": List<dynamic>.from(groups!.map((x) => x.toJson())),
      };
}

class Group {
  Group({
    this.idGrupo,
    this.gruNombre,
    this.gruDescripcion,
  });

  String? idGrupo;
  String? gruNombre;
  String? gruDescripcion;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        idGrupo: json["id_grupo"],
        gruNombre: json["gru_nombre"],
        gruDescripcion: json["gru_descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "id_grupo": idGrupo,
        "gru_nombre": gruNombre,
        "gru_descripcion": gruDescripcion,
      };
}

class User {
  User({
    this.idUsuario,
    this.usuDni,
    this.usuNombre,
    this.usuApellido,
    this.usuAlias,
    this.usuMail,
    this.usuTelefono,
    this.usuCelular,
    this.usuToken,
  });

  String? idUsuario;
  String? usuDni;
  String? usuNombre;
  String? usuApellido;
  String? usuAlias;
  String? usuMail;
  String? usuTelefono;
  String? usuCelular;
  String? usuToken;

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUsuario: json["id_usuario"],
        usuDni: json["usu_dni"],
        usuNombre: json["usu_nombre"],
        usuApellido: json["usu_apellido"],
        usuAlias: json["usu_alias"],
        usuMail: json["usu_mail"],
        usuTelefono: json["usu_telefono"],
        usuCelular: json["usu_celular"],
        usuToken: json["usu_token"],
      );

  Map<String, dynamic> toJson() => {
        "id_usuario": idUsuario,
        "usu_dni": usuDni,
        "usu_nombre": usuNombre,
        "usu_apellido": usuApellido,
        "usu_alias": usuAlias,
        "usu_mail": usuMail,
        "usu_telefono": usuTelefono,
        "usu_celular": usuCelular,
        "usu_token": usuToken,
      };
}
