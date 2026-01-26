import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final doc = await _firestore
        .collection('rollin_user_profile')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      throw Exception('Profile not found');
    }

    return doc.data()!;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('rollin_user_profile')
        .doc(user.uid)
        .update(data);
  }
}
