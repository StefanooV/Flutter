import 'package:flutter/material.dart';

class NoConnectorsContainer extends StatelessWidget {
  const NoConnectorsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.grey[200],
      ),
      child: const Center(
        child: Text(
          "Sin información de cargadores",
          style: TextStyle(
            fontFamily: "Montserrat",
          ),
        ),
      ),
    );
  }
}
