import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  static bool _isInitialized = false;
  static bool get isFirebaseReady => _isInitialized;
  
  static Future<void> initialize() async {
    try {
      // Try to import firebase_options.dart
      // Will be provided as: lib/firebase/firebase_options.dart
        // Import firebase_options when available
        // ignore: unused_import
        final options = await _getFirebaseOptions();
        await Firebase.initializeApp(options: options);
        _isInitialized = true;
        
        if (kDebugMode) {
          print('Firebase initialized successfully');
        }
      } catch (e) {
        // firebase_options.dart not found - use stub mode
        if (kDebugMode) {
          print('Firebase initialization skipped - firebase_options.dart not found');
          print('This is expected during initial development');
        }
        _isInitialized = false;
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
