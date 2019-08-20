import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mebook/auth/baseAuth.dart';
import 'package:mebook/models/userModel.dart';
import 'package:mebook/views/homePage.dart';

class SignupController extends ChangeNotifier {
  final BaseAuth auth = new Auth();

  //SIGNUP DETAILS
  String _email, _password, _name;
  String get email => _email;
  String get name => _name;
  String get password => _password;

  FirebaseUser _user;
  FirebaseUser get user => _user;

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

  set name(val) {
    _name = val;
    notifyListeners();
  }

  set password(val) {
    _password = val;
    notifyListeners();
  }

  set user(val) {
    _user = val;
    notifyListeners();
  }

  postData(context) async {
    if (_formKey.currentState.validate()) {
      isLoading = true;

      try {
        user = await auth.signUp(email, password);

        if (user.uid != null) {
          saveData(user);
          print('Signed in: ${user?.uid}');
          UserModel userModel = await auth.getProfileData(user?.uid);
          Navigator.of(context).pop();
          Navigator.pushReplacement(context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: user,
                userModel: userModel,
              ),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');

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
    }
  }

  saveData(user) async {
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = name;
      user.updateProfile(updateInfo);
      print('llllll');

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
            Firestore.instance.collection("users").document(user.uid), {
          'name': name,
          'email': email,
          'userId': user?.uid ?? '',
          'imageUrl': ""
        });
      });

      isLoading = false;
    } catch (e) {
      print(e.toString());
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
}
