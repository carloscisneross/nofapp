import 'package:flutter/material.dart';

/// Utilities for implementing optimistic UI patterns
class OptimisticUI {
  /// Execute an operation with optimistic UI updates
  /// 
  /// Shows immediate feedback to the user, then either:
  /// - Keeps the optimistic state if successful
  /// - Reverts to previous state if failed
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    required VoidCallback onOptimisticUpdate,
    required VoidCallback onRevert,
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    // Apply optimistic update immediately
    onOptimisticUpdate();
    
    try {
      // Execute the actual operation
      final result = await operation().timeout(timeout);
      
      // Success callback if provided
      onSuccess?.call();
      
      return result;
    } catch (error) {
      // Revert optimistic update on error
      onRevert();
      
      // Error callback if provided
      onError?.call(error);
      
      // Re-throw to let caller handle the error
      rethrow;
    }
  }
  
  /// Create an optimistic state manager for a specific value
  static OptimisticStateManager<T> createManager<T>(T initialValue) {
    return OptimisticStateManager<T>(initialValue);
  }
}

/// Manages optimistic state for a single value
class OptimisticStateManager<T> extends ValueNotifier<T> {
  T _committedValue;
  T? _optimisticValue;
  bool _hasOptimisticValue = false;

  OptimisticStateManager(T initialValue) 
      : _committedValue = initialValue,
        super(initialValue);

  /// Current committed (confirmed) value
  T get committedValue => _committedValue;
  
  /// Whether there's a pending optimistic update
  bool get hasOptimisticValue => _hasOptimisticValue;
  
  /// Apply an optimistic update
  void applyOptimistic(T optimisticValue) {
    _optimisticValue = optimisticValue;
    _hasOptimisticValue = true;
    value = optimisticValue;
  }
  
  /// Commit the current optimistic value as the new committed value
  void commit() {
    if (_hasOptimisticValue && _optimisticValue != null) {
      _committedValue = _optimisticValue!;
      _optimisticValue = null;
      _hasOptimisticValue = false;
    }
  }
  
  /// Revert to the committed value, discarding optimistic changes
  void revert() {
    if (_hasOptimisticValue) {
      _optimisticValue = null;
      _hasOptimisticValue = false;
      value = _committedValue;
    }
  }
  
  /// Update the committed value (from external source like network response)
  void updateCommitted(T newValue) {
    _committedValue = newValue;
    if (!_hasOptimisticValue) {
      value = newValue;
    }
  }
}

/// Widget that provides optimistic UI capabilities to its children
class OptimisticUIProvider extends InheritedWidget {
  final Map<String, OptimisticStateManager> _managers = {};

  OptimisticUIProvider({
    super.key,
    required super.child,
  });

  /// Get or create a state manager for a specific key
  OptimisticStateManager<T> getManager<T>(String key, T initialValue) {
    if (!_managers.containsKey(key)) {
      _managers[key] = OptimisticStateManager<T>(initialValue);
    }
    return _managers[key] as OptimisticStateManager<T>;
  }

  /// Remove a state manager
  void removeManager(String key) {
    _managers[key]?.dispose();
    _managers.remove(key);
  }

  static OptimisticUIProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OptimisticUIProvider>();
  }

  static OptimisticUIProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No OptimisticUIProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(OptimisticUIProvider oldWidget) => false;
}

/// Example optimistic UI patterns
class OptimisticPatterns {
  /// Optimistic like/reaction toggle
  static Future<void> toggleReaction({
    required String postId,
    required String emoji,
    required OptimisticStateManager<Map<String, int>> reactionsManager,
    required Future<void> Function(String postId, String emoji) apiCall,
    Function(dynamic)? onError,
  }) async {
    final currentReactions = Map<String, int>.from(reactionsManager.committedValue);
    final newReactions = Map<String, int>.from(currentReactions);
    
    // Toggle optimistically
    if (newReactions.containsKey(emoji) && newReactions[emoji]! > 0) {
      newReactions[emoji] = newReactions[emoji]! - 1;
      if (newReactions[emoji] == 0) {
        newReactions.remove(emoji);
      }
    } else {
      newReactions[emoji] = (newReactions[emoji] ?? 0) + 1;
    }

    await OptimisticUI.execute(
      operation: () => apiCall(postId, emoji),
      onOptimisticUpdate: () => reactionsManager.applyOptimistic(newReactions),
      onRevert: () => reactionsManager.revert(),
      onSuccess: () => reactionsManager.commit(),
      onError: onError,
    );
  }
  
  /// Optimistic counter increment (e.g., streak)
  static Future<void> incrementCounter({
    required OptimisticStateManager<int> counterManager,
    required Future<int> Function() apiCall,
    Function(dynamic)? onError,
  }) async {
    final currentValue = counterManager.committedValue;
    final optimisticValue = currentValue + 1;

    await OptimisticUI.execute(
      operation: apiCall,
      onOptimisticUpdate: () => counterManager.applyOptimistic(optimisticValue),
      onRevert: () => counterManager.revert(),
      onSuccess: () => counterManager.commit(),
      onError: onError,
    );
  }
}