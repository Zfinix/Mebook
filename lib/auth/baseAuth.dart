import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mebook/models/userModel.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<FirebaseUser> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut(context);
  Future<void> resetPassword(email, context);
  Future<FirebaseUser> signInWithGoogle();
  Future<GoogleSignInAccount> getSignedInAccount();
  Future<UserModel> getProfileData(String userID);
}

class Auth implements BaseAuth {
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signInWithGoogle() async {
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();

      FirebaseUser user = await signIntoFirebase(googleAccount);

      return user;
    }
    return null;
  }

  Future<GoogleSignInAccount> getSignedInAccount() async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  Future<FirebaseUser> signIntoFirebase(
      GoogleSignInAccount googleAccount) async {
    final GoogleSignInAuthentication googleAuth =
        await googleAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final FirebaseUser user =
        await _firebaseAuth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut(context) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Password Reset"),
              content: new Text("Password Reset Email Sent"),
            ));
    return _firebaseAuth.signOut();
  }

  Future<void> resetPassword(email, context) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Password Reset"),
              content: new Text("Password Reset Email Sent"),
            ));

    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserModel> getProfileData(userID) async {
    var querySnapshot =
        await Firestore.instance.collection("users").document(userID).get();

    return (querySnapshot != null)
        ? UserModel.fromSnapshot(querySnapshot)
        : null;
  }
}
