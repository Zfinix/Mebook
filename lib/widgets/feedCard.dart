import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mebook/models/cardModel.dart';
import 'package:mebook/utils/margin.dart';
import 'package:mebook/views/editPage.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedCard extends StatelessWidget {
  final CardModel cardModel;
  final BuildContext cxt;
  final userID;
  const FeedCard(
      {Key key, this.cardModel, @required this.userID, @required this.cxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.blue[800],
              image: DecorationImage(
                  image: MemoryImage(base64.decode(cardModel.image) ?? ''),
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
          ),
        ),
        const YMargin(20),
        Row(
          children: <Widget>[
            const XMargin(20),
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Container(
                width: 40,
                color: Colors.white,
                height: 40,
              ),
            ),
            const XMargin(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cardModel.title ?? '',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const YMargin(5),
                Row(
                  children: <Widget>[
                    Text(
                      'by ',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      '${cardModel.name.contains(' ') ? cardModel.name.split(' ')[0] : cardModel.name} ',
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${timeago.format(DateTime.parse(cardModel.date))}',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
            const XMargin(26),
            userID == cardModel.userId
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: IconButton(
                      color: Colors.white24,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 19,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              cardModel: cardModel,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Divider(),
        )
      ],
    );
  }
}
