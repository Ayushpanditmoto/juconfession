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
        return macos;
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
    apiKey: 'AIzaSyB4Ak_HK6AmXAv_qsqidqhXxnRDdo5iX4k',
    appId: '1:350783778730:web:55b1a029950d4ece92c5d3',
    messagingSenderId: '350783778730',
    projectId: 'juconfess-dae75',
    authDomain: 'juconfess-dae75.firebaseapp.com',
    storageBucket: 'juconfess-dae75.appspot.com',
    measurementId: 'G-XNSRSR6JC9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYyk-8tDe_jC6W2gFdsoQ1nrJ1YdDLYGE',
    appId: '1:350783778730:android:122e1fefb4efdf2092c5d3',
    messagingSenderId: '350783778730',
    projectId: 'juconfess-dae75',
    storageBucket: 'juconfess-dae75.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-6UpBnV9tXWGyCNYAJw5y0QzALZ7KeFI',
    appId: '1:350783778730:ios:403fac3bf62d588092c5d3',
    messagingSenderId: '350783778730',
    projectId: 'juconfess-dae75',
    storageBucket: 'juconfess-dae75.appspot.com',
    iosClientId: '350783778730-vnaqtukv625me11b8kdcb235mufb1ru7.apps.googleusercontent.com',
    iosBundleId: 'com.example.juconfession',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-6UpBnV9tXWGyCNYAJw5y0QzALZ7KeFI',
    appId: '1:350783778730:ios:403fac3bf62d588092c5d3',
    messagingSenderId: '350783778730',
    projectId: 'juconfess-dae75',
    storageBucket: 'juconfess-dae75.appspot.com',
    iosClientId: '350783778730-vnaqtukv625me11b8kdcb235mufb1ru7.apps.googleusercontent.com',
    iosBundleId: 'com.example.juconfession',
  );
}
