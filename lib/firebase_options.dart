import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform tidak didukung');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0-D4kXmfSDw5GmCI0awIJduTVw3VmE9k',
    appId: '1:680625362891:web:02d25958ffd55cde0d884e',
    messagingSenderId: '680625362891',
    projectId: 'my-budget-lite',
    authDomain: 'my-budget-lite.firebaseapp.com',
    storageBucket: 'my-budget-lite.firebasestorage.app',
    measurementId: 'G-20SG0FN742',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8HgZNPw79uCK-IFUIi1O4HD_9IiMjClI',
    appId: '1:680625362891:android:7c8449f33282f75f0d884e',
    messagingSenderId: '680625362891',
    projectId: 'my-budget-lite',
    storageBucket: 'my-budget-lite.firebasestorage.app',
  );
}
