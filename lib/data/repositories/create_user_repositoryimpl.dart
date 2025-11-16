import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rollin_user/domain/entities/create_user.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepositoryImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserEntity> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    // Create user in Firebase Auth
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    // Save user data in Firestore
    await firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return UserEntity(uid: uid, name: name, email: email);
  }
}
