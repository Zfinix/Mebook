import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mebook/auth/baseAuth.dart';
import 'package:mebook/models/userModel.dart';
import 'package:mebook/views/homePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginController extends ChangeNotifier {
  final BaseAuth auth = new Auth();

  //LOGIN DETAILS
  String _email, _password;
  String get email => _email;
  String get password => _password;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  var _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set email(val) {
    _email = val;
    notifyListeners();
  }

  set password(val) {
    _password = val;
    notifyListeners();
  }

  googleSignIn(context) async {
    try {
      isLoading = true;
      var user = await auth.signInWithGoogle();
      saveData(user);

      UserModel userModel = await auth.getProfileData(user.uid);
      isLoading = false;

      Navigator.pushReplacement(context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
            userModel: userModel,
          ),
        ),
      );
    } catch (e) {
      isLoading = false;

      Fluttertoast.showToast(
          msg: "An Error Occurred",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.amber[800].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 14.0);
    }
    isLoading = false;
  }

  saveData(FirebaseUser user) async {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(Firestore.instance.collection("users").document(user.uid), {
          'name': user?.displayName ?? '',
          'email': user?.email ?? '',
          'userId': user?.uid ?? '',
          'imageUrl': user?.photoUrl ?? ''
        });
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An Error Occurred",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.amber[800].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 14.0);

      ///showError(context: context, text:e.message);
      print('Error: ${e.message}');
      isLoading = false;
    }
  }

  postData(context) async {
    if (_formKey.currentState.validate()) {
      isLoading = true;

      try {
        var userId = await auth.signIn(email, password);
        print('Signed in: $userId');

        if (userId.length > 0 && userId != null) {
          FirebaseUser user = await auth.getCurrentUser();
          UserModel userModel = await auth.getProfileData(user.uid);
          //Navigator.of(myGlobals.scaffoldKey.currentContext).pop();
          Navigator.pushReplacement(context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: user,
                userModel: userModel,
              ),
            ),
          );
        }

        isLoading = false;
      } catch (e) {
        print('Error: $e');

        isLoading = false;

        if (e.toString().contains("invalid")) {
          Fluttertoast.showToast(
              msg: "Invalid Password",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 2,
              backgroundColor: Colors.amber[800].withOpacity(0.9),
              textColor: Colors.white,
              fontSize: 14.0);
        } else if (e.toString().contains('ERROR_WRONG_PASSWORD')) {
          Fluttertoast.showToast(
              msg: "Invalid Password",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 2,
              backgroundColor: Colors.amber[800].withOpacity(0.9),
              textColor: Colors.white,
              fontSize: 14.0);
      
        } else if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
          Fluttertoast.showToast(
              msg: "There is no record for this user",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 2,
              backgroundColor: Colors.amber[800].withOpacity(0.9),
              textColor: Colors.white,
              fontSize: 14.0);
        } else {
          Fluttertoast.showToast(
              msg: "An Error Occurred",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 2,
              backgroundColor: Colors.amber[800].withOpacity(0.9),
              textColor: Colors.white,
              fontSize: 14.0);
        }
      }
    }
  }
}
