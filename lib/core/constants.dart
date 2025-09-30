class AppConstants {
  // App Info
  static const String appName = 'nofApp';
  static const String androidBundleId = 'com.carlo.nofapp';
  static const String iosBundleId = 'com.carlo.nofapp';
  
  // Streak & Medal Thresholds
  static const List<int> medalThresholds = [
    1, 3, 5, 7, 10, 14, 21, 30, 60, 90, 180, 365
  ];
  
  // Asset Keys
  static const String avatarBasePath = 'assets/avatars';
  static const String medalBasePath = 'assets/medals';
  static const String iconBasePath = 'assets/icons';
  
  // Avatar Categories
  static const List<String> freeAvatarCategories = ['female', 'male'];
  static const List<String> premiumAvatarCategories = ['premium'];
  
  // Medal Categories  
  static const List<String> medalCategories = ['personal', 'guild'];
  
  // Navigation
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/auth/login';
  static const String signupRoute = '/auth/signup';
  static const String resetPasswordRoute = '/auth/reset-password';
  static const String homeRoute = '/home';
  static const String feedRoute = '/feed';
  static const String guildRoute = '/guild';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String guildsCollection = 'guilds';
  static const String postsCollection = 'posts';
  
  // Premium Features
  static const String premiumProductId = 'nofapp_premium_monthly';
  
  // Default Values
  static const String defaultAvatarKey = 'assets/avatars/male/male1.png';
  static const int maxStreakDaysGap = 1;
  static const int maxPostLength = 280;
  static const int maxGuildNameLength = 50;
  static const int maxDisplayNameLength = 30;
}

class AssetKeys {
  // Helper methods to get asset paths
  static String getAvatarPath(String category, String filename) {
    return '${AppConstants.avatarBasePath}/$category/$filename';
  }
  
  static String getMedalPath(String category, String size, String filename) {
    if (category == 'guild') {
      return '${AppConstants.medalBasePath}/guild/$size/guild medals/$filename';
    }
    return '${AppConstants.medalBasePath}/$category/$size/$filename';
  }
  
  static String getIconPath(String platform, String filename) {
    return '${AppConstants.iconBasePath}/$platform/$filename';
  }
}
