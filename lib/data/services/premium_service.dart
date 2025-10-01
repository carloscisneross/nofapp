import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumService {
  static PremiumService? _instance;
  static PremiumService get instance => _instance ??= PremiumService._();
  PremiumService._();

  bool _isInitialized = false;
  CustomerInfo? _currentCustomerInfo;
  
  final StreamController<bool> _premiumStatusController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;

  bool get isInitialized => _isInitialized;
  bool get isPremium => _currentCustomerInfo?.entitlements.active.containsKey('premium') ?? false;
  CustomerInfo? get currentCustomerInfo => _currentCustomerInfo;

  Future<void> initialize() async {
    try {
      // Get API keys from secrets - will be provided later
      final config = _getRevenueCatConfig();
      
      if (config.apiKey.isEmpty) {
        if (kDebugMode) {
          print('RevenueCat API key not provided - premium features will be mocked');
        }
        _isInitialized = false;
        return;
      }

      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);
      
      final configuration = PurchasesConfiguration(config.apiKey)
        ..appUserID = null; // Let RevenueCat generate anonymous ID
        
      await Purchases.configure(configuration);
      
      // Listen to customer info updates
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);
      
      // Get initial customer info
      _currentCustomerInfo = await Purchases.getCustomerInfo();
      _premiumStatusController.add(isPremium);
      
      _isInitialized = true;
      
      if (kDebugMode) {
        print('RevenueCat initialized successfully');
        print('Premium status: $isPremium');
      }
    } catch (e) {
      if (kDebugMode) {
        print('RevenueCat initialization failed: $e');
      }
      _isInitialized = false;
    }
  }

  Future<List<Offering>> getOfferings() async {
    if (!_isInitialized) {
      return [];
    }
    
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.all.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get offerings: $e');
      }
      return [];
    }
  }

  Future<bool> purchasePackage(Package package) async {
    if (!_isInitialized) {
      return false;
    }
    
    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      _currentCustomerInfo = purchaserInfo.customerInfo;
      _premiumStatusController.add(isPremium);
      return isPremium;
    } catch (e) {
      if (kDebugMode) {
        print('Purchase failed: $e');
      }
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    if (!_isInitialized) {
      return false;
    }
    
    try {
      final customerInfo = await Purchases.restorePurchases();
      _currentCustomerInfo = customerInfo;
      _premiumStatusController.add(isPremium);
      return isPremium;
    } catch (e) {
      if (kDebugMode) {
        print('Restore purchases failed: $e');
      }
      return false;
    }
  }

  Future<void> updateUserId(String userId) async {
    if (!_isInitialized) {
      return;
    }
    
    try {
      await Purchases.logIn(userId);
      _currentCustomerInfo = await Purchases.getCustomerInfo();
      _premiumStatusController.add(isPremium);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update user ID: $e');
      }
    }
  }

  Future<void> logout() async {
    if (!_isInitialized) {
      return;
    }
    
    try {
      await Purchases.logOut();
      _currentCustomerInfo = await Purchases.getCustomerInfo();
      _premiumStatusController.add(isPremium);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to logout: $e');
      }
    }
  }

  void _onCustomerInfoUpdate(CustomerInfo customerInfo) {
    _currentCustomerInfo = customerInfo;
    _premiumStatusController.add(isPremium);
    
    if (kDebugMode) {
      print('Customer info updated - Premium status: $isPremium');
    }
  }

  RevenueCatConfig _getRevenueCatConfig() {
    // Get SDK keys from --dart-define
    const iosSdkKey = String.fromEnvironment('RC_IOS_SDK_KEY', defaultValue: '');
    const androidSdkKey = String.fromEnvironment('RC_ANDROID_SDK_KEY', defaultValue: '');
    
    // Use platform-appropriate key
    String apiKey = '';
    if (Platform.isIOS && iosSdkKey.isNotEmpty) {
      apiKey = iosSdkKey;
    } else if (Platform.isAndroid && androidSdkKey.isNotEmpty) {
      apiKey = androidSdkKey;
    }
    // Android products will be configured after Play Console upload
    
    return RevenueCatConfig(
      apiKey: apiKey,
      premiumProductId: 'nofapp_premium_monthly',
      premiumAnnualProductId: 'nofapp_premium_yearly',
      entitlementId: 'premium',
    );
  }

  void dispose() {
    _premiumStatusController.close();
  }
}

class RevenueCatConfig {
  final String apiKey;
  final String premiumProductId;
  final String premiumAnnualProductId;
  final String entitlementId;

  const RevenueCatConfig({
    required this.apiKey,
    required this.premiumProductId,
    required this.premiumAnnualProductId,
    required this.entitlementId,
  });
}
