import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mebook/models/userModel.dart';
import 'package:mebook/providers/uploadController.dart';
import 'package:mebook/utils/margin.dart';
import 'package:mebook/widgets/textFields.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatelessWidget {
  final UserModel userModel;
  final FirebaseUser user;
  const UploadPage({Key key, @required this.userModel, @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadController>(
      builder: (context, counter, _) {
        var controller = Provider.of<UploadController>(context);
        return Scaffold(
          backgroundColor: Color(0xFF1E222F),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xFF1E222F),
            title: Text('Upload'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                      height: 250,
                      child: controller.image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                UploadImageButton(controller),
                              ],
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[900],
                                image: DecorationImage(
                                    image: FileImage(controller.image),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  new BoxShadow(
                                    offset: Offset(0, 20),
                                    spreadRadius: -13,
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                            )),
                ),
                const YMargin(30),
                controller.image != null
                    ? Form(
                      key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[UploadTitle(controller)],
                        ),
                      )
                    : Container(),
                const YMargin(30),
                !controller.isLoading
                    ? UploadButton(controller, user: user, userModel: userModel)
                    : Container(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}

class UploadImageButton extends StatelessWidget {
  final UploadController controller;

  const UploadImageButton(
    this.controller, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(20),
      height: 100,
      width: 100,
      child: FloatingActionButton(
        onPressed: () => controller.getImage(),
        child: Icon(
          Icons.add_a_photo,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final UploadController controller;
  final UserModel userModel;
  final FirebaseUser user;

  const UploadButton(
    this.controller, {
    @required this.userModel,
    @required this.user,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CupertinoButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          if (user != null && userModel != null) {
             controller.postData(user, userModel);
          } else {}
        },
        pressedOpacity: 0.7,
        borderRadius: BorderRadius.circular(20),
        child: Text(
          "Upload Image",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}

