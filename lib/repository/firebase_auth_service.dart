import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In with Email and Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign Up with Email and Password, and store the username and role in Firestore
  Future<User?> signUpWithEmailAndPassword(
      String username, String email, String password, String role) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Update the user's display name with the username
        await user.updateDisplayName(username);

        // Save the username and role in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'role': role,
        });
      }

      return user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Get User Role by UID
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();
      return documentSnapshot['role'] as String?;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
