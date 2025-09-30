class Avatar {
  final String id;
  final String name;
  final String assetPath;
  final String category; // 'female', 'male', 'premium'
  final bool isPremium;
  final bool isUnlocked;

  const Avatar({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.category,
    required this.isPremium,
    required this.isUnlocked,
  });

  factory Avatar.fromAssetPath(String assetPath, {required bool userIsPremium}) {
    final parts = assetPath.split('/');
    final category = parts[2]; // assets/avatars/{category}/{filename}
    final filename = parts[3];
    final isPremium = category == 'premium';
    
    return Avatar(
      id: assetPath,
      name: _getAvatarName(filename),
      assetPath: assetPath,
      category: category,
      isPremium: isPremium,
      isUnlocked: !isPremium || userIsPremium,
    );
  }

  Avatar copyWith({
    bool? isUnlocked,
  }) {
    return Avatar(
      id: id,
      name: name,
      assetPath: assetPath,
      category: category,
      isPremium: isPremium,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static String _getAvatarName(String filename) {
    // Convert filename to display name
    // e.g., "female1.png" -> "Female 1"
    final nameWithoutExtension = filename.replaceAll('.png', '');
    final category = nameWithoutExtension.replaceAll(RegExp(r'\d+'), '').trim();
    final number = nameWithoutExtension.replaceAll(RegExp(r'[^\d]'), '').trim();
    
    if (number.isNotEmpty) {
      return '${category.substring(0, 1).toUpperCase()}${category.substring(1)} $number';
    }
    return category.substring(0, 1).toUpperCase() + category.substring(1);
  }
}

class AvatarCategory {
  final String id;
  final String name;
  final bool isPremium;
  final List<Avatar> avatars;

  const AvatarCategory({
    required this.id,
    required this.name,
    required this.isPremium,
    required this.avatars,
  });

  factory AvatarCategory.free(List<Avatar> avatars) {
    return AvatarCategory(
      id: 'free',
      name: 'Free',
      isPremium: false,
      avatars: avatars,
    );
  }

  factory AvatarCategory.premium(List<Avatar> avatars) {
    return AvatarCategory(
      id: 'premium',
      name: 'Premium',
      isPremium: true,
      avatars: avatars,
    );
  }
}
