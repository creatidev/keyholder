import 'dart:io';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormHelper {
  static Widget textInput(
    BuildContext context,
    String initialValue,
    String name,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    Function? onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return FormBuilderTextField(
      initialValue: initialValue != null ? initialValue.toString() : "",
      decoration: fieldDecoration(context, "", ""),
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      onChanged: (value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate!(value);
      },
      name: name,
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }

  static Widget selectDropdown(
    BuildContext context,
    Object initialValue,
    String name,
    dynamic data,
    Function onChanged, {
    Function? onValidate,
  }) {
    return Container(
      height: 75,
      padding: EdgeInsets.only(top: 5),
      child: new FormBuilderDropdown<String>(
        name: name,
        hint: new Text("Select"),
        initialValue: initialValue != null ? initialValue.toString() : null,
        isDense: true,
        onChanged: (value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          onChanged(value);
        },
        validator: (value) {
          return onValidate!(value);
        },
        decoration: fieldDecoration(context, "", ""),
        items: data.map<DropdownMenuItem<String>>(
          (Categories data) {
            return DropdownMenuItem<String>(
              value: data.id.toString(),
              child: new Text(
                data.category!,
                style: new TextStyle(color: Colors.black),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        labelName,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static void showMessage(BuildContext context, String title, String message,
      String buttonText, Function onPressed,
      {bool isConfirmationDialog = false,
      String buttonText2 = "",
      Function? onPressed2}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: [
            new TextButton(
              onPressed: () {
                return onPressed();
              },
              child: new Text(buttonText),
            ),
            Visibility(
              visible: isConfirmationDialog,
              child: new TextButton(
                onPressed: () {
                  return onPressed2!();
                },
                child: new Text(buttonText2),
              ),
            ),
          ],
        );
      },
    );
  }
}
