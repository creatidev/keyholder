import 'dart:convert';
import 'dart:core';

import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:flutter/cupertino.dart';
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

  final List<String> _categories = <String>[];
  List<Categories> _listCategories = <Categories>[];

  Keycode keycode = new Keycode();



  storedKeycode(keycodeMap){
    _prefs!.setString('keycode', json.encode(keycodeMap));
  }

  String get restoreKeycode{
  return _prefs!.getString('keycode') ?? '';
  }

  String get userId {
    return _prefs!.getString('userId') ?? 'none';
  }

  set userId(String value) {
    _prefs!.setString('userId', value);
  }

  setStringListValue(String key, List<String> value) async {
    _prefs!.setStringList(key, value);
  }

  Future<List<String>?> getStringListValue(String key) async {
    return _prefs!.getStringList(key);
  }

  removeValue(String key) async {
    return _prefs!.remove(key);
  }

  String get category {
    return _prefs!.getString('category') ?? '';
  }

  set category(String value) {
    _prefs!.setString('category', value);
  }

  remove(String value) {
    _prefs!.remove(value);
  }

  List<Categories> get listCategories {
    return _listCategories;
  }

  void addListCat(Categories categories) {
    _listCategories.add(categories);
  }

  void removeListCat(int index) {
    _listCategories.removeAt(index);
  }

  List<String> get categories {
    return _categories;
  }

  void addCat(String value) {
    _categories.add(value);
  }

  void removeCat(int index) {
    _categories.removeAt(index);
  }
}
