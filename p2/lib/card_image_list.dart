import 'package:flutter/material.dart';
import 'card_image.dart';

class CardImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      child: ListView(
        padding: EdgeInsets.all(25.0),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CardImage("assets/images/bck2.jpg"),
          CardImage("assets/images/bck4.jpg"),
          CardImage("assets/images/bck1.jpg"),
          CardImage("assets/images/bck3.jpg"),
        ],
      ),
    );
  }
}
