import 'package:flutter/material.dart';

class ItemScreen extends StatelessWidget {
  static const String routename = 'ItemScreen';
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 175, 156),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Remera Oversize',
                  style: TextStyle(fontSize: 40, color: Colors.white)),
              SizedBox(
                child: Image.asset('assets/remera.jpg'),
              ),
              ElevatedButton(
                  onPressed: () async {},
                  child: const Text('Pagar con MPerri')),
            ],
          ),
        ),
      ),
    );
  }
}
