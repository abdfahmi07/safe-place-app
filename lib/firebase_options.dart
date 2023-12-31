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
    apiKey: 'AIzaSyDx0TSC5JsWo8Z6itQHmfBUhlQ7-oDzC1M',
    appId: '1:1066941047718:web:0c3bf18d6fa1f707232567',
    messagingSenderId: '1066941047718',
    projectId: 'safe-place-app-f0a30',
    authDomain: 'safe-place-app-f0a30.firebaseapp.com',
    storageBucket: 'safe-place-app-f0a30.appspot.com',
    measurementId: 'G-MCJ5RYXMZN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBV1U9F4XaGzK12xB-_7zBiwOPcH_yXRYc',
    appId: '1:1066941047718:android:0ca4ba2c989e247d232567',
    messagingSenderId: '1066941047718',
    projectId: 'safe-place-app-f0a30',
    storageBucket: 'safe-place-app-f0a30.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXSw-niUYxmXAWvF51Oa819cypjavtAE4',
    appId: '1:1066941047718:ios:eb24ce48246aef61232567',
    messagingSenderId: '1066941047718',
    projectId: 'safe-place-app-f0a30',
    storageBucket: 'safe-place-app-f0a30.appspot.com',
    iosBundleId: 'com.example.safePlaceApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXSw-niUYxmXAWvF51Oa819cypjavtAE4',
    appId: '1:1066941047718:ios:e8fdf27cf4935c96232567',
    messagingSenderId: '1066941047718',
    projectId: 'safe-place-app-f0a30',
    storageBucket: 'safe-place-app-f0a30.appspot.com',
    iosBundleId: 'com.example.safePlaceApp.RunnerTests',
  );
}
