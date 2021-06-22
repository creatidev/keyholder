// ignore: import_of_legacy_library_into_null_safe
import 'package:badges/badges.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/icon/quantic_logo_icons.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/screens/authenticate/Sign_In_Page.dart';
import 'package:digitalkeyholder/scr/screens/home/footer_login.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/AddEditCategory_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/Options_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/RegisteredKeycodes_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/RegisteredCategoryAddOption.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/dataviews/UserRequest_Page.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/MainNotifier.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import 'AddEditKeycode_Page.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  CustomColors _colors = new CustomColors();
  var _textController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);
  var _title = 'Requerimientos';
  var _footerHeight = 50.0;
  var currentIndex = 0;
  var disEditMode = false;
  var isCreateMode = false;
  var isSaveLabel = false;
  var _showBadge = true;
  DBService? dbService;
  Categories? model;
  var visibleText = true;
  Icon _icon = Icon(Icons.refresh);
  var langWords;
  List<Categories>? requestedCategories = [];
  int? requirementStatus;
  String badgeText = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    langWords = LangWords();
    dbService = new DBService();
    model = new Categories();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason:
          'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
      switch (currentIndex) {
        case 0:
          {
            _icon = Icon(Icons.refresh);
            _title = 'Requerimientos';
            _showBadge = true;
          }
          break;
        case 1:
          {
            _icon = Icon(Icons.add);
            _title = 'Llaves';
            _showBadge = false;
          }
          break;
        case 2:
          {
            _icon = Icon(Icons.add);
            _title = 'Categorias';
            _showBadge = false;
          }
          break;
        case 3:
          {
            _icon = Icon(Icons.save);
            _title = 'Configuración';
            _showBadge = false;
          }
          break;
      }
    });
    print(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> messengerKey =
        new GlobalKey<ScaffoldMessengerState>();
    var theme = Provider.of<ThemeBloc>(context);
    final request = Provider.of<APIService>(context);
    final _kTabPages = <Widget>[
      UserRequestList(
        iconColor: _colors.iconsColor(context),
        shadowColor: _colors.shadowColor(context),
        textColor: _colors.textColor(context),
        requirementStatus: requirementStatus,
      ),
      RegisteredKeycodesPage(
        iconColor: _colors.iconsColor(context),
        shadowColor: _colors.shadowColor(context),
        textColor: _colors.textColor(context),
      ),
      RegisteredCategoriesPage(
        iconColor: _colors.iconsColor(context),
        shadowColor: _colors.shadowColor(context),
        textColor: _colors.textColor(context),
      ),
      OptionsPage()
    ];

    return NeumorphicTheme(
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        lightSource: LightSource.topLeft,
        accentColor: NeumorphicColors.accent,
        appBarTheme: NeumorphicAppBarThemeData(
            buttonStyle: NeumorphicStyle(
              color: _colors.textColor(context),
              shadowLightColor: _colors.textColor(context),
              boxShape: NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.flat,
              depth: 2,
              intensity: 0.9,
            ),
            textStyle:
                TextStyle(color: _colors.textColor(context), fontSize: 12),
            iconTheme:
                IconThemeData(color: _colors.textColor(context), size: 25)),
        depth: 2,
        intensity: 0.5,
      ),
      child: Scaffold(
        appBar: NeumorphicAppBar(
          leading: GestureDetector(
            onTap: () {
              Theme.of(context).brightness.toString().toLowerCase() ==
                      'brightness.light'
                  ? theme.setThemeData(CustomTheme().darkTheme())
                  : theme.setThemeData(CustomTheme().lightTheme());
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: NeumorphicIcon(
                QuanticLogo.logon,
                size: 50,
                style: NeumorphicStyle(
                    color: _colors.textColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 3,
                    intensity: 3),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicText(
                langWords!.mainName!,
                style: NeumorphicStyle(
                  color: _colors.textColor(context),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                FormHelper.showMessage(
                  context,
                  "QBayes Step Up!",
                  "¿Cerrar sesión?",
                  "Si",
                  () {
                    final prefs = new UserPreferences();
                    prefs.userId = 'none';
                        APIService apiService = new APIService();
                    apiService.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignInPage(),
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
              child: Container(
                padding: EdgeInsets.all(8),
                child: NeumorphicIcon(
                  Icons.logout,
                  size: 40,
                  style: NeumorphicStyle(
                      color: _colors.textColor(context),
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 3,
                      intensity: 3),
                ),
              ),
            ),
          ],
        ),
        //endDrawer: _MyDrawer(isLead: false),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 30,
                  padding: EdgeInsets.only(right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        //color: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _title,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: _colors.textColor(context)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.685,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.685,
                              child: _kTabPages[currentIndex],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: _footerHeight,
                      //color: _colors.textColor(context),
                      child: widgetFooter(_colors.textColor(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Badge(
          showBadge: _showBadge ? true : false,
          badgeContent: (request != null)
              ? Text('${request.count}', style: TextStyle(color: Colors.white))
              : Text('0'),
          badgeColor: Colors.deepPurple,
          //position: BadgePosition.topEnd(),
          child: FloatingActionButton(
            onPressed: () {
              switch (currentIndex) {
                case 0:
                  {
                    EasyLoading.show(
                        status: 'Actualizando requerimientos...',
                        maskType: EasyLoadingMaskType.custom);
                    Future.delayed(Duration(milliseconds: 3000)).then((value) =>
                        {
                          setState(() => request.selectedStatus = "2"),
                          EasyLoading.dismiss()
                        });

                    final snackBar = SnackBar(
                      content: Text('Requerimientos actualizados.'),
                    );
                    messengerKey.currentState?.showSnackBar(snackBar);
                  }
                  break;
                case 1:
                  {
                    Navigator.push(context, MaterialPageRoute<String>(
                      builder: (BuildContext context) {
                        return AddEditKeycodePage(
                          textColor: _colors.textColor(context),
                          iconColor: _colors.iconsColor(context),
                          shadowColor: _colors.shadowColor(context),
                          isCreateMode: true,
                          isEditMode: false,
                          isAutoMode: false,
                        );
                      },
                    )).then((result) {
                      if (result != null) {
                        if (result != '') {
                          setState(() {
                            super.widget;
                          });
                        }
                        print('Devuelve');
                      }
                    });
                  }
                  break;
                case 2:
                  {
                    Navigator.push(context, MaterialPageRoute<bool>(
                      builder: (BuildContext context) {
                        return AddEditCategoryPage(
                          textColor: _colors.textColor(context),
                          iconColor: _colors.iconsColor(context),
                          shadowColor: _colors.shadowColor(context),
                        );
                      },
                    ));
                  }
                  break;
                case 3:
                  {}
                  break;
              }
            },
            child: _icon,
            backgroundColor: _colors.textColor(context),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          backgroundColor: _colors.iconsColor(context),
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          opacity: .2,
          currentIndex: currentIndex,
          onTap: changePage,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ), //border radius doesn't work when the notch is enabled.
          elevation: 8,
          hasInk: true,
          inkColor: Colors.black12,
          //tilesPadding: EdgeInsets.symmetric(vertical: 8.0,),
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.home,
                color: _colors.textColor(context),
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("Inicio"),
            ),
            BubbleBottomBarItem(
                backgroundColor: Colors.deepPurpleAccent,
                icon: Icon(
                  Icons.vpn_key,
                  color: _colors.textColor(context),
                ),
                activeIcon: Icon(
                  Icons.vpn_key,
                  color: Colors.deepPurpleAccent,
                ),
                title: Text("Llaves")),
            BubbleBottomBarItem(
                backgroundColor: Colors.lightBlue,
                icon: Icon(
                  Icons.label,
                  color: _colors.textColor(context),
                ),
                activeIcon: Icon(
                  Icons.label,
                  color: Colors.lightBlue,
                ),
                title: Text("Categorías")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  Icons.menu,
                  color: Colors.deepPurpleAccent,
                ),
                activeIcon: Icon(
                  Icons.menu,
                  color: Colors.green,
                ),
                title: Text("Menú"))
          ],
        ),
      ),
    );
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
enum _SupportState {
  unknown,
  supported,
  unsupported,
}