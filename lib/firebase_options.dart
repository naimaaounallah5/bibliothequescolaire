// File: lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
/*
Remplacer les valeurs par celles de ton google-services.json :
current_key → apiKey
mobilesdk_app_id → appId
project_id → projectId
storage_bucket → storageBucket
project_number → messagingSenderId*/

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'AIzaSyCN0av_0y7vN_Wb0Y0yqnSGW53GWJzAulM',
    appId: '1:356712550908:android:a5ab86f947c362f5812279',
    messagingSenderId: '356712550908',
    projectId: 'bibliotheque-scolaire',
    storageBucket: 'bibliotheque-scolaire.firebasestorage.app',
  );
}