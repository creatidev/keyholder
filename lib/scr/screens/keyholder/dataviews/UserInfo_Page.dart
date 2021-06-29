import 'package:digitalkeyholder/main.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/screens/home/footer_login.dart';
import 'package:digitalkeyholder/scr/screens/widgets/PasswordField.dart';
import 'package:digitalkeyholder/scr/services/ThemeNotifier.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  String? _password;
  bool isChecked = false;
  bool isEnabled = true;
  CustomColors _colors = new CustomColors();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final prefs = new UserPreferences();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widgetFooter(_colors.shadowColor(context)),
              Container(
                //color: Colors.deepPurple,
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            NeumorphicIcon(
                              Icons.dark_mode_outlined,
                              size: 30,
                              style: NeumorphicStyle(
                                  color: _colors.iconsColor(context),
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  shadowLightColor:
                                      _colors.shadowColor(context),
                                  depth: 1.5,
                                  intensity: 0.7),
                            ),
                            NeumorphicText(
                              ' Tema oscuro',
                              style: NeumorphicStyle(
                                color: _colors.textColor(context),
                                intensity: 0.7,
                                depth: 1.5,
                                shadowLightColor:
                                    _colors.shadowTextColor(context),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                            activeColor: _colors.iconsColor(context),
                            value: theme.darkTheme,
                            onChanged: (value) {
                              theme.toggleTheme();
                            }),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            NeumorphicIcon(
                              Icons.touch_app,
                              size: 30,
                              style: NeumorphicStyle(
                                  color: _colors.iconsColor(context),
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  shadowLightColor:
                                      _colors.shadowColor(context),
                                  depth: 1.5,
                                  intensity: 0.7),
                            ),
                            NeumorphicText(
                              ' Reiniciar tuturiales',
                              style: NeumorphicStyle(
                                color: _colors.textColor(context),
                                intensity: 0.7,
                                depth: 1.5,
                                shadowLightColor:
                                    _colors.shadowTextColor(context),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        NeumorphicButton(
                          onPressed: () {
                            FormHelper.showMessage(
                              context,
                              "QBayes Step Up!",
                              "¿Reiniciar tutoriales?",
                              "Si",
                              () {
                                prefs.firstRun = true;
                                prefs.firstKeyring = true;
                                prefs.firstKey = true;
                                prefs.firstSend = true;
                                prefs.firstCategory = true;
                                prefs.firstViewKey = true;
                                prefs.firstViewCategory = true;
                                EasyLoading.showInfo('Tutoriales reiniciados',
                                    maskType: EasyLoadingMaskType.custom,
                                    dismissOnTap: true);
                                Navigator.of(context).pop();
                              },
                              buttonText2: "No",
                              isConfirmationDialog: true,
                              onPressed2: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          tooltip: 'Reiniciar tutoriales',
                          style: NeumorphicStyle(
                              color: _colors.contextColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.circle(),
                              shadowLightColor: _colors.iconsColor(context),
                              depth: 2,
                              intensity: 1),
                          padding: const EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.refresh,
                            color: _colors.textColor(context),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicIcon(
                          Icons.person_pin_outlined,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.textColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor:
                                  _colors.shadowTextColor(context),
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                        NeumorphicText(
                          ' Mis datos',
                          style: NeumorphicStyle(
                            color: _colors.textColor(context),
                            intensity: 0.7,
                            depth: 1.5,
                            shadowLightColor: _colors.shadowTextColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        NeumorphicIcon(
                          Icons.person_outline,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.iconsColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: _colors.shadowColor(context),
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                        NeumorphicText(
                          ' ${prefs.userName} ${prefs.lastName}',
                          style: NeumorphicStyle(
                            color: _colors.textColor(context),
                            intensity: 0.7,
                            depth: 1.5,
                            shadowLightColor: _colors.shadowTextColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        NeumorphicIcon(
                          Icons.alternate_email,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.iconsColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: _colors.shadowColor(context),
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                        NeumorphicText(
                          ' ${prefs.email}',
                          style: NeumorphicStyle(
                            color: _colors.textColor(context),
                            intensity: 0.7,
                            depth: 1.5,
                            shadowLightColor: _colors.shadowTextColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        NeumorphicIcon(
                          Icons.phone_android,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.iconsColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: _colors.shadowColor(context),
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                        NeumorphicText(
                          ' ${prefs.phone}',
                          style: NeumorphicStyle(
                            color: _colors.textColor(context),
                            intensity: 0.7,
                            depth: 1.5,
                            shadowLightColor: _colors.shadowTextColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicIcon(
                          Icons.account_box_outlined,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.textColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor:
                                  _colors.shadowTextColor(context),
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                        NeumorphicText(
                          ' Mi cuenta',
                          style: NeumorphicStyle(
                            color: _colors.textColor(context),
                            intensity: 0.7,
                            depth: 1.5,
                            shadowLightColor: _colors.shadowTextColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    ListTile(
                      leading: NeumorphicIcon(
                        Icons.lock_outline,
                        size: 30,
                        style: NeumorphicStyle(
                            color: _colors.iconsColor(context),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            shadowLightColor: _colors.shadowColor(context),
                            depth: 1.5,
                            intensity: 0.7),
                      ),
                      title: NeumorphicText(
                        ' Cambiar contraseña',
                        style: NeumorphicStyle(
                          color: _colors.textColor(context),
                          intensity: 0.7,
                          depth: 1.5,
                          shadowLightColor: _colors.shadowTextColor(context),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: NeumorphicIcon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                        style: NeumorphicStyle(
                            color: _colors.iconsColor(context),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            shadowLightColor: _colors.shadowColor(context),
                            depth: 1.5,
                            intensity: 0.7),
                      ),
                      onTap: () {
                        _changePasswordInputDialog(context);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: NeumorphicIcon(
                        Icons.logout,
                        size: 30,
                        style: NeumorphicStyle(
                            color: _colors.iconsColor(context),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            shadowLightColor: _colors.shadowColor(context),
                            depth: 1.5,
                            intensity: 0.7),
                      ),
                      title: NeumorphicText(
                        ' Cerrar sesión',
                        style: NeumorphicStyle(
                          color: _colors.textColor(context),
                          intensity: 0.7,
                          depth: 1.5,
                          shadowLightColor: _colors.shadowTextColor(context),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: NeumorphicIcon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                        style: NeumorphicStyle(
                            color: _colors.iconsColor(context),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            shadowLightColor: _colors.shadowColor(context),
                            depth: 1.5,
                            intensity: 0.7),
                      ),
                      onTap: () {
                        FormHelper.showMessage(
                          context,
                          "QBayes Step Up!",
                          "¿Cerrar sesión?",
                          "Si",
                          () {
                            APIService apiService = new APIService();
                            apiService.logout();
                            final prefs = new UserPreferences();
                            prefs.userId = '0';
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Wrapper(),
                              ),
                            );
                          },
                          buttonText2: "No",
                          isConfirmationDialog: true,
                          onPressed2: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePasswordInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cambiar contraseña'),
            content: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Container(
                height: 90,
                //color: Colors.deepPurpleAccent,
                child: Column(
                  children: [
                    PasswordField(
                      onSaved: (input) {},
                      controller: _newPasswordController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "Por favor ingrese una contraseña"),
                        FormBuilderValidators.minLength(context, 8,
                            errorText: 'Debe contener al menos 8 caracteres'),
                        //FormBuilderValidators.match(context, r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$', errorText: 'La contraseña debe contener al menos una mayúscula, un número y un carácter especial'),
                        FormBuilderValidators.match(context, r'^(?=.*?[A-Z])',
                            errorText: 'Debe contener al menos una mayúscula.'),
                        FormBuilderValidators.match(context, r'^(?=.*?[0-9])',
                            errorText: 'Debe contener al menos un digito.'),
                        FormBuilderValidators.match(
                            context, r'^(?=.*?[#?!@$%^&*-])',
                            errorText: '..al menos un caracter especial.')
                      ]),
                      labelText: 'Contraseña',
                      onFieldChange: (value) {
                        _password = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('Enviar'),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState!.saveAndValidate()) {
                      print(_password);
                      APIService apiService = new APIService();
                      EasyLoading.show(
                          status:
                              'Enviando solicitud de cambio de contraseña...',
                          maskType: EasyLoadingMaskType.black);
                      apiService.changePassword(_password!).then((value) {
                        print(value.message);
                        final snackBar =
                            SnackBar(content: Text(value.message!));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        EasyLoading.dismiss();
                        Navigator.pop(context);
                      });
                    }
                    //codeDialog = valueText;
                  });
                },
              ),
            ],
          );
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
