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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBfEOkzHAqsfuadgaEZ-DiKBciSD59JJDA',
    appId: '1:294426985595:web:2ab098487a6dc3d957cede',
    messagingSenderId: '294426985595',
    projectId: 'raj-eat',
    authDomain: 'raj-eat.firebaseapp.com',
    storageBucket: 'raj-eat.appspot.com',
    measurementId: 'G-3R7KJ8964J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDako664S6hrpylU8nlmE3OBN2HykOXQ4Y',
    appId: '1:294426985595:android:b84e732766adf18f57cede',
    messagingSenderId: '294426985595',
    projectId: 'raj-eat',
    storageBucket: 'raj-eat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClhZ7ecNLSJfLmodsOOZohC7blrBr2noo',
    appId: '1:294426985595:ios:4cb58f427d25759657cede',
    messagingSenderId: '294426985595',
    projectId: 'raj-eat',
    storageBucket: 'raj-eat.appspot.com',
    iosBundleId: 'com.example.rajEat',
  );
}
