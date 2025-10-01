import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

class FirebaseBootstrap {
  static bool _isInitialized = false;
  static bool get isFirebaseReady => _isInitialized;
  
  static Future<void> initialize() async {
    try {
      // Initialize Firebase with live configuration
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
      
      if (kDebugMode) {
        print('Firebase initialized successfully');
        print('Project: ${DefaultFirebaseOptions.currentPlatform.projectId}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization failed: $e');
        print('App will run in offline mode');
      }
      _isInitialized = false;
      rethrow;
    }
  }
  
  static void markAsInitialized() {
    _isInitialized = true;
  }
}
