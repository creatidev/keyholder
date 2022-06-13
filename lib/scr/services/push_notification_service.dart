import 'dart:async';
import 'dart:convert';
import 'package:digitalkeyholder/scr/config/user_preferences.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final prefs = new UserPreferences();

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token; //Se cambio a map string dynamic de String
  static StreamController<Map<String, dynamic>> _messageStream =
      new StreamController.broadcast();
  static Stream<Map<String, dynamic>> get messagesStream =>
      _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('onBackground Handler ${message.messageId}');
    String? decodedText =
        utf8.decode(base64.decode(message.data["information"]));

    prefs.listCategories.add(Categories.fromJson(jsonDecode(decodedText)));
    _messageStream.add(message.data);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessage Handler! ${message.messageId}');
    String? decodedText =
        utf8.decode(base64.decode(message.data["information"]));

    prefs.listCategories.add(Categories.fromJson(jsonDecode(decodedText)));
    _messageStream.add(message.data);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('onMessage Open App! ${message.messageId}');
    String? decodedText =
        utf8.decode(base64.decode(message.data["information"]));

    prefs.listCategories.add(Categories.fromJson(jsonDecode(decodedText)));
    _messageStream.add(message.data);
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notifications
  }

  // Apple / Web
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
