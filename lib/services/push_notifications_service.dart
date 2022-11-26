// SHA1 CD:40:70:D7:B1:14:E7:B7:34:4F:F5:D8:B3:17:DE:BF:22:0B:CF:9D
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PushNotificationService {

  final baseURL =  'http://192.168.56.1:3001';

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  final storage = const FlutterSecureStorage();

  static StreamController<String> _messageStream = StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler ( RemoteMessage message) async {
    print('On Background Handler ${ message.messageId}');
    _messageStream.add(message.notification?.body ?? 'No title');
  
  }

  static Future _onMessageHandler ( RemoteMessage message) async {    
    print('On Message Handler ${ message.messageId}');
    _messageStream.add(message.data['id_categoria'] ?? 'no data');
  }

  static Future _onOpenMessageOpenApp ( RemoteMessage message) async {
    print('On OpenMessageOpenApp Handler ${ message.messageId}');
    _messageStream.add(message.notification?.body ?? 'No title'); 
    print(message.data);
    _messageStream.add(message.data['id_categoria'] ?? 'no data');
  }

  static Future initializeApp() async {

    // Push notificatons
    await Firebase.initializeApp();
    await messaging.getInitialMessage();
    await requestPermission();
    final storage = const FlutterSecureStorage();
    token = await FirebaseMessaging.instance.getToken();
    // TODO: Guardar el token del usuario
    await storage.write(key: 'token_device', value: token);
    print('Token: $token');


    // Handlers

    FirebaseMessaging.onBackgroundMessage( _backgroundHandler);
    FirebaseMessaging.onMessage.listen( _onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen( _onOpenMessageOpenApp);


    // Local notifications

  }

  // Future saveTokenUserDevice() async { 
  //   final url = Uri.parse('http://192.168.56.1:3001/api/subcategoria');
  //   await storage.read(key: 'token');
  // }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true 
    );

    print('User push notification status ${ settings.authorizationStatus}');
  }
  static closeStreams() {
    _messageStream.close();
  }

}