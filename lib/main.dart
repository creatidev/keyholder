import 'dart:io';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/screens/authenticate/sign_in_page.dart';
import 'package:digitalkeyholder/scr/screens/keyholder/main_view_page.dart';
import 'package:digitalkeyholder/scr/services/push_notification_service.dart';
import 'package:digitalkeyholder/scr/services/theme_notifier.dart';
import 'package:digitalkeyholder/scr/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

var initialRoute = '/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = new MyHttpOverrides();
  await PushNotificationService.initializeApp();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  configLoading();
  runApp(KeyHolder());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
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
      ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
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

      final snackBar = SnackBar(
        elevation: 10,
        backgroundColor: Colors.black87,
        content: Text('Tiene acciones pendientes', style: TextStyle(color: Colors.deepPurpleAccent),),
        duration: Duration(seconds: 30),
        action: SnackBarAction(
          label: 'Aceptar',
          textColor: Colors.cyan,
          onPressed: () {
            messengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      );
      messengerKey.currentState?.showSnackBar(snackBar);
      //navigatorKey.currentState?.push(MaterialPageRoute(
      // builder: (BuildContext context) => RequestedKeyring(),
      //));
    });
  }

  Future onSelectNotification(String? payload) async {}

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Llavero',
      theme: theme.darkTheme ? dark : light,
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
    if(prefs.checkUserId() == false){
      return SignInPage();
    } else {
      return MainView();
    }
  }
}
