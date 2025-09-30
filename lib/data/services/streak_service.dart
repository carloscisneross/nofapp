import 'dart:math' as math;

import '../models/user_profile.dart';
import '../../core/constants.dart';
import '../../core/network_guard.dart';
import 'profile_repository.dart';
import 'medal_service.dart';

class StreakService {
  static StreakService? _instance;
  static StreakService get instance => _instance ??= StreakService._();
  StreakService._();

  final _profileRepository = ProfileRepository.instance;
  final _medalService = MedalService.instance;

  Future<StreakData> checkIn(String userId) async {
    final profile = await _profileRepository.getUserProfile(userId);
    if (profile == null) {
      throw Exception('User profile not found');
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCheckIn = profile.streak.lastCheckInAt;
    
    // Check if already checked in today
    if (lastCheckIn != null) {
      final lastCheckInDate = DateTime(
        lastCheckIn.year,
        lastCheckIn.month,
        lastCheckIn.day,
      );
      
      if (lastCheckInDate.isAtSameMomentAs(today)) {
        throw Exception('Already checked in today');
      }
    }

    // Calculate new streak
    final newStreak = _calculateNewStreak(profile.streak, now);
    
    // Update streak in profile
    await _profileRepository.updateStreak(userId, newStreak);
    
    // Check for new medals
    await _checkForNewMedals(userId, newStreak.current);
    
    return newStreak;
  }

  StreakData _calculateNewStreak(StreakData currentStreak, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final lastCheckIn = currentStreak.lastCheckInAt;
    
    if (lastCheckIn == null) {
      // First check-in
      return StreakData(
        current: 1,
        lastCheckInAt: now,
        totalDays: currentStreak.totalDays + 1,
        longestStreak: math.max(1, currentStreak.longestStreak),
      );
    }
    
    final lastCheckInDate = DateTime(
      lastCheckIn.year,
      lastCheckIn.month,
      lastCheckIn.day,
    );
    
    final daysDifference = today.difference(lastCheckInDate).inDays;
    
    if (daysDifference == 1) {
      // Consecutive day - increment streak
      final newCurrent = currentStreak.current + 1;
      return StreakData(
        current: newCurrent,
        lastCheckInAt: now,
        totalDays: currentStreak.totalDays + 1,
        longestStreak: math.max(newCurrent, currentStreak.longestStreak),
      );
    } else if (daysDifference > 1) {
      // Streak broken - reset to 1
      return StreakData(
        current: 1,
        lastCheckInAt: now,
        totalDays: currentStreak.totalDays + 1,
        longestStreak: currentStreak.longestStreak,
      );
    } else {
      // Same day - shouldn't happen due to check above
      return currentStreak;
    }
  }

  Future<void> _checkForNewMedals(String userId, int currentStreak) async {
    final profile = await _profileRepository.getUserProfile(userId);
    if (profile == null) return;
    
    for (final threshold in AppConstants.medalThresholds) {
      if (currentStreak >= threshold) {
        final medalId = 'personal_${AppConstants.medalThresholds.indexOf(threshold) + 1}';
        
        if (!profile.personalMedals.contains(medalId)) {
          await _profileRepository.addMedal(userId, medalId);
        }
      }
    }
  }

  bool canCheckInToday(StreakData streak) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCheckIn = streak.lastCheckInAt;
    
    if (lastCheckIn == null) {
      return true;
    }
    
    final lastCheckInDate = DateTime(
      lastCheckIn.year,
      lastCheckIn.month,
      lastCheckIn.day,
    );
    
    return !lastCheckInDate.isAtSameMomentAs(today);
  }

  int getNextMedalThreshold(int currentStreak) {
    for (final threshold in AppConstants.medalThresholds) {
      if (currentStreak < threshold) {
        return threshold;
      }
    }
    return AppConstants.medalThresholds.last * 2; // Next level beyond max
  }

  double getProgressToNextMedal(int currentStreak) {
    final nextThreshold = getNextMedalThreshold(currentStreak);
    final previousThreshold = _getPreviousMedalThreshold(currentStreak);
    
    if (nextThreshold == previousThreshold) {
      return 1.0; // Already at max
    }
    
    final progress = (currentStreak - previousThreshold) / 
                    (nextThreshold - previousThreshold);
    return progress.clamp(0.0, 1.0);
  }

  int _getPreviousMedalThreshold(int currentStreak) {
    int previous = 0;
    for (final threshold in AppConstants.medalThresholds) {
      if (currentStreak < threshold) {
        return previous;
      }
      previous = threshold;
    }
    return previous;
  }
}
