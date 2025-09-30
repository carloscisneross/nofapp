import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatarKey;
  final String text;
  final Map<String, int> reactions; // emoji -> count
  final int commentsCount;
  final String? guildId; // null for global posts
  final DateTime createdAt;
  final DateTime updatedAt;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarKey,
    required this.text,
    required this.reactions,
    required this.commentsCount,
    this.guildId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatarKey: data['authorAvatarKey'] ?? '',
      text: data['text'] ?? '',
      reactions: Map<String, int>.from(data['reactions'] ?? {}),
      commentsCount: data['commentsCount'] ?? 0,
      guildId: data['guildId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarKey': authorAvatarKey,
      'text': text,
      'reactions': reactions,
      'commentsCount': commentsCount,
      'guildId': guildId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Post copyWith({
    String? authorName,
    String? authorAvatarKey,
    String? text,
    Map<String, int>? reactions,
    int? commentsCount,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id,
      authorId: authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarKey: authorAvatarKey ?? this.authorAvatarKey,
      text: text ?? this.text,
      reactions: reactions ?? this.reactions,
      commentsCount: commentsCount ?? this.commentsCount,
      guildId: guildId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get isGuildPost => guildId != null;
  bool get isGlobalPost => guildId == null;
  int get totalReactions => reactions.values.fold(0, (sum, count) => sum + count);
}
