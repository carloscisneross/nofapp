import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../../firebase/firebase_bootstrap.dart';
import '../../core/constants.dart';

class ProfileRepository {
  static ProfileRepository? _instance;
  static ProfileRepository get instance => _instance ??= ProfileRepository._();
  ProfileRepository._();
  
  static const Duration _timeout = Duration(seconds: 10);

  FirebaseFirestore? get _firestore {
    return FirebaseBootstrap.isFirebaseReady ? FirebaseFirestore.instance : null;
  }

  FirebaseAuth? get _auth {
    return FirebaseBootstrap.isFirebaseReady ? FirebaseAuth.instance : null;
  }

  Stream<UserProfile?> getCurrentUserProfile() {
    if (_auth?.currentUser == null || _firestore == null) {
      return Stream.value(null);
    }

    return _firestore!
        .collection(AppConstants.usersCollection)
        .doc(_auth!.currentUser!.uid)
        .snapshots()
        .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    if (_firestore == null) return null;
    
    try {
      final doc = await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get()
          .timeout(_timeout);
      
      return doc.exists ? UserProfile.fromFirestore(doc) : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> createUserProfile(UserProfile profile) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(profile.uid)
          .set(profile.toFirestore())
          .timeout(_timeout);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(profile.uid)
          .update(profile.copyWith(updatedAt: DateTime.now()).toFirestore());
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<void> updateAvatar(String uid, String avatarKey) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({
        'avatarKey': avatarKey,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update avatar: $e');
    }
  }

  Future<void> updateDisplayName(String uid, String displayName) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({
        'displayName': displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update display name: $e');
    }
  }

  Future<void> updatePremiumStatus(String uid, bool isPremium) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({
        'isPremium': isPremium,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update premium status: $e');
    }
  }

  Future<void> updateStreak(String uid, StreakData streak) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({
        'streak': streak.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update streak: $e');
    }
  }

  Future<void> addMedal(String uid, String medalId) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({
        'personalMedals': FieldValue.arrayUnion([medalId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add medal: $e');
    }
  }

  Future<void> deleteUserProfile(String uid) async {
    if (_firestore == null) return;
    
    try {
      await _firestore!
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }
}
