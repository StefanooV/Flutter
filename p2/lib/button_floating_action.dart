import 'package:flutter/material.dart';

class ButtonFloatingAction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ButtonFloatingAction();
  }
}

class _ButtonFloatingAction extends State<ButtonFloatingAction> {
  void onPressedFav() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Agregaste a tus Favoritos"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF11DA53),
      mini: true,
      tooltip: "Fav",
      onPressed: onPressedFav,
      child: const Icon(Icons.favorite_border),
    );
  }
}
