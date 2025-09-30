class Medal {
  final String id;
  final String name;
  final String description;
  final String category; // 'personal', 'guild', 'world'
  final int level;
  final String assetPath;
  final String smallAssetPath;
  final int threshold; // streak days or guild level required
  final bool isUnlocked;

  const Medal({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.level,
    required this.assetPath,
    required this.smallAssetPath,
    required this.threshold,
    required this.isUnlocked,
  });

  factory Medal.personal({
    required int level,
    required int threshold,
    required bool isUnlocked,
  }) {
    return Medal(
      id: 'personal_$level',
      name: _getPersonalMedalName(level),
      description: _getPersonalMedalDescription(level, threshold),
      category: 'personal',
      level: level,
      assetPath: 'assets/medals/personal/normal/level_$level.png',
      smallAssetPath: 'assets/medals/personal/small/level_$level.png',
      threshold: threshold,
      isUnlocked: isUnlocked,
    );
  }

  factory Medal.guild({
    required int level,
    required bool isUnlocked,
  }) {
    return Medal(
      id: 'guild_$level',
      name: _getGuildMedalName(level),
      description: _getGuildMedalDescription(level),
      category: 'guild',
      level: level,
      assetPath: 'assets/medals/guild/normal/guild medals/level $level.png',
      smallAssetPath: 'assets/medals/guild/small/level $level.png',
      threshold: level,
      isUnlocked: isUnlocked,
    );
  }

  Medal copyWith({
    bool? isUnlocked,
  }) {
    return Medal(
      id: id,
      name: name,
      description: description,
      category: category,
      level: level,
      assetPath: assetPath,
      smallAssetPath: smallAssetPath,
      threshold: threshold,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static String _getPersonalMedalName(int level) {
    switch (level) {
      case 1:
        return 'Starter';
      case 2:
        return 'Consistent';
      case 3:
        return 'Dedicated';
      case 4:
        return 'Focused';
      case 5:
        return 'Determined';
      case 6:
        return 'Strong';
      case 7:
        return 'Resilient';
      case 8:
        return 'Champion';
      case 9:
        return 'Master';
      case 10:
        return 'Legend';
      case 11:
        return 'Hero';
      case 12:
        return 'Unstoppable';
      default:
        return 'Level $level';
    }
  }

  static String _getPersonalMedalDescription(int level, int threshold) {
    return 'Achieve a $threshold day streak';
  }

  static String _getGuildMedalName(int level) {
    switch (level) {
      case 1:
        return 'Guild Founder';
      case 2:
        return 'Guild Builder';
      case 3:
        return 'Guild Leader';
      case 4:
        return 'Guild Master';
      case 5:
        return 'Guild Champion';
      case 6:
        return 'Guild Legend';
      case 7:
        return 'Guild Hero';
      case 8:
        return 'Guild Elite';
      case 9:
        return 'Guild Supreme';
      case 10:
        return 'Guild Ultimate';
      default:
        return 'Guild Level $level';
    }
  }

  static String _getGuildMedalDescription(int level) {
    return 'Reach guild level $level';
  }
}
