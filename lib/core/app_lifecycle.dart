import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

/// App lifecycle management for performance and resource optimization
class AppLifecycleManager extends WidgetsBindingObserver {
  static AppLifecycleManager? _instance;
  static AppLifecycleManager get instance => _instance ??= AppLifecycleManager._();
  AppLifecycleManager._();

  bool _isInitialized = false;
  AppLifecycleState? _currentState;

  /// Initialize lifecycle monitoring
  void initialize() {
    if (_isInitialized) return;
    
    WidgetsBinding.instance.addObserver(this);
    _currentState = WidgetsBinding.instance.lifecycleState;
    _isInitialized = true;
  }

  /// Cleanup lifecycle monitoring
  void dispose() {
    if (_isInitialized) {
      WidgetsBinding.instance.removeObserver(this);
      _isInitialized = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    final previousState = _currentState;
    _currentState = state;

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed(previousState);
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.hidden:
        _onAppHidden();
        break;
    }
  }

  void _onAppResumed(AppLifecycleState? previousState) {
    // App came back to foreground
    // Refresh time-sensitive data like streak status
    _refreshTimeData();
    
    // Re-enable system UI overlays
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _onAppPaused() {
    // App going to background
    // Save any pending data
    _savePendingData();
    
    // Clear sensitive data from memory if needed
    _clearSensitiveData();
  }

  void _onAppDetached() {
    // App is being terminated
    // Final cleanup
    _performFinalCleanup();
  }

  void _onAppInactive() {
    // App is inactive (e.g., during a phone call)
    // Pause non-essential operations
    _pauseNonEssentialOperations();
  }

  void _onAppHidden() {
    // App is hidden but still running
    // Similar to paused but less severe
    _reduceBackgroundActivity();
  }

  void _refreshTimeData() {
    // Refresh time-sensitive data when app resumes
    // This helps with streak calculations and day boundaries
    // Implementation would trigger relevant providers to refresh
  }

  void _savePendingData() {
    // Save any uncommitted changes
    // Useful for draft posts, profile changes, etc.
  }

  void _clearSensitiveData() {
    // Clear sensitive information from memory
    // Not typically needed for this app, but good practice
  }

  void _performFinalCleanup() {
    // Final resource cleanup before app termination
    // Close streams, cancel timers, etc.
  }

  void _pauseNonEssentialOperations() {
    // Pause animations, background tasks
    // Keep essential connectivity
  }

  void _reduceBackgroundActivity() {
    // Reduce activity but maintain core functionality
    // Pause auto-refresh, reduce animation frequency
  }

  /// Check if app is currently in foreground
  bool get isInForeground => _currentState == AppLifecycleState.resumed;

  /// Check if app is in background
  bool get isInBackground => 
      _currentState == AppLifecycleState.paused ||
      _currentState == AppLifecycleState.detached;

  /// Get current lifecycle state
  AppLifecycleState? get currentState => _currentState;
}

/// Widget that manages app lifecycle for its children
class AppLifecycleWrapper extends StatefulWidget {
  final Widget child;

  const AppLifecycleWrapper({super.key, required this.child});

  @override
  State<AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<AppLifecycleWrapper> {
  @override
  void initState() {
    super.initState();
    AppLifecycleManager.instance.initialize();
  }

  @override
  void dispose() {
    AppLifecycleManager.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}