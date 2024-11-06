import 'package:flutter/material.dart';
import 'button.dart';

class DescriptionPlace extends StatelessWidget {
  final String namePlace;
  final double stars;
  final String descriptionPlace;

  DescriptionPlace(this.namePlace, this.stars, this.descriptionPlace,
      {super.key});

  List<Widget> buildStars(double stars) {
    List<Widget> starWidgets = [];
    for (int i = 0; i < 5; i++) {
      if (i < stars.floor()) {
        starWidgets.add(const Icon(Icons.star, color: Colors.amber));
      } else if (i < stars && stars - i > 0) {
        starWidgets.add(const Icon(Icons.star_half, color: Colors.amber));
      } else {
        starWidgets.add(const Icon(Icons.star_border, color: Colors.amber));
      }
      starWidgets.add(const SizedBox(width: 3.0));
    }
    return starWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final titleStars = Container(
      margin: const EdgeInsets.only(top: 340.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              namePlace,
              style: const TextStyle(
                fontFamily: "Lato",
                fontSize: 30.0,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Row(children: buildStars(stars))
        ],
      ),
    );

    final description = Container(
      margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Text(
        descriptionPlace,
        style: const TextStyle(
            fontFamily: "Lato",
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF56575a)),
        textAlign: TextAlign.justify,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[titleStars, description, Button("Navigate")],
    );
  }
}
