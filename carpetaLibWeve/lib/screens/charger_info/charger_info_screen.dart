import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weveapp/theme/app_theme.dart';

class ChargerInfoScreen extends StatefulWidget {
  const ChargerInfoScreen({Key? key}) : super(key: key);

  @override
  State<ChargerInfoScreen> createState() => _ChargerInfoScreenState();
}

class _ChargerInfoScreenState extends State<ChargerInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Información de cargadores",
              style: TextStyle(fontFamily: "Montserrat")),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.bolt),
                      iconColor: AppTheme.weveSkyBlue,
                      title: Text("Cargador 1 Carrefour"),
                      subtitle: Text(
                          "125Kw • Gratuito • Epec • Estacionamiento • 2do Piso • Disponible ahora"),
                      isThreeLine: true,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.bolt),
                      iconColor: AppTheme.weveSkyBlue,
                      title: Text("Cargador 2 Carrefour"),
                      subtitle: Text(
                          "125Kw • Gratuito • Epec • Estacionamiento • 2do Piso • Disponible ahora"),
                      isThreeLine: true,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.bolt),
                      iconColor: AppTheme.weveSkyBlue,
                      title: Text("Cargador Falavella"),
                      subtitle: Text(
                          "250Kw • Gratuito • Epec • Estacionamiento descubierto • Planta baja • Disponible ahora"),
                      isThreeLine: true,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.bolt),
                      iconColor: AppTheme.weveSkyBlue,
                      title: Text("Cargador Interior Falavella"),
                      subtitle: Text(
                          "7Kw • 225 pesos/kw • Epef • Afueras • 3er Piso • Disponible en 45 minutos"),
                      isThreeLine: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
