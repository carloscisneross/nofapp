import 'dart:async';
import 'package:flutter/foundation.dart';

class NetworkGuard {
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;
  
  /// Execute a network operation with timeout and retry logic
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    Duration timeout = defaultTimeout,
    int maxRetries = NetworkGuard.maxRetries,
    Duration retryDelay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    int attempts = 0;
    Exception? lastError;
    
    while (attempts < maxRetries) {
      try {
        attempts++;
        
        final result = await operation().timeout(timeout);
        
        // Success - return result
        return result;
      } on TimeoutException catch (e) {
        lastError = Exception('Network timeout${operationName != null ? ' for $operationName' : ''}: ${e.message}');
        
        if (kDebugMode) {
          print('NetworkGuard: Timeout on attempt $attempts${operationName != null ? ' for $operationName' : ''}');
        }
      } catch (e) {
        lastError = Exception('Network error${operationName != null ? ' for $operationName' : ''}: $e');
        
        if (kDebugMode) {
          print('NetworkGuard: Error on attempt $attempts${operationName != null ? ' for $operationName' : ''}: $e');
        }
      }
      
      // If this wasn't the last attempt, wait before retrying
      if (attempts < maxRetries) {
        await Future.delayed(retryDelay);
      }
    }
    
    // All attempts failed - throw the last error
    throw lastError ?? Exception('Unknown network error');
  }
  
  /// Check if an error is recoverable (should retry)
  static bool isRecoverable(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Recoverable errors
    if (errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('socket')) {
      return true;
    }
    
    // Non-recoverable errors
    if (errorString.contains('permission') ||
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden') ||
        errorString.contains('not found')) {
      return false;
    }
    
    // Default to recoverable for unknown errors
    return true;
  }
  
  /// Execute with smart retry (only retry recoverable errors)
  static Future<T> executeWithSmartRetry<T>({
    required Future<T> Function() operation,
    Duration timeout = defaultTimeout,
    int maxRetries = NetworkGuard.maxRetries,
    Duration retryDelay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    int attempts = 0;
    Exception? lastError;
    
    while (attempts < maxRetries) {
      try {
        attempts++;
        
        final result = await operation().timeout(timeout);
        
        // Success - return result
        return result;
      } catch (e) {
        lastError = Exception('Network error${operationName != null ? ' for $operationName' : ''}: $e');
        
        if (kDebugMode) {
          print('NetworkGuard: Error on attempt $attempts${operationName != null ? ' for $operationName' : ''}: $e');
        }
        
        // Check if this error is recoverable
        if (!isRecoverable(e)) {
          if (kDebugMode) {
            print('NetworkGuard: Non-recoverable error, not retrying');
          }
          throw lastError;
        }
      }
      
      // If this wasn't the last attempt, wait before retrying
      if (attempts < maxRetries) {
        await Future.delayed(retryDelay);
      }
    }
    
    // All attempts failed - throw the last error
    throw lastError ?? Exception('Unknown network error');
  }
}