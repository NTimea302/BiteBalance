//import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetLink(String email) async {
    try {
        await _auth.sendPasswordResetEmail(email: email);
        print("Password reset link sent to ${email}");
    } catch (e) {
      print("Something went wrong");
    }
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        print("Email verification link sent to ${user.email}");
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Something went wrong");
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      print("Login with Google");
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      print("User: ${googleUser?.displayName}");
      return await _auth.signInWithCredential(credential);
     
    } catch (e) {
      print("Something went wrong");
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      print("Something went wrong");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      print("Something went wrong");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Something went wrong");
    }
  }
}
