import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class CustomTheme {
  ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xff333333),
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: Colors.white30,
      ),
    );
  }

  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Color(0xfff3efef),
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.cyan),
    );
  }
}

class CustomColors {
  Color iconsColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? Color.fromRGBO(243, 239, 239, 0.9)
        : Color.fromRGBO(55, 55, 55, 0.9);
  }

  Color textColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? Color.fromRGBO(232, 89, 89, 0.9019607843137255)
        : Color.fromRGBO( 69, 173, 231, 0.9019607843137255 );
  }

  Color shadowColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
            "brightness.light"
        ? Color.fromRGBO(232, 89, 89, 0.9019607843137255)
        : Color.fromRGBO( 35, 121, 170, 0.9019607843137255 );
  }

  Color borderColor(BuildContext context) {
    return Theme.of(context).brightness.toString().toLowerCase() ==
        "brightness.light"
        ? Color.fromRGBO( 206, 142, 142, 0.9019607843137255 )
        : Color.fromRGBO( 148, 131, 172, 0.9019607843137255 );
  }
}
