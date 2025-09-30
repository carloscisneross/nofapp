import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/avatar.dart';
import '../../core/constants.dart';

class AssetManifestService {
  static AssetManifestService? _instance;
  static AssetManifestService get instance => _instance ??= AssetManifestService._();
  AssetManifestService._();

  Map<String, dynamic>? _assetInventory;
  List<Avatar>? _cachedAvatars;

  Future<void> loadAssetInventory() async {
    if (_assetInventory != null) return;
    
    try {
      final String inventoryJson = await rootBundle.loadString('ASSET_INVENTORY.json');
      _assetInventory = json.decode(inventoryJson) as Map<String, dynamic>;
    } catch (e) {
      // Fallback to hardcoded paths if ASSET_INVENTORY.json is not found
      _assetInventory = _generateFallbackInventory();
    }
  }

  Map<String, dynamic> _generateFallbackInventory() {
    return {
      'avatars': [
        'assets/avatars/female/female1.png',
        'assets/avatars/female/female2.png',
        'assets/avatars/female/female3.png',
        'assets/avatars/female/female4.png',
        'assets/avatars/female/female5.png',
        'assets/avatars/male/male1.png',
        'assets/avatars/male/male2.png',
        'assets/avatars/male/male3.png',
        'assets/avatars/male/male4.png',
        'assets/avatars/male/male5.png',
        'assets/avatars/premium/premium1.png',
        'assets/avatars/premium/premium2.png',
        'assets/avatars/premium/premium3.png',
        'assets/avatars/premium/premium4.png',
        'assets/avatars/premium/premium5.png',
        'assets/avatars/premium/premium6.png',
        'assets/avatars/premium/premium7.png',
      ],
      'medals_personal': [
        'assets/medals/personal/normal/level_1.png',
        'assets/medals/personal/normal/level_2.png',
        'assets/medals/personal/normal/level_3.png',
        'assets/medals/personal/normal/level_4.png',
        'assets/medals/personal/normal/level_5.png',
        'assets/medals/personal/normal/level_6.png',
        'assets/medals/personal/normal/level_7.png',
        'assets/medals/personal/normal/level_8.png',
        'assets/medals/personal/normal/level_9.png',
        'assets/medals/personal/normal/level_10.png',
        'assets/medals/personal/normal/level_11.png',
        'assets/medals/personal/normal/level_12.png',
      ],
      'medals_guild': [
        'assets/medals/guild/normal/guild medals/level 1.png',
        'assets/medals/guild/normal/guild medals/level 2.png',
        'assets/medals/guild/normal/guild medals/level 3.png',
        'assets/medals/guild/normal/guild medals/level 4.png',
        'assets/medals/guild/normal/guild medals/level 5.png',
        'assets/medals/guild/normal/guild medals/level 6.png',
        'assets/medals/guild/normal/guild medals/level 7.png',
        'assets/medals/guild/normal/guild medals/level 8.png',
        'assets/medals/guild/normal/guild medals/level 9.png',
        'assets/medals/guild/normal/guild medals/level 10.png',
      ],
    };
  }

  Future<List<Avatar>> getAvatars({required bool userIsPremium}) async {
    if (_cachedAvatars != null) {
      return _cachedAvatars!
          .map((avatar) => avatar.copyWith(isUnlocked: !avatar.isPremium || userIsPremium))
          .toList();
    }

    await loadAssetInventory();
    
    final avatarPaths = List<String>.from(_assetInventory!['avatars'] ?? []);
    _cachedAvatars = avatarPaths
        .map((path) => Avatar.fromAssetPath(path, userIsPremium: userIsPremium))
        .toList();
    
    return _cachedAvatars!;
  }

  Future<List<Avatar>> getFreeAvatars({required bool userIsPremium}) async {
    final allAvatars = await getAvatars(userIsPremium: userIsPremium);
    return allAvatars.where((avatar) => !avatar.isPremium).toList();
  }

  Future<List<Avatar>> getPremiumAvatars({required bool userIsPremium}) async {
    final allAvatars = await getAvatars(userIsPremium: userIsPremium);
    return allAvatars.where((avatar) => avatar.isPremium).toList();
  }

  Future<List<String>> getMedalPaths(String category) async {
    await loadAssetInventory();
    
    switch (category) {
      case 'personal':
        return List<String>.from(_assetInventory!['medals_personal'] ?? []);
      case 'guild':
        return List<String>.from(_assetInventory!['medals_guild'] ?? []);
      default:
        return [];
    }
  }

  Future<List<String>> getIconPaths(String platform) async {
    await loadAssetInventory();
    
    switch (platform) {
      case 'ios':
        return List<String>.from(_assetInventory!['icons_ios'] ?? []);
      case 'android':
        return List<String>.from(_assetInventory!['icons_android'] ?? []);
      default:
        return [];
    }
  }

  bool isValidAvatarPath(String path) {
    return path.startsWith('assets/avatars/') && path.endsWith('.png');
  }

  bool isValidMedalPath(String path) {
    return path.startsWith('assets/medals/') && path.endsWith('.png');
  }

  String getDefaultAvatarForCategory(String category) {
    switch (category) {
      case 'female':
        return 'assets/avatars/female/female1.png';
      case 'male':
        return 'assets/avatars/male/male1.png';
      case 'premium':
        return 'assets/avatars/premium/premium1.png';
      default:
        return AppConstants.defaultAvatarKey;
    }
  }
}
