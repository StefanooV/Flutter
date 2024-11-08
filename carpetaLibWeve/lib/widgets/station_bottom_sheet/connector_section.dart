import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/helper/ocpp_helper.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/shimmer_container.dart';

class ConnectorSection extends StatefulWidget {
  final List<StationConnector> connectors;

  final ChargingStation station;
  const ConnectorSection({
    Key? key,
    required this.connectors,
    required this.station,
  }) : super(key: key);

  @override
  State<ConnectorSection> createState() => _ConnectorSectionState();
}

class _ConnectorSectionState extends State<ConnectorSection> {
  late OCPPHelper _ocppHelper;
  final String driverUid = FirebaseAuth.instance.currentUser!.uid;
  StationConnector? selectedConnector;

  @override
  void initState() {
    super.initState();
    _ocppHelper = OCPPHelper(); // Accedemos al singleton
    _ocppHelper.subscribe(_onMessageReceived); // Nos suscribimos a los mensajes

    var message = [
      "WatchStation",
      {"driverUid": driverUid, "stationId": widget.station.id, "watching": true}
    ];
    _ocppHelper.sendMessage(message);
  }

  @override
  void dispose() {
    // Desuscribirse cuando salimos de la pantalla
    var message = [
      "WatchStation",
      {"driverUid": driverUid, "stationId": widget.station.id, "watching": true}
    ];
    _ocppHelper.sendMessage(message);
    _ocppHelper.unsubscribe(_onMessageReceived);
    super.dispose();
  }

  // Método que se llama cuando se recibe un mensaje
  void _onMessageReceived(dynamic message) {
    print("Mensaje recibido: $message");

    // Verificar si el mensaje es una lista
    if (message is List) {
      // Acceder a los componentes del mensaje
      String action = message[0]; // Tipo de mensaje
      Map<String, dynamic> details = message[1]; // Detalles del mensaje

      // Verificar el contenido del mensaje según el tipo de acción
      if (action == "WatchingStation") {
        print("Llegó el watchingStation: $message");
        String status = details['status']; // Acceder al estado
        if (status == "suscribed") {
          // Acceder a los datos de los conectores
          List<dynamic> connectorsData = details['connectorsData'];
          for (var connector in connectorsData) {
            String chargerSerialNumber = connector['chargerSerialNumber'];
            int connectorId = connector['connectorId'];
            String connectorStatus = connector['status'];
            bool availability = connectorStatus == "Available";

            // Aquí puedes manejar la lógica que necesites para cada conector
            // Por ejemplo, podrías actualizar el estado del conector en tu UI
            updateConnectorAvailability(
                connectorId, chargerSerialNumber, availability);
          }
        }
      } else if (action == "StatusChanged") {
        print("Llegó un Status Changed: $message");
        int connectorId = details['connectorId'];
        String chargerSerialNumber = details['chargerSerialNumber'];
        String status = details['status'];

        bool newAvailability = status == "Available";
        updateConnectorAvailability(
            connectorId, chargerSerialNumber, newAvailability);
      }
    } else {
      print("Formato de mensaje inesperado: $message");
    }
  }

  void onConnectorTap(
      Connector connector, StationConnector stationConnector, bool status) {
    setState(() {
      for (StationConnector stationConnector in widget.connectors) {
        for (Connector connector in stationConnector.connectors) {
          connector.selected = false;
        }
      }
    });
    selectedConnector = stationConnector;
    connector.selected = status;
  }

  void toggleExpansion(String id) {
    setState(() {
      for (var connector in widget.connectors) {
        if (connector.id == id) {
          connector.expanded = !connector.expanded;
        }
      }
    });
  }

  void updateConnectorAvailability(
      int identifiedName, String chargerSerialNumber, bool newAvailability) {
    setState(() {
      for (StationConnector stationConnector in widget.connectors) {
        for (Connector connector in stationConnector.connectors) {
          if (connector.identifiedName == identifiedName &&
              connector.chargerSerialNumber == chargerSerialNumber) {
            setState(() {
              connector.available = newAvailability;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
          children: widget.connectors.map((stationConnector) {
            return Column(
              children: [
                Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExpansionTile(
                    textColor: Colors.black,
                    onExpansionChanged: (expansionState) {
                      toggleExpansion(stationConnector.id);
                    },
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: AppTheme.weveSkyBlue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    leading: SizedBox(
                      width: 70,
                      height: 70,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://weveimages.blob.core.windows.net/weve-images/ChargerConnectorType/${stationConnector.id}.png",
                        progressIndicatorBuilder: (context, url, progress) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: ShimmerContainer(
                              height: 70,
                              width: 70,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stationConnector.description,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        overflow: TextOverflow.visible),
                                  ),
                                  Text(
                                    "${stationConnector.power.toString()}kW",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "x${stationConnector.total}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (stationConnector.expanded)
                  Column(
                    children:
                        stationConnector.connectors.map((Connector connector) {
                      return InkWell(
                        onTap: () => onConnectorTap(
                            connector, stationConnector, !connector.selected),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: connector.selected
                              ? AppTheme.weveSkyBlue
                              : Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: "ID: "),
                                      TextSpan(
                                        text:
                                            connector.identifiedName.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Tarifa: Proximamente!"),
                                    AvailabilityIndicator(
                                      selected: connector.selected,
                                      availability: connector.available,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: connector.selected
                                        ? Colors.white
                                        : AppTheme.weveSkyBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            );
          }).toList(),
        ),
        if (widget.connectors.any((stationConnector) =>
            stationConnector.connectors.any((connector) => connector.selected)))
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      "Continuar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onPressed: () => context.push("/qr", extra: {
                    "station": widget.station,
                    "selectedConnector": selectedConnector,
                  }),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AvailabilityIndicator extends StatelessWidget {
  final bool selected;
  final bool? availability;
  const AvailabilityIndicator({
    super.key,
    required this.selected,
    this.availability,
  });

  @override
  Widget build(BuildContext context) {
    if (availability == null) {
      return Text(
        "Desconocido",
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey[600],
        ),
      );
    } else if (availability == true) {
      return Text(
        "Disponible",
        style: TextStyle(
          color: selected ? Colors.white : AppTheme.availableGreen,
        ),
      );
    } else {
      return Text(
        "Ocupado",
        style: TextStyle(
          color: selected ? Colors.white : Colors.red[600],
        ),
      );
    }
  }
}
