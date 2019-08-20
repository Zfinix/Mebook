import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  DocumentSnapshot querySnapshot;
  Stream<QuerySnapshot> posts =
      Firestore.instance.collection('posts').snapshots();
}
