import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/guild.dart';
import '../models/post.dart';
import '../../firebase/firebase_bootstrap.dart';
import '../../core/constants.dart';

class GuildService {
  static GuildService? _instance;
  static GuildService get instance => _instance ??= GuildService._();
  GuildService._();

  final _uuid = const Uuid();

  FirebaseFirestore? get _firestore {
    return FirebaseBootstrap.isFirebaseReady ? FirebaseFirestore.instance : null;
  }

  Stream<Guild?> getGuild(String guildId) {
    if (_firestore == null) {
      return Stream.value(null);
    }

    return _firestore!
        .collection(AppConstants.guildsCollection)
        .doc(guildId)
        .snapshots()
        .map((doc) => doc.exists ? Guild.fromFirestore(doc) : null);
  }

  Stream<List<Guild>> getPublicGuilds({int limit = 20}) {
    if (_firestore == null) {
      return Stream.value([]);
    }

    return _firestore!
        .collection(AppConstants.guildsCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Guild.fromFirestore(doc))
            .toList());
  }

  Future<Guild> createGuild({
    required String name,
    required String description,
    required String creatorId,
  }) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    try {
      final guildId = _uuid.v4();
      final guild = Guild(
        id: guildId,
        name: name,
        description: description,
        level: 1,
        medalKey: 'assets/medals/guild/normal/guild medals/level 1.png',
        admins: [creatorId],
        members: [creatorId],
        notificationsEnabled: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guildId)
          .set(guild.toFirestore());

      return guild;
    } catch (e) {
      throw Exception('Failed to create guild: $e');
    }
  }

  Future<void> joinGuild(String guildId, String userId) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guildId)
          .update({
        'members': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to join guild: $e');
    }
  }

  Future<void> leaveGuild(String guildId, String userId) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guildId)
          .update({
        'members': FieldValue.arrayRemove([userId]),
        'admins': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to leave guild: $e');
    }
  }

  Future<void> updateGuild(Guild guild) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guild.id)
          .update(guild.copyWith(updatedAt: DateTime.now()).toFirestore());
    } catch (e) {
      throw Exception('Failed to update guild: $e');
    }
  }

  Future<void> addAdmin(String guildId, String userId) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guildId)
          .update({
        'admins': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add admin: $e');
    }
  }

  Future<void> removeAdmin(String guildId, String userId) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guildId)
          .update({
        'admins': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to remove admin: $e');
    }
  }

  Future<void> kickMember(String guildId, String userId) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guildId)
          .update({
        'members': FieldValue.arrayRemove([userId]),
        'admins': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to kick member: $e');
    }
  }

  Future<void> deleteGuild(String guildId) async {
    if (_firestore == null) return;

    try {
      // Delete guild posts first
      final postsQuery = await _firestore!
          .collection(AppConstants.postsCollection)
          .where('guildId', isEqualTo: guildId)
          .get();

      final batch = _firestore!.batch();
      for (final doc in postsQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete guild document
      batch.delete(_firestore!
          .collection(AppConstants.guildsCollection)
          .doc(guildId));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete guild: $e');
    }
  }

  Stream<List<Post>> getGuildFeed(String guildId, {int limit = 50}) {
    if (_firestore == null) {
      return Stream.value([]);
    }

    return _firestore!
        .collection(AppConstants.postsCollection)
        .where('guildId', isEqualTo: guildId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromFirestore(doc))
            .toList());
  }
}
