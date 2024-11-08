import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weveapp/helper/ocpp_helper.dart';
import 'package:weveapp/models/chaging_station_model.dart';
import 'package:weveapp/theme/app_theme.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({
    super.key,
    required this.station,
    required this.selectedConnector,
    required this.chargerSerialNumber,
  });

  final ChargingStation station;
  final String chargerSerialNumber;
  final StationConnector selectedConnector;
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late OCPPHelper _ocppHelper;
  final String driverUid = FirebaseAuth.instance.currentUser!.uid;
  Color backgroundColor = AppTheme.weveSkyBlue;
  String title = "Enviando solicitud al cargador...";
  String subtitle = "Por favor espera";
  bool error = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeConnectionAndSendMessage();
    });
  }

  @override
  void dispose() {
    // Desuscribirse cuando salimos de la pantalla
    _ocppHelper.unsubscribe(_onMessageReceived);
    super.dispose();
  }

// Método para inicializar la conexión y enviar los mensajes
  void _initializeConnectionAndSendMessage() {
    _ocppHelper = OCPPHelper(); // Accedemos al singleton
    _ocppHelper.subscribe(_onMessageReceived); // Nos suscribimos a los mensajes

    var message = [
      "RemoteStartTransaction",
      {
        "connectorId": widget.selectedConnector.ocppConnectorId,
        "driverUid": driverUid,
        "stationId": widget.station.id,
        "serialNumber": widget.chargerSerialNumber,
      },
    ];

    _ocppHelper.sendMessage(message);
  }

// Método que se llama cuando se recibe un mensaje
  void _onMessageReceived(dynamic message) {
    print("Mensaje recibido: $message");

    // Verificar si el mensaje es una lista
    if (message is List) {
      // Acceder a los componentes del mensaje
      String action = message[0];
      Map<String, dynamic> details = message[1];

      // Verificar el contenido del mensaje según el tipo de acción
      if (action == "RemoteStartTransaction") {
        final String status = details["status"];

        if (status == "accepted") {
          setState(() {
            title = "Carga aceptada!";
            subtitle =
                "Por favor, esperá mientras el cargador autoriza la carga...";
            backgroundColor = AppTheme.availableGreen;
          });
        } else if (status == "rejected") {
          String castellano = "";
          final String reason = details['reason'];
          setState(() {
            if (reason == "Charger unreachable.") {
              castellano = "No se puede conectar con el cargador";
            }
            if (reason == "Driver not allowed") {
              castellano = "Parece que no estás autorizado!";
            }

            title = "Error solicitando carga remota";
            subtitle = castellano;
            error = true;
            backgroundColor = Colors.red.shade600;
          });
        }
      } else if (action == "NewTransaction") {
        final int transactionId = details['transactionId'];
        final String chargerSerialNumber = details['chargerSerialNumber'];
        final String chargerOwner = details['chargerOwner'];

        // Aquí puedes manejar el mensaje de "NewTransaction".
        print("Transacción nueva ID: $transactionId");
        print("Número de serie del cargador: $chargerSerialNumber");
        print("Propietario del cargador: $chargerOwner");

        // Puedes actualizar el estado o mostrar algo al usuario si es necesario.
        setState(() {
          title = "Nueva transacción!";
          subtitle = "Transacción ID: $transactionId";
          // backgroundColor = AppTheme.transactionBlue;
        });
      }
      if (action == "AcumulatedConsumptionInfo") {
        final num consumption = details['consumption'];
        setState(() {
          subtitle = "Consumo total actual: $consumption Wh";
        });
      }
    } else {
      print("Formato de mensaje inesperado: $message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        curve: Curves.easeInCirc,
        duration: const Duration(milliseconds: 200),
        color: backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 200,
                ), // Duración de la animación de texto
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation, // Animación de desvanecimiento
                    child: child,
                  );
                },
                child: Text(
                  title, // Texto que cambia suavemente
                  key: ValueKey<String>(
                      title), // Cambia el key cuando cambie el texto
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (!error)
                const SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              if (error)
                const Icon(
                  Icons.error,
                  size: 48,
                  color: Colors.white,
                ),
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 200,
                ), // Duración de la animación de texto
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation, // Animación de desvanecimiento
                    child: child,
                  );
                },
                child: Text(
                  subtitle, // Texto que cambia suavemente
                  key: ValueKey<String>(subtitle),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
