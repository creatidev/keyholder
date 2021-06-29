import 'dart:convert';
import 'dart:core';

import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<Categories> _listCategories = <Categories>[];

  String get password {
    return _prefs!.getString('password') ?? '0';
  }

  set password(String value) {
    _prefs!.setString('password', value);
  }

  int get keyCount {
    return _prefs!.getInt('keyCount') ?? 0;
  }

  set keyCount(int value) {
    _prefs!.setInt('keyCount', value);
  }

  bool? get firstSend {
    return _prefs!.getBool('firstSend') ?? true;
  }

  set firstSend(bool? value) {
    _prefs!.setBool('firstSend', value!);
  }

  bool? get firstViewCategory {
    return _prefs!.getBool('firstViewCategory') ?? true;
  }

  set firstViewCategory(bool? value) {
    _prefs!.setBool('firstViewCategory', value!);
  }

  bool? get firstCategory {
    return _prefs!.getBool('firstCategory') ?? true;
  }

  set firstCategory(bool? value) {
    _prefs!.setBool('firstCategory', value!);
  }

  bool? get firstViewKey {
    return _prefs!.getBool('firstViewKey') ?? true;
  }

  set firstViewKey(bool? value) {
    _prefs!.setBool('firstViewKey', value!);
  }

  bool? get firstKey {
    return _prefs!.getBool('firstKey') ?? true;
  }

  set firstKey(bool? value) {
    _prefs!.setBool('firstKey', value!);
  }

  bool? get firstKeyring {
    return _prefs!.getBool('firstKeyring') ?? true;
  }

  set firstKeyring(bool? value) {
    _prefs!.setBool('firstKeyring', value!);
  }

  bool? get firstRun {
    return _prefs!.getBool('firstRun') ?? true;
  }

  set firstRun(bool? value) {
    _prefs!.setBool('firstRun', value!);
  }

  String get userId {
    return _prefs!.getString('userId') ?? '0';
  }

  set userId(String value) {
    _prefs!.setString('userId', value);
  }

  String get alias {
    return _prefs!.getString('alias') ?? '0';
  }

  set alias(String value) {
    _prefs!.setString('alias', value);
  }

  String get userName {
    return _prefs!.getString('userName') ?? '0';
  }

  set userName(String value) {
    _prefs!.setString('userName', value);
  }

  String get lastName {
    return _prefs!.getString('lastName') ?? '0';
  }

  set lastName(String value) {
    _prefs!.setString('lastName', value);
  }

  String get email {
    return _prefs!.getString('email') ?? '0';
  }

  set email(String value) {
    _prefs!.setString('email', value);
  }

  String get phone {
    return _prefs!.getString('phone') ?? '0';
  }

  set phone(String value) {
    _prefs!.setString('phone', value);
  }

  List<Categories> get listCategories {
    return _listCategories;
  }
}
