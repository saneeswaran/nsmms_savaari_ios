import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomerGoogleLoginService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _initialized = false;

  static Future<void> _initialize() async {
    if (!_initialized) {
      await _googleSignIn.initialize(
          clientId:
              "121392168783-hcbk30hrg2mojr1hioh1vjd3o5kp9sq4.apps.googleusercontent.com");
      _initialized = true;
    }
  }

  static Future<bool> customerSignInWithGoogle(
      {required BuildContext context}) async {
    try {
      await _initialize();
      try {
        final silent = _googleSignIn.attemptLightweightAuthentication();
        if (silent is Future) await silent;
      } catch (_) {}
      if (!_googleSignIn.supportsAuthenticate()) {
        throw UnsupportedError('Platform does not support authenticate().');
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCred.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("customers")
            .doc(user.uid)
            .set({
          "uid": user.uid,
          "email": user.email ?? "",
          "name": user.displayName ?? "",
          "phone": "", // empty initially
          "gender": "", // empty initially
          "feedback": null, // can be filled later
          "status": "loggedIn", // current status
          "createdAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        log('User profile created in Firestore for ${user.email}');
      }
      log('Google Sign-In successful for ${user!.email}');
      return true;
    } on GoogleSignInException catch (e) {
      log('GoogleSignInException: code=${e.code.name}, desc=${e.description}');
      return false;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.message}');
      return false;
    } catch (e) {
      log('Unexpected error: $e');
      return false;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
