import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:safetracker/api/firebase_api.dart';
import 'package:safetracker/api/notification_service.dart';
import 'package:safetracker/app.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/data/repositories/user/user_repository.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'firebase_options.dart';

// Future _firebaseBackgroundMessage(RemoteMessage message) async{
//   if (message.notification != null) {
//     SLoggerHelper.info('Notification in background: ${message.notification!.body}');
//   }
// }

Future<void> main() async{
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // GetX local storage
  await GetStorage.init();

  /// Overcome from transparent spaces at the bottom in IOS
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  /// -- Await Splash until other items Load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (FirebaseApp value) =>  Get.put(AuthenticationRepository()),
    );
  // await FirebaseApi().initNotifications();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('eb7001b9-f6a1-4ee9-b7b2-2d738e6897e6');
  OneSignal.Notifications.requestPermission(true);

  await UserRepository().saveOneSignalId();
  

  // await PushNotifications.init();

  // await PushNotifications.localNotiInt();

  // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // // on background notification tapped
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   if(message.notification != null){
  //     SLoggerHelper.info('Background Notification tapped: ${message.notification!.body}');

  //   }
  // });


    runApp(const App());
  // try {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   //await UserPreference.init();
  // } catch (e) {
  //   null;
  // }
//   runApp(
//   MultiProvider(
//       providers: [
//         StreamProvider<NewUserData?>.value(
//           value: AuthServices().newUserData,
//           initialData: null
//         ),
        
//       ],
//     child: const MyApp(),
//     ),  
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     //final user = Provider.of<NewUserData?>(context);
//     return MaterialApp(
//       title: 'SafeTrack App',
//       theme: ThemeData(
        
//         colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(9, 31, 91, 1)),
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false ,
//       home: const Wrapper(),
//       // onGenerateRoute: (settings) {
//       //   if(settings.name == '/bottomNav'){
//       //     final role = settings.arguments as String;
//       //     return MaterialPageRoute(builder: (context)=> BottomNav(role: role)
//       //     );
//       //   }
//       // },
//       routes: {
//         "/home": (context) => const HomeScreen(),
//         "/wrapper": (context) => const Wrapper(),
//         "/login":(context) => const UserSignIn(),
//         "/auth/forgetPassword":(context) => const ForgetPassword(),
//         "/auth/signIn": (context) => const UserSignIn(),
//       },
//     );
//   }
}


