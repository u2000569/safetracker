import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safetracker/utils/logging/logger.dart';

class FirebaseApi {
  // create a new instance of FirebaseMessaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize FirebaseMessaging
  Future<void> initNotifications() async{
    // request permission to receive notifications
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the FCM token
    SLoggerHelper.info('Token : $fCMToken');
    print('Token : $fCMToken');

    initPushNotifications();
  }

  // function to handle incoming messages
  void handleMessages(RemoteMessage? message) {
    // listen for incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print the message
      SLoggerHelper.info('Message : $message');
    });
  }

  // function to handle background messages
  Future initPushNotifications() async{
    // handle notification if the app was terminated
    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);

    // atach event listener when notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }
}