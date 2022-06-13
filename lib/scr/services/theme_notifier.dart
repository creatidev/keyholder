import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    accentColor: Colors.redAccent,

    scaffoldBackgroundColor: Color(0xfff1f1f1)
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.cyan,
  accentColor: Colors.deepPurpleAccent,
);

class ThemeNotifier with ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _pref;
  bool? _darkTheme;

  bool get darkTheme => _darkTheme!;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme(){
    _darkTheme = !_darkTheme!;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_pref == null)
      _pref  = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref!.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref!.setBool(key, _darkTheme!);
  }
}

class CounterProvider with ChangeNotifier {
  int _counter = 0;
  int _countCats = 0;
  int get counter => _counter;
  int get countCats => _countCats;

  void onChange(value) {
    _counter = value;
    notifyListeners();
  }
  void onChangeCats(value) {
    _countCats = value;
    notifyListeners();
  }

}
