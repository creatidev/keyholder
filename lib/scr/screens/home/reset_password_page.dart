import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/screens/widgets/CustomFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

import 'footer_login.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  CustomColors _colors = new CustomColors();
  final _emailController = TextEditingController();
  bool isRequest = false;
  final focus = FocusNode();
  LangWords? langWords;
  @override
  Widget build(BuildContext context) {
    langWords = LangWords();
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.92,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: NeumorphicIcon(
                  QuanticLogo.logon,
                  size: 150,
                  style: NeumorphicStyle(color: Colors.redAccent),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      langWords!.messageRecoverPassword!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: _colors.shadowColor(context), fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: FormBuilderTextField(
                        controller: _emailController,
                        name: "email",
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email,
                                color: Colors.deepPurpleAccent, size: 15),
                            labelText: langWords!.email),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: "Este campo no puede estar vacío"),
                          FormBuilderValidators.email(context,
                              errorText:
                                  "Introduzca una dirección de correo electrónico válida"),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 260,
                padding: const EdgeInsets.only(top: 90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomFloatingActionButton(
                          labelText: langWords!.requestChangePassword,
                          backgroundColor: _colors.shadowColor(context),
                          heroTag: "Btn1",
                          onPressed: () {},
                        ),
                        SizedBox(height: 10),
                        CustomFloatingActionButton(
                          labelText: "",
                          backgroundColor: _colors.shadowColor(context),
                          heroTag: "Btn2",
                        ),
                        SizedBox(height: 10),
                        CustomFloatingActionButton(
                          labelText: langWords!.cancel,
                          backgroundColor: _colors.shadowColor(context),
                          heroTag: "Btn3",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widgetFooter(_colors.textColor(context))
            ],
          ),
        ),
      ),
    ));
  }

  void setIsRequest(bool isRequest) {
    setState(() {
      this.isRequest = isRequest;
    });
  }
}

Widget widgetFooter(Color texcolor) {
  return FooterLogin(
    logo: 'assets/logo_footer.png',
    text: 'Powered by',
    textColor: texcolor,
    funFooterLogin: () {
      // develop what they want the footer to do when the user clicks
    },
  );
}
