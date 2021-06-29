import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/models/sign_up_model.dart';
import 'package:digitalkeyholder/scr/screens/authenticate/Sign_Up_Page.dart';
import 'package:digitalkeyholder/scr/screens/home/footer_login.dart';
import 'package:digitalkeyholder/scr/screens/home/reset_password_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/Mainview_Page.dart';
import 'package:digitalkeyholder/scr/screens/Progress.dart';
import 'package:digitalkeyholder/scr/screens/widgets/PasswordField.dart';
import 'package:digitalkeyholder/scr/services/push_notification_service.dart';
import 'package:digitalkeyholder/scr/services/ThemeNotifier.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:digitalkeyholder/testing/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  CustomColors _colors = new CustomColors();
  String? logo = "assets/logo.png";
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LoginRequestModel? loginRequestModel;
  bool isApiCallProcess = false;
  String? _password;
  LangWords? langWords;

  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel(
        email: '', password: '', token: PushNotificationService.token);
    print(PushNotificationService.token);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressIndication(
      child: Uibuild(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget Uibuild(BuildContext context) {
    var theme = Provider.of<ThemeNotifier>(context);
    langWords = LangWords();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.92,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    theme.toggleTheme();
                  },
                  child: Container(
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
                ),
                buildInputLogin(),
                buildInput(),
                widgetFooter(_colors.textColor(context))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildLoginWith() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Text("Iniciar sesión",
          style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
    );
  }

  SizedBox buildInputLogin() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Column(
            children: [
              FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
                          name: "email",
                          onSaved: (input) => loginRequestModel!.email = input,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: "Correo electrónico"),
                          validator: FormBuilderValidators.compose([
                            //FormBuilderValidators.match(context, r"^(?:\d{10}|\w+@\w+\.\w{2,3})$", errorText: "Introduzca una dirección de correo electrónico válida o celular"),
                            FormBuilderValidators.required(context,
                                errorText:
                                    "Se requiere una dirección de correo electrónico válida"),
                            FormBuilderValidators.email(context,
                                errorText:
                                    "Introduzca una dirección de correo electrónico válida"),
                          ]),
                        ),
                        PasswordField(
                          onSaved: (input) =>
                              loginRequestModel!.password = input!,
                          fieldKey: _passwordFieldKey,
                          controller: _passController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: "Por favor ingrese una contraseña"),
                          ]),
                          labelText: 'Contraseña',
                          onFieldChange: (value) {
                            _password = value;
                          },
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: NeumorphicText(
                                    langWords!.recoverPassword! + "\n",
                                    style: NeumorphicStyle(
                                        color: _colors.textColor(context),
                                        depth: 2,
                                        intensity: 0.7,
                                        shadowLightColor:
                                            _colors.shadowColor(context)),
                                    textStyle: NeumorphicTextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ResetPasswordPage()));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ))
        ],
      ),
    );
  }

  Container buildInput() {
    return Container(
      height: 200,
      width: 300,
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                NeumorphicButton(
                    onPressed: () async {
                      APIService apiService = new APIService();
                      final prefs = new UserPreferences();
                      if (_formKey.currentState!.saveAndValidate()) {
                        print(loginRequestModel!.toJson());
                        EasyLoading.show(
                            status: 'Iniciando sesión...',
                            maskType: EasyLoadingMaskType.black);

                        apiService.login(loginRequestModel!).then((value) {
                          setState(() {
                            print(value.message);
                            EasyLoading.dismiss();
                          });
                          if (value.message == 'Sesión iniciada') {
                            prefs.userId = value.user!.id.toString();
                            prefs.userName = value.user!.name!;
                            prefs.lastName = value.user!.lastname!;
                            prefs.email = value.user!.email!;
                            prefs.phone = value.user!.cellphone.toString();
                            //prefs.alias = value.user!.usuAlias!;

                            final snackBar =
                                SnackBar(content: Text(value.message!));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MainView(),
                              ),
                            );
                          } else {
                            final snackBar =
                                SnackBar(content: Text(value.message!));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      }
                    },
                    tooltip: langWords!.login,
                    style: NeumorphicStyle(
                        color: _colors.contextColor(context),
                        shape: NeumorphicShape.flat,
                        //boxShape: NeumorphicBoxShape.circle(),
                        shadowLightColor: _colors.shadowColor(context),
                        depth: 2,
                        intensity: 1),
                    //padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.login,
                      color: _colors.textColor(context),
                      size: 30,
                    )),
              ],
            ),
          ),
          /*
          GestureDetector(
            child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicText(
                      langWords!.notAccount! + ' ',
                      style: NeumorphicStyle(
                          color: Color(0xFFA35FFF),
                          depth: 2,
                          intensity: 0.7,
                          shadowLightColor: Colors.deepPurple),
                    ),
                    NeumorphicText(
                      langWords!.signUp!,
                      style: NeumorphicStyle(
                        color: _colors.textColor(context),
                        depth: 2,
                        intensity: 0.7,
                        shadowLightColor: _colors.shadowColor(context),
                      ),
                      textStyle: NeumorphicTextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_buildContext) => SignUpPage(
                        isFooter: true,
                        logo: logo,
                        funSignUp: (BuildContext _context, Function isRequest,
                            SignUpModel signUpModel) {
                          isRequest(true);

                          print(signUpModel.email);
                          print(signUpModel.password);
                          print(signUpModel.repeatPassword);
                          print(signUpModel.lastname);
                          print(signUpModel.name);

                          isRequest(false);
                        },
                      )));
            },
          ),
           */
        ],
      ),
    );
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
