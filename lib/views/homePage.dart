import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mebook/models/cardModel.dart';
import 'package:mebook/models/userModel.dart';
import 'package:mebook/providers/homeController.dart';
import 'package:mebook/widgets/feedCard.dart';
import 'package:provider/provider.dart';

import 'uploadPage.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  final UserModel userModel;
  HomePage({Key key, @required this.user, @required this.userModel})
      : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, counter, _) {
      var controller = Provider.of<HomeController>(context);
      return Scaffold(
        backgroundColor: Color(0xFF1E222F),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF1E222F),
          title: Image.asset(
            'assets/logo.png',
            scale: 4,
          ),
        ),
        body: BuildUI(widget.user.uid, controller: controller),
        floatingActionButton: FloatingActionButton(
          elevation: 20,
          onPressed: fabClick,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      );
    });
  }

  void fabClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadPage(
          user: widget.user,
          userModel: widget.userModel,
        ),
      ),
    );
  }
}

class BuildUI extends StatelessWidget {
  final HomeController controller;
  final userID;
  const BuildUI(this.userID, {Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.posts,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: BuildFeedList(snapshot.data.documents, userID),
        );
      },
    );
  }
}

class BuildFeedList extends StatelessWidget {
  final List<DocumentSnapshot> snapshot;
  final userID;
  const BuildFeedList(this.snapshot, this.userID);

  @override
  Widget build(BuildContext context) => ListView(
    reverse: true,
        children: snapshot.map((data) => FeedListItem(data, userID)).toList(),
      );
}

class FeedListItem extends StatelessWidget {
  const FeedListItem(this.data, this.userID);
  final DocumentSnapshot data;
  final userID;

  @override
  Widget build(BuildContext context) {
    final classData = CardModel.fromSnapshot(data);

    return FeedCard(
      userID: userID,
      cardModel: classData,
      cxt: context,
    );
  }
}
