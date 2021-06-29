import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/models/sign_up_model.dart';
import 'package:digitalkeyholder/scr/screens/home/footer_login.dart';
import 'package:digitalkeyholder/scr/screens/widgets/CustomFloatingActionButton.dart';
import 'package:digitalkeyholder/scr/screens/widgets/PasswordField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

import '../home/loading_login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, this.funSignUp, this.isFooter, this.logo})
      : super(key: key);
  final Function? funSignUp;
  final bool? isFooter;
  final String? logo;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CustomColors _colors = new CustomColors();
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passController = TextEditingController();
  final _repeatPassController = TextEditingController();

  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  SignUpModel signUpModel = SignUpModel();
  bool isRequest = false;
  bool isNoVisiblePassword = true;
  bool _isObscure = true;
  String? _password;
  String? _helperText;
  Icon _icon = Icon(Icons.check, color: Colors.deepPurpleAccent, size: 18);

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) return 'Número de celular es requerido.';
    final RegExp nameExp =
        new RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
    if (!nameExp.hasMatch(value)) return 'Ingrese un número de celular válido';
    return null;
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FormBuilderTextField(
                            controller: _emailController,
                            name: "email",
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email,
                                    color: Colors.deepPurpleAccent, size: 18),
                                labelText: "Correo electrónico"),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: "Este campo no puede estar vacío"),
                              FormBuilderValidators.email(context,
                                  errorText:
                                      "Introduzca una dirección de correo electrónico válida"),
                            ]),
                          ),
                          FormBuilderTextField(
                            controller: _nameController,
                            name: "name",
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_rounded,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: "Nombre",
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.match(
                                  context, r'^[A-Za-z ]+$',
                                  errorText:
                                      'Ingrese solo caracteres alfabéticos.')
                            ]),
                          ),
                          FormBuilderTextField(
                            controller: _idController,
                            name: "id",
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.credit_card,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: "Cédula",
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText:
                                      "Se requiere un número de cédula válido")
                            ]),
                            maxLength: 10,
                          ),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.disabled,
                            controller: _phoneNumberController,
                            name: "phonenumbre",
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone_android,
                                    color: Colors.deepPurpleAccent, size: 18),
                                labelText: "Celular",
                                prefixText: "+57"),
                            maxLength: 10,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: "Este campo es requerido"),
                              FormBuilderValidators.numeric(context,
                                  errorText:
                                      "Este campo solo admite caracteres numericos."),
                              FormBuilderValidators.maxLength(context, 10),
                              FormBuilderValidators.minLength(context, 10,
                                  errorText:
                                      "Ingrese un número de celular válido.")
                            ]),
                            keyboardType: TextInputType.number,
                          ),
                          PasswordField(
                            fieldKey: _passwordFieldKey,
                            controller: _passController,
                            //helperText: 'No más de 15 caracteres.',
                            labelText: 'Contraseña',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText:
                                      "Por favor ingrese una contraseña"),
                              FormBuilderValidators.minLength(context, 8,
                                  errorText: "Mínimo 8 caracteres"),
                              FormBuilderValidators.match(
                                  context, r'^(?=.*[A-Z]).{8,}$',
                                  errorText:
                                      r'Se requiere al menos una letra mayúscula'),
                              FormBuilderValidators.match(
                                  context, r'^(?=.*?[0-9]).{8,}$',
                                  errorText: r'Se requiere al menos un digito'),
                              FormBuilderValidators.match(
                                  context, r'^(?=.*?[#?!@$%^&*-]).{8,}$',
                                  errorText:
                                      r'Se requiere al menos un caracter especial (-!#$%&?*)')
                            ]),
                            onSaved: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                          FormBuilderTextField(
                              enabled: _password != null &&
                                  _password!.isNotEmpty &&
                                  _password!.length >= 8,
                              controller: _repeatPassController,
                              name: "re-password",
                              decoration: InputDecoration(
                                prefixIcon: _icon,
                                labelText: langWords!.messageRepeatPassword,
                                helperText: _helperText,
                              ),
                              maxLength: 15,
                              obscureText: true,
                              onChanged: (value) {
                                setState(() {
                                  bool _isEqual = (_repeatPassController.text ==
                                      _passController.text);
                                  _helperText = (_isEqual)
                                      ? langWords!.passwordIsEqual
                                      : langWords!.passwordIsNotEqual;
                                  _icon = (_isEqual)
                                      ? Icon(Icons.mood,
                                          color: Colors.green, size: 18)
                                      : Icon(Icons.mood_bad_outlined,
                                          color: Colors.red, size: 18);
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomFloatingActionButton(
                          labelText: langWords!.endRegistration,
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
              widgetFooter(
                _colors.textColor(context),
              ),
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
