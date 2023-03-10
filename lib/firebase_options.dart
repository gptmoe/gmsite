// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyA_OqxMRQAhHj6iX-L3uu2Rf_IxtHgKHUs",
      authDomain: "gptmoe-2259e.firebaseapp.com",
      projectId: "gptmoe-2259e",
      storageBucket: "gptmoe-2259e.appspot.com",
      messagingSenderId: "911314559713",
      appId: "1:911314559713:web:a21bc8efcfefd3f5ed4da0",
      measurementId: "G-1MBH02RQG8");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoVUpgxlIsl1etSdnC_tEl2uzAVeQ7izw',
    appId: '1:911314559713:android:41bfcae17d9bee08ed4da0',
    messagingSenderId: '911314559713',
    projectId: 'gptmoe-2259e',
    storageBucket: 'gptmoe-2259e.appspot.com',
  );
}
