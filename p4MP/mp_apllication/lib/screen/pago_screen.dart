import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mp_apllication/screen/aprobado_screen.dart';
import 'package:mp_apllication/screen/pendiente_screen.dart';
import 'package:mp_apllication/screen/rechazado_screen.dart';

class PagoScreen extends StatefulWidget {
  static const String routename = 'PagoScreen';
  final String? url;

  const PagoScreen({super.key, this.url});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(widget.url!)),
            onUpdateVisitedHistory: (controller, url, isReload) {
              if (url.toString().contains("https://httpstat.us/200")) {
                webViewController?.goBack();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AprobadoScreen()));
                return;
              } else if (url.toString().contains("https://httpstat.us/400")) {
                webViewController?.goBack();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RechazadoScreen()));
                return;
              } else if (url.toString().contains("https://httpstat.us/202")) {
                webViewController?.goBack();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PendienteScreen()));
                return;
              }
            },
          )
        ],
      ),
    ));
  }
}
