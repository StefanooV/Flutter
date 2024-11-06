import 'package:flutter/material.dart';
import 'review.dart';

class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Review("assets/images/persona.jpg", "Stefano Vaudagna",
            "1 review 5 photos", "This is an amazing place in bahamas"),
        Review("assets/images/persona1.jpg", "Lucas Lucero",
            "3 review 2 photos", "This is an amazing place in mexico"),
        Review("assets/images/persona.jpg", "Genaro Bossi", "2 review 6 photos",
            "This is an amazing place in Sri Lanka")
      ],
    );
  }
}
