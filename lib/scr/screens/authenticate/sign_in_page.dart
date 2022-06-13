import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/screens/home/footer.dart';
import 'package:digitalkeyholder/scr/screens/home/reset_password_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/main_view_page.dart';
import 'package:digitalkeyholder/scr/screens/progress.dart';
import 'package:digitalkeyholder/scr/screens/widgets/password_field.dart';
import 'package:digitalkeyholder/scr/services/push_notification_service.dart';
import 'package:digitalkeyholder/scr/services/theme_notifier.dart';
import 'package:digitalkeyholder/scr/services/api_service.dart';
import 'package:digitalkeyholder/scr/models/Login_Model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

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
  String? _emailPhone;
  String? _errorText;
  LangWords? langWords;

  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel(
        email: '', password: '', token: PushNotificationService.token);
  }

  bool? _validateId(String value) {
    if (value.isEmpty) return false;
    final RegExp idExp = RegExp(r"^[0-9]+$");
    if (idExp.hasMatch(value)) return true;
    return null;
  }

  bool? _validateEmail(String value) {
    if (value.isEmpty) return false;
    final RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (emailExp.hasMatch(value)) return true;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressIndication(
      child: uiBuild(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget uiBuild(BuildContext context) {
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

  Container buildInputLogin() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      width: MediaQuery.of(context).size.width * 0.95,
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
                          name: "emailphone",
                          onSaved: (input) => loginRequestModel!.email = input,
                          decoration: InputDecoration(
                              errorText: _errorText,
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: "Cédula o correo electrónico"),
                          validator: (value) {
                            if (_validateEmail(value!) == false &&
                                _validateId(value) == false) {
                              return 'Ingrese una cédula o número de teléfono válido.';
                            }
                            return null;
                          },
                        ),
                        PasswordField(
                          onSaved: (input) =>
                              loginRequestModel!.password = input!,
                          fieldKey: _passwordFieldKey,
                          controller: _passController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Por favor ingrese una contraseña"),
                          ]),
                          labelText: 'Contraseña',
                          onFieldChange: (value) {
                            _password = value;
                          },
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
      //color: Colors.deepPurpleAccent,
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          NeumorphicButton(
            onPressed: () {
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
                    prefs.password = loginRequestModel!.password!;
                    //prefs.alias = value.user!.usuAlias!;

                    final snackBar = SnackBar(content: Text(value.message!, style: TextStyle(color: _colors.textColor(context)),),backgroundColor: Colors.black38,);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MainView(),
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(content: Text(value.message!));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              }
            },
            tooltip: 'Iniciar sesión',
            style: NeumorphicStyle(
                color: _colors.iconsColor(context),
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.rect(),
                shadowLightColor: _colors.iconsColor(context),
                depth: 1,
                intensity: 1),
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicIcon(
                  Icons.login,
                  size: 18,
                  style: NeumorphicStyle(
                      color: _colors.textButtonColor(context),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 0.9),
                ),
                NeumorphicText(
                  'Iniciar sesión ',
                  style: NeumorphicStyle(
                    color: _colors.textButtonColor(context),
                    intensity: 0.7,
                    depth: 1,
                    shadowLightColor: _colors.shadowTextColor(context),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 14,
                  ),
                ),
                NeumorphicIcon(
                  Icons.login,
                  size: 18,
                  style: NeumorphicStyle(
                      color: _colors.textButtonColor(context),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 0.9),
                ),
              ],
            ),
          ),
          Container(
            color: _colors.iconsColor(context),
            height: 5,
            width: MediaQuery.of(context).size.width,
          ),
          NeumorphicButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()));
            },
            tooltip: 'Recuperar contraseña',
            style: NeumorphicStyle(
                color: _colors.iconsColor(context),
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.rect(),
                shadowLightColor: _colors.iconsColor(context),
                depth: 1,
                intensity: 1),
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicIcon(
                  Icons.password,
                  size: 18,
                  style: NeumorphicStyle(
                      color: _colors.textButtonColor(context),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 0.9),
                ),
                NeumorphicText(
                  'Recuperar contraseña ',
                  style: NeumorphicStyle(
                    color: _colors.textButtonColor(context),
                    intensity: 0.7,
                    depth: 1,
                    shadowLightColor: _colors.shadowTextColor(context),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 14,
                  ),
                ),
                NeumorphicIcon(
                  Icons.password,
                  size: 18,
                  style: NeumorphicStyle(
                      color: _colors.textButtonColor(context),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 0.9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget widgetFooter(Color texColor) {
  return Footer(
    logo: 'assets/logo_footer.png',
    text: 'Powered by',
    textColor: texColor,
    funFooterLogin: () {
      // develop what they want the footer to do when the user clicks
    },
  );
}
