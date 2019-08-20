import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String userId;
  String imageUrl;
  final DocumentReference reference;

  UserModel(this.name, this.userId, this.imageUrl, this.reference);

  UserModel.fromMap(Map<String, dynamic> map, {this.reference})
      : userId = map['userId'],
        name = map['name'],
        email = map['email'],
        imageUrl = map['imageUrl'];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
