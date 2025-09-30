import 'package:cloud_firestore/cloud_firestore.dart';

class Guild {
  final String id;
  final String name;
  final String description;
  final int level;
  final String medalKey;
  final List<String> admins;
  final List<String> members;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Guild({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.medalKey,
    required this.admins,
    required this.members,
    required this.notificationsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Guild.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Guild(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      level: data['level'] ?? 1,
      medalKey: data['medalKey'] ?? 'assets/medals/guild/normal/guild medals/level 1.png',
      admins: List<String>.from(data['admins'] ?? []),
      members: List<String>.from(data['members'] ?? []),
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'level': level,
      'medalKey': medalKey,
      'admins': admins,
      'members': members,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Guild copyWith({
    String? name,
    String? description,
    int? level,
    String? medalKey,
    List<String>? admins,
    List<String>? members,
    bool? notificationsEnabled,
    DateTime? updatedAt,
  }) {
    return Guild(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      medalKey: medalKey ?? this.medalKey,
      admins: admins ?? this.admins,
      members: members ?? this.members,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool isAdmin(String userId) => admins.contains(userId);
  bool isMember(String userId) => members.contains(userId);
  int get memberCount => members.length;
}
