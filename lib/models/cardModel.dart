import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  String date;
  String image;
  String title;
  String name;
  String userAvatar;
  String userId;

  final DocumentReference reference;

  CardModel(
    this.name,
    this.title,
    this.image,
    this.date,
    this.userAvatar,
    this.userId,
    this.reference,
  );

  CardModel.fromMap(Map<String, dynamic> map, {this.reference})
      : date = map['date'],
        name = map['name'],
        userId = map['userId'],
        image = map['image'],
        userAvatar = map['userAvatar'],
        title = map['postTitle'];

  CardModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
