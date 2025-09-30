// Secrets configuration for nofApp
// This file should be ignored in git and keys provided via environment or CI/CD

class Secrets {
  // RevenueCat API Keys (will be provided later)
  static const String revenueCatApiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: '', // Empty for development - will be provided later
  );
  
  // Firebase configuration will be in firebase_options.dart (generated)
  
  // Premium product identifiers
  static const String premiumMonthlyProductId = 'nofapp_premium_monthly';
  static const String premiumAnnualProductId = 'nofapp_premium_annual';
  
  // Development flags
  static const bool isDevelopmentMode = bool.fromEnvironment('DEVELOPMENT', defaultValue: true);
  static const bool mockPremiumFeatures = bool.fromEnvironment('MOCK_PREMIUM', defaultValue: false);
  
  // Helper methods
  static bool get hasRevenueCatKey => revenueCatApiKey.isNotEmpty;
  static bool get isProductionMode => !isDevelopmentMode;
}
