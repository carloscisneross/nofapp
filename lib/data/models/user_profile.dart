import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String avatarKey;
  final bool isPremium;
  final StreakData streak;
  final List<String> personalMedals;
  final String? guildId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.avatarKey,
    required this.isPremium,
    required this.streak,
    required this.personalMedals,
    this.guildId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      avatarKey: data['avatarKey'] ?? 'assets/avatars/male/male1.png',
      isPremium: data['isPremium'] ?? false,
      streak: StreakData.fromMap(data['streak'] ?? {}),
      personalMedals: List<String>.from(data['personalMedals'] ?? []),
      guildId: data['guildId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'avatarKey': avatarKey,
      'isPremium': isPremium,
      'streak': streak.toMap(),
      'personalMedals': personalMedals,
      'guildId': guildId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserProfile copyWith({
    String? email,
    String? displayName,
    String? avatarKey,
    bool? isPremium,
    StreakData? streak,
    List<String>? personalMedals,
    String? guildId,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarKey: avatarKey ?? this.avatarKey,
      isPremium: isPremium ?? this.isPremium,
      streak: streak ?? this.streak,
      personalMedals: personalMedals ?? this.personalMedals,
      guildId: guildId ?? this.guildId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class StreakData {
  final int current;
  final DateTime? lastCheckInAt;
  final int totalDays;
  final int longestStreak;

  const StreakData({
    required this.current,
    this.lastCheckInAt,
    required this.totalDays,
    required this.longestStreak,
  });

  factory StreakData.initial() {
    return const StreakData(
      current: 0,
      lastCheckInAt: null,
      totalDays: 0,
      longestStreak: 0,
    );
  }

  factory StreakData.fromMap(Map<String, dynamic> map) {
    return StreakData(
      current: map['current'] ?? 0,
      lastCheckInAt: (map['lastCheckInAt'] as Timestamp?)?.toDate(),
      totalDays: map['totalDays'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'current': current,
      'lastCheckInAt': lastCheckInAt != null ? Timestamp.fromDate(lastCheckInAt!) : null,
      'totalDays': totalDays,
      'longestStreak': longestStreak,
    };
  }

  StreakData copyWith({
    int? current,
    DateTime? lastCheckInAt,
    int? totalDays,
    int? longestStreak,
  }) {
    return StreakData(
      current: current ?? this.current,
      lastCheckInAt: lastCheckInAt ?? this.lastCheckInAt,
      totalDays: totalDays ?? this.totalDays,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }
}
