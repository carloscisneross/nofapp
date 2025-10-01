import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Platform-specific utilities and optimizations
class PlatformUtils {
  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  
  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  
  /// Check if running on mobile (iOS or Android)
  static bool get isMobile => isAndroid || isIOS;
  
  /// Check if running on web
  static bool get isWeb => kIsWeb;
  
  /// Get platform-appropriate haptic feedback
  static void hapticFeedback({HapticFeedbackType type = HapticFeedbackType.lightImpact}) {
    if (isMobile) {
      switch (type) {
        case HapticFeedbackType.lightImpact:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.mediumImpact:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selectionClick:
          HapticFeedback.selectionClick();
          break;
      }
    }
  }
  
  /// Get platform-appropriate animation duration
  static Duration getAnimationDuration({bool isQuick = false}) {
    if (isIOS) {
      return isQuick ? const Duration(milliseconds: 200) : const Duration(milliseconds: 300);
    } else {
      // Android Material Design timing
      return isQuick ? const Duration(milliseconds: 150) : const Duration(milliseconds: 250);
    }
  }
  
  /// Check if device supports biometrics (placeholder - requires local_auth package)
  static Future<bool> supportsBiometrics() async {
    // This would require adding local_auth package
    // For now, return false as a safe default
    return false;
  }
  
  /// Get safe area padding for platform
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
  
  /// Platform-specific keyboard handling
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
  
  /// Show platform-appropriate loading indicator
  static Widget getPlatformLoadingIndicator({double? size, Color? color}) {
    if (isIOS) {
      return SizedBox(
        width: size ?? 20,
        height: size ?? 20,
        child: const CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
      );
    } else {
      return SizedBox(
        width: size ?? 24,
        height: size ?? 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: color != null ? AlwaysStoppedAnimation<Color>(color) : null,
        ),
      );
    }
  }
}

/// Platform-specific constants and configurations
class PlatformConstants {
  /// Minimum tap target size for accessibility
  static const double minTapTargetSize = 44.0;
  
  /// Standard padding values
  static const double standardPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  
  /// Border radius values
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  
  /// Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve quickCurve = Curves.easeOut;
  
  /// Typography scale ratios
  static const double headlineScale = 1.5;
  static const double titleScale = 1.25;
  static const double bodyScale = 1.0;
  static const double captionScale = 0.85;
}

/// Enum for haptic feedback types
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
}