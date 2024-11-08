import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notificaciones",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              fontSize: 22),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 400,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://images.hgmsites.net/hug/porsche-electric-vehicle-charging-station_100786166_h.jpg"),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    "¿Cargaste en Estacion de Carga Falavella?",
                                    style: TextStyle(
                                        fontFamily: "Montserrat", fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Por favor confirmá tu carga!",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Flexible(
                                        child: Text(
                                          "Cargué mi vehiculo",
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Flexible(
                                        child: Text(
                                          "No cargué mi vehiculo",
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 12,
                                            color: Colors.red[600],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
