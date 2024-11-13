import 'package:flutter/material.dart';
import 'package:mp_apllication/screen/aprobado_screen.dart';
import 'package:mp_apllication/screen/item_screen.dart';
import 'package:mp_apllication/screen/pago_screen.dart';
import 'package:mp_apllication/screen/pendiente_screen.dart';
import 'package:mp_apllication/screen/rechazado_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 190, 175, 156)),
        useMaterial3: true,
      ),
      initialRoute: ItemScreen.routename,
      routes: {
        ItemScreen.routename: (context) => const ItemScreen(),
        PagoScreen.routename: (context) => const PagoScreen(),
        AprobadoScreen.routename: (context) => const AprobadoScreen(),
        RechazadoScreen.routename: (context) => const RechazadoScreen(),
        PendienteScreen.routename: (context) => const PendienteScreen(),
      },
    );
  }
}
