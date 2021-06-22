import 'dart:io';
import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/screens/authenticate/Sign_In_Page.dart';
import 'package:digitalkeyholder/scr/screens/authenticate/Sign_Up_Page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/Mainview_Page.dart';
import 'package:digitalkeyholder/scr/services/push_notification_service.dart';
import 'package:digitalkeyholder/scr/services/MainNotifier.dart';
import 'package:digitalkeyholder/testing/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

var initialRoute = '/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await PushNotificationService.initializeApp();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
/*  if (prefs.login == 'Iniciada') {
    initialRoute = '/home';
  }*/

  configLoading();
  runApp(KeyHolder());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black38
    ..indicatorColor = Colors.white70
    ..textColor = Colors.lightBlueAccent
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class KeyHolder extends StatefulWidget {
  const KeyHolder({Key? key}) : super(key: key);

  @override
  _KeyHolderState createState() => _KeyHolderState();
}

class _KeyHolderState extends State<KeyHolder> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ThemeBloc>(
          create: (_) => ThemeBloc(CustomTheme().lightTheme())),
      ChangeNotifierProvider(create: (_) => new CounterProvider()),
      ChangeNotifierProvider(create: (_) => new APIService()),
    ], child: MyApp());
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    PushNotificationService.messagesStream.listen((message) {
      final request = Provider.of<APIService>(context, listen: false);
      setState(() => request.selectedStatus = "2");

      final snackBar = SnackBar(content: Text('Requerimientos actualizados'));
      messengerKey.currentState?.showSnackBar(snackBar);
      //navigatorKey.currentState?.push(MaterialPageRoute(
      // builder: (BuildContext context) => RequestedKeyring(),
      //));
    });
  }

  Future onSelectNotification(String? payload) async {}

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeBloc>(context).getThemeData();
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Llavero',
      theme: currentTheme,
      home: Wrapper(),
      //initialRoute: initialRoute,
      navigatorKey: navigatorKey, // Navegar
      scaffoldMessengerKey: messengerKey, // Snacks
/*      routes: {
          '/': (context) => SignInPage(),
          '/home': (context) => MainView(),
        }*/
    );
  }
}

class Wrapper extends StatelessWidget {
  final prefs = new UserPreferences();
  @override
  Widget build(BuildContext context) {
    print(prefs.userId);
    //Devuelve la página inicial o de login
    if (prefs.userId == 'none') {
      return SignInPage();
    } else {
      return MainView();
    }
  }
}
