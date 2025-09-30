import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../../firebase/firebase_bootstrap.dart';
import '../../core/constants.dart';

class PostService {
  static PostService? _instance;
  static PostService get instance => _instance ??= PostService._();
  PostService._();

  final _uuid = const Uuid();

  FirebaseFirestore? get _firestore {
    return FirebaseBootstrap.isFirebaseReady ? FirebaseFirestore.instance : null;
  }

  Stream<List<Post>> getGlobalFeed({int limit = 50}) {
    if (_firestore == null) {
      return Stream.value([]);
    }

    return _firestore!
        .collection(AppConstants.postsCollection)
        .where('guildId', isNull: true) // Global posts only
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromFirestore(doc))
            .toList());
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

  Future<Post> createPost({
    required String authorId,
    required String authorName,
    required String authorAvatarKey,
    required String text,
    String? guildId,
  }) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    if (text.trim().isEmpty) {
      throw Exception('Post text cannot be empty');
    }

    if (text.length > AppConstants.maxPostLength) {
      throw Exception('Post text too long (max ${AppConstants.maxPostLength} characters)');
    }

    try {
      final postId = _uuid.v4();
      final post = Post(
        id: postId,
        authorId: authorId,
        authorName: authorName,
        authorAvatarKey: authorAvatarKey,
        text: text.trim(),
        reactions: {},
        commentsCount: 0,
        guildId: guildId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore!
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .set(post.toFirestore());

      return post;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<void> updatePost(Post post) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.postsCollection)
          .doc(post.id)
          .update(post.copyWith(updatedAt: DateTime.now()).toFirestore());
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<void> addReaction(String postId, String emoji) async {
    if (_firestore == null) return;

    try {
      await _firestore!
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update({
        'reactions.$emoji': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add reaction: $e');
    }
  }

  Future<void> removeReaction(String postId, String emoji) async {
    if (_firestore == null) return;

    try {
      final doc = await _firestore!
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final reactions = Map<String, int>.from(data['reactions'] ?? {});
        
        if (reactions.containsKey(emoji) && reactions[emoji]! > 0) {
          if (reactions[emoji]! == 1) {
            reactions.remove(emoji);
          } else {
            reactions[emoji] = reactions[emoji]! - 1;
          }
          
          await doc.reference.update({
            'reactions': reactions,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      throw Exception('Failed to remove reaction: $e');
    }
  }
}
