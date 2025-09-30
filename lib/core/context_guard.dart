import 'package:flutter/widgets.dart';

/// Utility for safely using BuildContext in async operations
/// Helps avoid use_build_context_synchronously lints
class ContextGuard {
  /// Check if context is still mounted and valid for use
  static bool isMounted(BuildContext? context) {
    if (context == null) return false;
    
    try {
      // Try to access context properties to verify it's still valid
      return context.mounted;
    } catch (e) {
      return false;
    }
  }
  
  /// Execute a function with context only if it's still mounted
  static void ifMounted(BuildContext? context, void Function(BuildContext) callback) {
    if (isMounted(context)) {
      callback(context!);
    }
  }
  
  /// Show a snackbar only if context is still mounted
  static void showSnackBar(
    BuildContext? context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ifMounted(context, (ctx) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: duration,
        ),
      );
    });
  }
  
  /// Show success snackbar
  static void showSuccess(BuildContext? context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: const Color(0xFF4CAF50), // Green
    );
  }
  
  /// Show error snackbar
  static void showError(BuildContext? context, String message) {
    ifMounted(context, (ctx) {
      showSnackBar(
        context,
        message,
        backgroundColor: Theme.of(ctx).colorScheme.error,
      );
    });
  }
  
  /// Navigate only if context is mounted
  static void navigateIfMounted(BuildContext? context, void Function(BuildContext) navigate) {
    ifMounted(context, navigate);
  }
  
  /// Pop only if context is mounted
  static void popIfMounted(BuildContext? context) {
    ifMounted(context, (ctx) {
      if (Navigator.of(ctx).canPop()) {
        Navigator.of(ctx).pop();
      }
    });
  }
}