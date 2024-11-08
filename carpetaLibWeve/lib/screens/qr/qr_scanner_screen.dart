import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:weveapp/models/chaging_station_model.dart';
import 'package:weveapp/theme/app_theme.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({
    super.key,
    required this.station,
    required this.selectedConnector,
  });

  final ChargingStation station;
  final StationConnector selectedConnector;

  @override
  Widget build(BuildContext context) {
    final qrKey = GlobalKey(debugLabel: 'QR');
    String qrText = "";

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Chip(
              backgroundColor: AppTheme.weveSkyBlue,
              label: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  "Escanea el QR del cargador",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: QRView(
                cameraFacing: CameraFacing.back,
                key: qrKey,
                onQRViewCreated: (QRViewController controller) {
                  controller.scannedDataStream.listen((scanData) {
                    print("scanData $scanData");
                    qrText = scanData.code ?? '';
                    if (scanData.code != null) {
                      controller.dispose();
                      context.pushReplacement("/transaction", extra: {
                        "chargerSerialNumber": qrText.toString(),
                        "station": station,
                        "selectedConnector": selectedConnector,
                      });
                    }
                  });
                },
                overlay: QrScannerOverlayShape(
                  overlayColor: const Color.fromRGBO(0, 0, 0, .7),
                  borderColor: Colors.blue,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 7,
                  cutOutSize: 300,
                ),
              ),
            ),
            Container(
              color: AppTheme.weveSkyBlue,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Column(
                  children: [
                    const Text(
                      "O bien, ingresa el código manualmente",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: () {
                            print("tata peando");
                          },
                          child: const Text(
                            "Continuar",
                            style: TextStyle(color: AppTheme.weveSkyBlue),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 236, 236, 236),
                              width: 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 236, 236, 236),
                              width: 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        filled: true,
                        hintText: "Código ID",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
