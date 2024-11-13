import 'package:flutter/material.dart';

class PagoScreen extends StatelessWidget {
  static const String routename = 'PagoScreen';
  const PagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hola pago!'),
      ),
    );
  }
}
