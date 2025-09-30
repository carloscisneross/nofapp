import 'package:flutter/widgets.dart';

/// Optimized image widget with caching and error handling
class OptimizedImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableMemoryCache;

  const OptimizedImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.enableMemoryCache = true,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      // Enable memory caching for performance
      cacheWidth: width?.round(),
      cacheHeight: height?.round(),
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? 
            Container(
              width: width,
              height: height,
              color: const Color(0xFFF5F5F5),
              child: const Icon(
                Icons.image_not_supported,
                color: Color(0xFFBDBDBD),
              ),
            );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: frame == null 
              ? (placeholder ?? 
                  Container(
                    width: width,
                    height: height,
                    color: const Color(0xFFF5F5F5),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ))
              : child,
        );
      },
    );
  }
}

/// Optimized avatar widget with consistent sizing and caching
class OptimizedAvatar extends StatelessWidget {
  final String imagePath;
  final double radius;
  final Widget? placeholder;
  final VoidCallback? onTap;

  const OptimizedAvatar({
    super.key,
    required this.imagePath,
    this.radius = 24,
    this.placeholder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFF5F5F5),
      child: ClipOval(
        child: OptimizedImage(
          imagePath: imagePath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: placeholder,
          errorWidget: Icon(
            Icons.person,
            size: radius,
            color: const Color(0xFFBDBDBD),
          ),
        ),
      ),
    );

    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}

/// Performance utilities for images
class ImagePerformanceUtils {
  /// Calculate optimal cache dimensions based on device pixel ratio
  static Size getOptimalCacheSize(Size displaySize, BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Size(
      (displaySize.width * devicePixelRatio).round().toDouble(),
      (displaySize.height * devicePixelRatio).round().toDouble(),
    );
  }
  
  /// Preload critical images for better UX
  static Future<void> preloadImages(
    BuildContext context, 
    List<String> imagePaths,
  ) async {
    final futures = imagePaths.map((path) {
      return precacheImage(AssetImage(path), context);
    });
    
    await Future.wait(futures);
  }
  
  /// Get memory-efficient image size for lists
  static Size getListItemImageSize() {
    return const Size(80, 80); // Standard list item size
  }
  
  /// Get memory-efficient image size for feed items
  static Size getFeedImageSize() {
    return const Size(120, 120); // Feed avatar size
  }
}