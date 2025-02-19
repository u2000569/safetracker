// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1PKffyKf3fIszXQbVoloHNJ9k7XcnKYA',
    appId: '1:262816012279:android:3522f00d6e0c6ea18600f2',
    messagingSenderId: '262816012279',
    projectId: 'pickready',
    storageBucket: 'pickready.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqoBOWpdBFOm24VTwJSh9v4jcmRRZswFA',
    appId: '1:262816012279:ios:b50cb78617bb51c18600f2',
    messagingSenderId: '262816012279',
    projectId: 'pickready',
    storageBucket: 'pickready.appspot.com',
    androidClientId: '262816012279-1o8jkkatkfq3tanj2f8qchtdr2hhdk4p.apps.googleusercontent.com',
    iosClientId: '262816012279-93v0ft7m8l98n1mtctcruf2qbj1711c2.apps.googleusercontent.com',
    iosBundleId: 'com.example.safetracker',
  );
}
