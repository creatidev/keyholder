import 'package:flutter/material.dart';

class SignUpModel {
  String? email;
  String? password;
  String? repeatPassword;
  String? name;
  String? lastname;

  SignUpModel(
      {this.email,
      this.password,
      this.repeatPassword,
      this.name,
      this.lastname});
}
