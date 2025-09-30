import '../models/medal.dart';
import '../../core/constants.dart';

class MedalService {
  static MedalService? _instance;
  static MedalService get instance => _instance ??= MedalService._();
  MedalService._();

  List<Medal> getPersonalMedals({required List<String> earnedMedalIds}) {
    final medals = <Medal>[];
    
    for (int i = 0; i < AppConstants.medalThresholds.length; i++) {
      final level = i + 1;
      final threshold = AppConstants.medalThresholds[i];
      final medalId = 'personal_$level';
      final isUnlocked = earnedMedalIds.contains(medalId);
      
      medals.add(Medal.personal(
        level: level,
        threshold: threshold,
        isUnlocked: isUnlocked,
      ));
    }
    
    return medals;
  }

  List<Medal> getGuildMedals({required int guildLevel}) {
    final medals = <Medal>[];
    
    for (int level = 1; level <= 10; level++) {
      final isUnlocked = guildLevel >= level;
      
      medals.add(Medal.guild(
        level: level,
        isUnlocked: isUnlocked,
      ));
    }
    
    return medals;
  }

  Medal? getNextPersonalMedal(int currentStreak, List<String> earnedMedalIds) {
    for (int i = 0; i < AppConstants.medalThresholds.length; i++) {
      final level = i + 1;
      final threshold = AppConstants.medalThresholds[i];
      final medalId = 'personal_$level';
      
      if (!earnedMedalIds.contains(medalId) && currentStreak < threshold) {
        return Medal.personal(
          level: level,
          threshold: threshold,
          isUnlocked: false,
        );
      }
    }
    
    // If all medals are earned, return the next theoretical medal
    if (earnedMedalIds.length >= AppConstants.medalThresholds.length) {
      return Medal.personal(
        level: AppConstants.medalThresholds.length + 1,
        threshold: AppConstants.medalThresholds.last * 2,
        isUnlocked: false,
      );
    }
    
    return null;
  }

  Medal? getNextGuildMedal(int guildLevel) {
    if (guildLevel < 10) {
      return Medal.guild(
        level: guildLevel + 1,
        isUnlocked: false,
      );
    }
    
    return null; // Max guild level reached
  }

  Medal? getCurrentPersonalMedal(List<String> earnedMedalIds) {
    if (earnedMedalIds.isEmpty) return null;
    
    // Find the highest level medal earned
    int highestLevel = 0;
    for (final medalId in earnedMedalIds) {
      if (medalId.startsWith('personal_')) {
        final levelStr = medalId.substring('personal_'.length);
        final level = int.tryParse(levelStr) ?? 0;
        if (level > highestLevel) {
          highestLevel = level;
        }
      }
    }
    
    if (highestLevel > 0 && highestLevel <= AppConstants.medalThresholds.length) {
      return Medal.personal(
        level: highestLevel,
        threshold: AppConstants.medalThresholds[highestLevel - 1],
        isUnlocked: true,
      );
    }
    
    return null;
  }

  Medal? getCurrentGuildMedal(int guildLevel) {
    if (guildLevel <= 0 || guildLevel > 10) return null;
    
    return Medal.guild(
      level: guildLevel,
      isUnlocked: true,
    );
  }
}
