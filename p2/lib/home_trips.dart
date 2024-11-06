import 'package:flutter/material.dart';
import 'header_appbar.dart';
import 'description_place.dart';
import 'review_list.dart';

class HomeTrips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            DescriptionPlace("Bahamas", 3.5,
                "Bahamas está compuesta por un grupo de 700 islas pequeñas y 2.400 cayos en una superficie de 13.878 kilómetros cuadrados, pero solo una treintena de estas están habitadas. Es el quinto país más grande del Caribe en área después de Cuba (110.860 km2), República Dominicana (48.670 km2), Haití (27.750) y Belicé (22.966). Bahamas está compuesta por un grupo de 700 islas pequeñas y 2.400 cayos en una superficie de 13.878 kilómetros cuadrados, pero solo una treintena de estas están habitadas. Es el quinto país más grande del Caribe en área después de Cuba (110.860 km2), República Dominicana (48.670 km2), Haití (27.750) y Belicé (22.966)."),
            ReviewList()
          ],
        ),
        HeaderAppBar()
      ],
    );
  }
}
