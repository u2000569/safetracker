import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safetracker/utils/logging/logger.dart';

class PushNotifications {
  
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request permission to receive notifications
  static Future init() async{
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      carPlay: false,
      criticalAlert: true,
      badge: true,
      provisional: false,
      sound: true
    );

    // get the FCM token for this device
    final token = await _firebaseMessaging.getToken();
    SLoggerHelper.info('Device Token : $token');
  }

  // initialize local notifications
  static Future localNotiInt() async{
    // initialize the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid = 
      AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsDarwin = 
      DarwinInitializationSettings(
        // onDidReceiveLocalNotification: (id, title, body, payload) => null
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
      );

    final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open Notification');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux
    );

    // request permission to display notifications for android 13
    _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation
        <AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap
    );

  }

    // on tap local notification in foreground
    static void onNotificationTap(NotificationResponse notificationResponse){
      // Handle notification tap
      SLoggerHelper.info('Notification tapped: ${notificationResponse.payload}');
    }

    // on receive local notification in foreground (iOS)
  static Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // Handle the notification here
    print('Notification Received: id=$id, title=$title, body=$body, payload=$payload');
    // You can show a dialog or navigate to a specific screen
  }
}