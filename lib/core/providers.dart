import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../data/models/user_profile.dart';
import '../data/models/guild.dart';
import '../data/models/post.dart';
import '../data/models/medal.dart';
import '../data/models/avatar.dart';
import '../data/services/premium_service.dart';
import '../data/services/profile_repository.dart';
import '../data/services/guild_service.dart';
import '../data/services/post_service.dart';
import '../data/services/streak_service.dart';
import '../data/services/medal_service.dart';
import '../data/services/asset_manifest_service.dart';
import '../firebase/firebase_bootstrap.dart';
import '../app_router.dart';
import 'constants.dart';

// Theme Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Router Provider
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter(ref);
});

// Auth Providers
final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  return FirebaseBootstrap.isFirebaseReady ? FirebaseAuth.instance : null;
});

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  if (auth == null) {
    return Stream.value(null);
  }
  return auth.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Profile Providers
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository.instance;
});

final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getCurrentUserProfile();
});

final userProfileProvider = FutureProvider.family<UserProfile?, String>((ref, userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getUserProfile(userId);
});

// Premium Providers
final premiumServiceProvider = Provider<PremiumService>((ref) {
  return PremiumService.instance;
});

final premiumStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(premiumServiceProvider);
  return service.premiumStatusStream;
});

final isPremiumProvider = Provider<bool>((ref) {
  final premiumStatus = ref.watch(premiumStatusProvider);
  return premiumStatus.when(
    data: (isPremium) => isPremium,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Streak Providers
final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService.instance;
});

final currentStreakProvider = Provider<StreakData?>((ref) {
  final userProfile = ref.watch(currentUserProfileProvider);
  return userProfile.when(
    data: (profile) => profile?.streak,
    loading: () => null,
    error: (_, __) => null,
  );
});

final canCheckInTodayProvider = Provider<bool>((ref) {
  final streak = ref.watch(currentStreakProvider);
  if (streak == null) return true;
  
  final service = ref.watch(streakServiceProvider);
  return service.canCheckInToday(streak);
});

// Medal Providers
final medalServiceProvider = Provider<MedalService>((ref) {
  return MedalService.instance;
});

final personalMedalsProvider = Provider<List<Medal>>((ref) {
  final userProfile = ref.watch(currentUserProfileProvider);
  final service = ref.watch(medalServiceProvider);
  
  return userProfile.when(
    data: (profile) {
      if (profile == null) return [];
      return service.getPersonalMedals(earnedMedalIds: profile.personalMedals);
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final nextMedalProvider = Provider<Medal?>((ref) {
  final userProfile = ref.watch(currentUserProfileProvider);
  final service = ref.watch(medalServiceProvider);
  
  return userProfile.when(
    data: (profile) {
      if (profile == null) return null;
      return service.getNextPersonalMedal(
        profile.streak.current,
        profile.personalMedals,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final currentMedalProvider = Provider<Medal?>((ref) {
  final userProfile = ref.watch(currentUserProfileProvider);
  final service = ref.watch(medalServiceProvider);
  
  return userProfile.when(
    data: (profile) {
      if (profile == null) return null;
      return service.getCurrentPersonalMedal(profile.personalMedals);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final medalProgressProvider = Provider<double>((ref) {
  final streak = ref.watch(currentStreakProvider);
  final service = ref.watch(streakServiceProvider);
  
  if (streak == null) return 0.0;
  return service.getProgressToNextMedal(streak.current);
});

// Avatar Providers
final assetManifestServiceProvider = Provider<AssetManifestService>((ref) {
  return AssetManifestService.instance;
});

final availableAvatarsProvider = FutureProvider<List<Avatar>>((ref) async {
  final service = ref.watch(assetManifestServiceProvider);
  final isPremium = ref.watch(isPremiumProvider);
  
  return service.getAvatars(userIsPremium: isPremium);
});

final freeAvatarsProvider = FutureProvider<List<Avatar>>((ref) async {
  final service = ref.watch(assetManifestServiceProvider);
  final isPremium = ref.watch(isPremiumProvider);
  
  return service.getFreeAvatars(userIsPremium: isPremium);
});

final premiumAvatarsProvider = FutureProvider<List<Avatar>>((ref) async {
  final service = ref.watch(assetManifestServiceProvider);
  final isPremium = ref.watch(isPremiumProvider);
  
  return service.getPremiumAvatars(userIsPremium: isPremium);
});

// Guild Providers
final guildServiceProvider = Provider<GuildService>((ref) {
  return GuildService.instance;
});

final currentUserGuildProvider = StreamProvider<Guild?>((ref) {
  final userProfile = ref.watch(currentUserProfileProvider);
  final service = ref.watch(guildServiceProvider);
  
  return userProfile.when(
    data: (profile) {
      if (profile?.guildId == null) {
        return Stream.value(null);
      }
      return service.getGuild(profile!.guildId!);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

final publicGuildsProvider = StreamProvider<List<Guild>>((ref) {
  final service = ref.watch(guildServiceProvider);
  return service.getPublicGuilds();
});

// Post Providers
final postServiceProvider = Provider<PostService>((ref) {
  return PostService.instance;
});

final globalFeedProvider = StreamProvider<List<Post>>((ref) {
  final service = ref.watch(postServiceProvider);
  return service.getGlobalFeed();
});

final guildFeedProvider = StreamProvider.family<List<Post>, String>((ref, guildId) {
  final service = ref.watch(postServiceProvider);
  return service.getGuildFeed(guildId);
});

// Navigation State Providers
final selectedBottomNavIndexProvider = StateProvider<int>((ref) => 0);
final isOnboardingCompletedProvider = StateProvider<bool>((ref) => false);

// Loading States
final isLoadingProvider = StateProvider<bool>((ref) => false);
final errorMessageProvider = StateProvider<String?>((ref) => null);

// Form States
final loginFormProvider = StateProvider<Map<String, String>>((ref) => {
  'email': '',
  'password': '',
});

final signupFormProvider = StateProvider<Map<String, String>>((ref) => {
  'email': '',
  'password': '',
  'confirmPassword': '',
  'displayName': '',
});

final postComposerProvider = StateProvider<String>((ref) => '');

final guildFormProvider = StateProvider<Map<String, String>>((ref) => {
  'name': '',
  'description': '',
});