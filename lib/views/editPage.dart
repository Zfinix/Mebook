import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mebook/models/cardModel.dart';
import 'package:mebook/providers/uploadController.dart';
import 'package:mebook/utils/margin.dart';
import 'package:mebook/widgets/textFields.dart';
import 'package:provider/provider.dart';

class EditPage extends StatelessWidget {
  final CardModel cardModel;
  const EditPage({Key key, this.cardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<UploadController>(context);
    return Scaffold(
      backgroundColor: Color(0xFF1E222F),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E222F),
        title: Text('Edit Post'),
      ),
      body: Form(
        key: controller.editFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const YMargin(30),
            Center(child: UploadTitle(controller, text: cardModel.title)),
            const YMargin(90),
            UploadButton(
              controller,
              cardModel: cardModel,
            )
          ],
        ),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final UploadController controller;
  final CardModel cardModel;

  const UploadButton(
    this.controller, {
    Key key,
    this.cardModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CupertinoButton(
        color: Theme.of(context).primaryColor,
        onPressed:() => controller.editData(cardModel),
        pressedOpacity: 0.7,
        borderRadius: BorderRadius.circular(20),
        child: Text(
          "Update Title",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
