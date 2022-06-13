import 'package:flutter/material.dart';

Widget CustomFloationButton(
    String heroTag, String labelText, Function onPressed, Color buttonColor) {
  return FloatingActionButton.extended(
    heroTag: heroTag,
    onPressed: onPressed(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
    ),
    label: Text(labelText),
    backgroundColor: buttonColor,
  );
}
