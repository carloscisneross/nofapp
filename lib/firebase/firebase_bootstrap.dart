import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// Conditional import for firebase_options.dart
// This will be available once firebase_options.dart is provided
// ignore: unused_import
import 'firebase_options_stub.dart'
  if (dart.library.io) 'firebase_options_live.dart'
  as firebase_config;

class FirebaseBootstrap {
  static bool _isInitialized = false;
  static bool get isFirebaseReady => _isInitialized;
  
  static Future<void> initialize() async {
    try {
      // Try to initialize Firebase with provided options
      final options = firebase_config.getFirebaseOptions();
      
      if (options != null) {
        await Firebase.initializeApp(options: options);
        _isInitialized = true;
        
        if (kDebugMode) {
          print('Firebase initialized successfully');
        }
      } else {
        // Firebase options not available - use stub mode
        if (kDebugMode) {
          print('Firebase initialization skipped - configuration not available');
          print('This is expected during initial development');
          print('To enable Firebase:');
          print('1. Add lib/firebase/firebase_options.dart');
          print('2. Add android/app/google-services.json');
          print('3. Add ios/Runner/GoogleService-Info.plist');
        }
        _isInitialized = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization failed: $e');
        print('App will run in offline mode until Firebase is configured');
      }
      _isInitialized = false;
    }
  }
  
  static void markAsInitialized() {
    _isInitialized = true;
  }
}
