import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mebook/models/cardModel.dart';
import 'package:mebook/models/userModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UploadController extends ChangeNotifier {
  FirebaseStorage _storage = FirebaseStorage.instance;

  File _image;
  File get image => _image;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _title;
  String get title => _title;

  var _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  var _editFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get editFormKey => _editFormKey;

  set image(val) {
    _image = val;

    notifyListeners();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set title(val) {
    _title = val;
    notifyListeners();
  }

  Future<List<int>> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1227,
      minHeight: 800,
      quality: 94,
    );
    // print(file.lengthSync());
    // print(result.length);
    return result;
  }

  postData(FirebaseUser user, UserModel userModel) async {
    //Encode to Base64
    if (image != null) {
      if (_formKey.currentState.validate()) {
        isLoading = true;
        List<int> imageBytes = (await testCompressFile(image));
        String base64Image = base64Encode(imageBytes);
        //print(base64Image);
        await saveData(user, userModel, base64Image);
      }
    }
  }

//Code for Uploading to storage instad of firestore
  /*  Future<String> uploadImage(img) async {
    StorageReference ref =
        _storage.ref().child("${DateTime.now().millisecondsSinceEpoch}.jpg");
    StorageUploadTask uploadTask = ref.putFile(img);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();

    return dowurl.toString();
  }
 */

  Future getImage() async {
    try {
      var img = await ImagePicker.pickImage(source: ImageSource.gallery);
      _image = img;
    } catch (e) {
      print(e.toString());
    }
  }

  saveData(
    FirebaseUser user,
    UserModel userModel,
    String base64Image,
  ) async {
    var titleM = _title;
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(Firestore.instance.collection("posts").document(), {
          'name': userModel.name,
          'postTitle': titleM,
          'userId': user.uid,
          'date': DateTime.now().toIso8601String(),
          'userAvatar': userModel?.imageUrl ?? '',
          'image': base64Image.toString()
        });
      }).then((onValue) {
        isLoading = false;

        Fluttertoast.showToast(
            msg: "Post Uploaded Succesfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.amber[800].withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 14.0);
      }).catchError((onError) {
        print(onError.toString());
        isLoading = false;
      });

      image = null;
      title = null;
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

  editData(
    CardModel cardModel,
  ) async {
    if (_editFormKey.currentState.validate()) {
      var titleM = _title;
      try {
        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
              Firestore.instance
                  .collection("posts")
                  .document(cardModel.reference.documentID.toString()),
              {
                'postTitle': titleM,
              });
        }).then((onValue) {
          isLoading = false;

          Fluttertoast.showToast(
              msg: "Post Updated Succesfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 2,
              backgroundColor: Colors.amber[800].withOpacity(0.9),
              textColor: Colors.white,
              fontSize: 14.0);
        }).catchError((onError) {
          print(onError.toString());
          isLoading = false;
        });

        image = null;
        title = null;
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
}
