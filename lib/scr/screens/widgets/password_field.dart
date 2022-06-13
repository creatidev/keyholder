import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {this.fieldKey,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldChange,
      this.controller});

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged? onFieldChange;
  final TextEditingController? controller;
  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  Icon _icon = Icon(
    Icons.visibility,
    color: Colors.deepPurpleAccent,
    size: 20,
  );
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'passwordField',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      key: widget.fieldKey,
      obscureText: _obscureText,
      onSaved: widget.onSaved,
      onChanged: widget.onFieldChange,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.deepPurpleAccent, size: 18),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
                _icon = ((_obscureText)
                    ? Icon(
                        Icons.visibility,
                        color: Colors.deepPurpleAccent,
                        size: 18,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: Colors.deepPurpleAccent,
                        size: 18,
                      ));
              });
            },
            child: _icon),
      ),
    );
  }
}
