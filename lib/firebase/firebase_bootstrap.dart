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
  
  /// Dynamically import firebase_options.dart when available
  static Future<dynamic> _getFirebaseOptions() async {
    // This will work when firebase_options.dart is provided
    try {
      // Dynamic import to avoid compile-time dependency
      final module = await import('../firebase_options.dart');
      return module.DefaultFirebaseOptions.currentPlatform;
    } catch (e) {
      throw Exception('firebase_options.dart not found. Please add Firebase configuration files.');
    }
  }
}
