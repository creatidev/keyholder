import 'package:digitalkeyholder/main.dart';
import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/screens/widgets/CustomFloatingActionButton.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

import 'footer_login.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  CustomColors _colors = new CustomColors();
  final _emailController = TextEditingController();
  String? _email;
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
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 220,
                height: 220,
                //color: Colors.lightBlue,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    NeumorphicIcon(
                      QuanticLogo.logon,
                      size: 230,
                      style: NeumorphicStyle(
                          color: Colors.redAccent,
                          shadowLightColor: Colors.red,
                          depth: 2,
                          intensity: 0.9),
                    ),
                    NeumorphicIcon(
                      Icons.skip_next,
                      size: 50,
                      style: NeumorphicStyle(
                          color: Colors.lightBlueAccent,
                          shadowLightColor: Colors.lightBlueAccent,
                          depth: 2,
                          intensity: 0.9),
                    ),
                  ],
                ),
              ),
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
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
                          onChanged: (value) {
                            _email = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                //color: Colors.deepPurpleAccent,
                height: 160,
                padding: const EdgeInsets.only(top: 30),
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
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              APIService apiService = new APIService();
                              EasyLoading.show(
                                  status:
                                      'Enviando solicitud de recuperación de contraseña...',
                                  maskType: EasyLoadingMaskType.black);
                              apiService.restorePassword(_email!).then((value) {
                                print(value.message);

                                //prefs.alias = value.user!.usuAlias!;

                                final snackBar =
                                    SnackBar(content: Text(value.message!));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                EasyLoading.dismiss();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Wrapper(),
                                  ),
                                );
                              });
                            }
                          },
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
  return Footer(
    logo: 'assets/logo_footer.png',
    text: 'Powered by',
    textColor: texcolor,
    funFooterLogin: () {
      // develop what they want the footer to do when the user clicks
    },
  );
}
