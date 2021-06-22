import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:flutter/material.dart';

final prefs = new UserPreferences();

class ThemeBloc with ChangeNotifier {
  ThemeData _themeData;

  ThemeBloc(this._themeData);

  getThemeData() => _themeData;

  setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}

class CounterProvider with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void onChange(value) {
    _counter = value;
    notifyListeners();
  }
}

