import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
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
    apiKey: 'AIzaSyC8yJynENoMxen2V33HG7AsSjqVLYO2h0Y',
    appId: '1:774290947113:web:6e9e0d849f9f707eb67038',
    messagingSenderId: '774290947113',
    projectId: 'my-notes-app-872ef',
    authDomain: 'my-notes-app-872ef.firebaseapp.com',
    storageBucket: 'my-notes-app-872ef.firebasestorage.app',
    measurementId: 'G-Z2R4B84VEP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBm6KJLBR-A1iPQVx5P_zqn2-bVOW89I7k',
    appId: '1:774290947113:android:f28511d7b04ec9c4b67038',
    messagingSenderId: '774290947113',
    projectId: 'my-notes-app-872ef',
    storageBucket: 'my-notes-app-872ef.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPyyNP50fFMSe4fX3HOi2ETcILSqyiU6w',
    appId: '1:774290947113:ios:d8773a962cd76f82b67038',
    messagingSenderId: '774290947113',
    projectId: 'my-notes-app-872ef',
    storageBucket: 'my-notes-app-872ef.firebasestorage.app',
    iosBundleId: 'com.example.notesApp',
  );
}
