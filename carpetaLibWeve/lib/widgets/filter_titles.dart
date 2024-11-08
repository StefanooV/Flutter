import 'package:flutter/material.dart';

class FilterTitle extends StatelessWidget {
  final String text;

  const FilterTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
