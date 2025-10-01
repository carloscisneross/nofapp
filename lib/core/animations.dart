import 'package:flutter/material.dart';

/// Collection of reusable animations for nofApp
class NofAnimations {
  // Standard durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  
  // Standard curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;

  /// Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeInOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: child,
    );
  }

  /// Slide in from bottom animation
  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    double offset = 50.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, offset * value),
        child: Opacity(
          opacity: 1.0 - value,
          child: child,
        ),
      ),
      child: child,
    );
  }

  /// Scale animation (good for buttons)
  static Widget scaleIn({
    required Widget child,
    Duration duration = fast,
    Curve curve = bounce,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: child,
      ),
      child: child,
    );
  }

  /// Pulse animation for notifications/highlights
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: minScale, end: maxScale),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: child,
      ),
      onEnd: () {
        // This creates a continuous pulse effect
        // In a real implementation, you'd use AnimationController
      },
      child: child,
    );
  }

  /// Shimmer loading effect
  static Widget shimmer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (value - 0.3).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  /// Rotate animation
  static Widget rotate({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = easeInOut,
    double turns = 0.25, // Quarter turn by default
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: turns),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Transform.rotate(
        angle: value * 2 * 3.14159, // Convert turns to radians
        child: child,
      ),
      child: child,
    );
  }
}

/// Animated wrapper widgets for common UI patterns
class AnimatedWrappers {
  /// Animated container with hover effects
  static Widget hoverContainer({
    required Widget child,
    EdgeInsets? padding,
    Color? color,
    BorderRadius? borderRadius,
    Duration duration = NofAnimations.fast,
  }) {
    return AnimatedContainer(
      duration: duration,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }

  /// Animated list item that slides in
  static Widget listItem({
    required Widget child,
    required int index,
    Duration duration = NofAnimations.normal,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + (delay * index),
      curve: NofAnimations.easeOut,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 30 * (1 - value)),
        child: Opacity(
          opacity: value,
          child: child,
        ),
      ),
      child: child,
    );
  }

  /// Staggered animation for multiple items
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration duration = NofAnimations.normal,
    Duration staggerDelay = const Duration(milliseconds: 100),
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      
      return listItem(
        index: index,
        duration: duration,
        delay: staggerDelay,
        child: child,
      );
    }).toList();
  }
}

/// Page transition animations
class PageTransitions {
  /// Slide transition from right to left
  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
      transitionDuration: NofAnimations.normal,
    );
  }

  /// Fade transition
  static Route<T> fade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: NofAnimations.fast,
    );
  }

  /// Scale transition (good for modals)
  static Route<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: NofAnimations.normal,
    );
  }
}

/// Animated icons and micro-interactions
class AnimatedIcons {
  /// Animated check mark for success states
  static Widget checkmark({
    double size = 24,
    Color color = const Color(0xFF4CAF50),
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Icon(
          Icons.check_circle,
          size: size,
          color: color,
        ),
      ),
    );
  }

  /// Animated heart for likes
  static Widget heart({
    double size = 24,
    Color color = const Color(0xFFE91E63),
    Duration duration = const Duration(milliseconds: 300),
    bool isLiked = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: isLiked ? 0.8 : 1.0, end: 1.0),
      duration: duration,
      curve: Curves.bounceOut,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          size: size,
          color: isLiked ? color : null,
        ),
      ),
    );
  }
}