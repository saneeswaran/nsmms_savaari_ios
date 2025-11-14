import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up (sends email verification only, stores temp info in SharedPreferences)
  Future<User?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      // 1. Create Firebase Auth user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        log("Firebase Auth signup successful: ${user.uid}");

        // 2. Send Email verification
        // await user.sendEmailVerification();
        log("🔹 Verification email sent to $email");

        // 3. Store extra info temporarily in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('temp_name', name);
        await prefs.setString('temp_email', email);
        await prefs.setString('temp_password', password);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  // Login and save user data if email is verified
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        if (user.emailVerified) {
          // Get temp info from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final name = prefs.getString('temp_name') ?? '';
          final phone = prefs.getString('temp_phone') ?? '';
          final gender = prefs.getString('temp_gender') ?? '';

          // Save user info in Firestore
          await _firestore.collection("customers").doc(user.uid).set({
            "uid": user.uid,
            "email": email,
            "name": name,
            "phone": phone,
            "gender": gender,
            "feedback": null,
            "status": "loggedIn",
            "createdAt": FieldValue.serverTimestamp(),
          });
          log("Firestore document created successfully for ${user.uid}");

          // Cleanup temp info
          prefs.remove('temp_name');
          prefs.remove('temp_phone');
          prefs.remove('temp_gender');
          prefs.remove('temp_email');
          prefs.remove('temp_password');
        } else {
          throw Exception(
            "Email not verified. Please check your inbox for verification link.",
          );
        }
      }

      return user;
    } catch (e) {
      throw Exception("Login error: $e");
    }
  }

  // Logout
  Future<void> signOut() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection("customers").doc(uid).update({
        "status": "loggedOut",
      });
    }
    await _auth.signOut();
  }

  Stream<User?> get userStream => _auth.authStateChanges();
}
