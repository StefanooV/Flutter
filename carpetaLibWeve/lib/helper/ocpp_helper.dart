import 'dart:async';
import 'dart:convert'; // Asegúrate de tener este import para usar json.encode
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; // Asegúrate de tener este import para usar WebSocketChannel

class OCPPHelper {
  static final OCPPHelper _instance = OCPPHelper._internal();
  factory OCPPHelper() => _instance;

  OCPPHelper._internal();

  final _subscribers = <void Function(dynamic)>[];
  WebSocketChannel? _channel;
  bool _isConnected = false;
  Timer? _pingTimer;

  // Método para abrir la conexión WebSocket
  Future<void> connectToOCPP() async {
    if (!_isConnected) {
      _channel = WebSocketChannel.connect(
          Uri.parse('wss://ocpp-test.wevemobility.com/mobile'));
      _isConnected = true;

      // Escuchar los mensajes recibidos
      _channel?.stream.listen((message) {
        print("Llegó un mensaje $message");
        var parsedMessage = json.decode(message);
        _notifySubscribers(parsedMessage);
      }, onDone: () {
        _isConnected = false;
        _pingTimer?.cancel();
      }, onError: (error) {
        _isConnected = false;
        _pingTimer?.cancel();
      });

      // Envía un mensaje de saludo o inicial cuando la conexión se abre
      _sendInitialMessage();

      _startPing();
    }
  }

  // Envía un mensaje apenas se abre la conexión WebSocket
  void _sendInitialMessage() {
    final driverUid = FirebaseAuth.instance.currentUser!.uid;
    final message = [
      "OpenChannel",
      {"driverUid": driverUid}
    ];
    _sendMessage(message);
  }

  // Método para suscribir un widget/pantalla a los mensajes
  void subscribe(void Function(dynamic) onMessage) async {
    // Si no está conectado, intenta conectarse
    if (!_isConnected) {
      await connectToOCPP(); // Espera a que se establezca la conexión
    }

    // Ahora se asegura de que está conectado antes de añadir el suscriptor
    _subscribers.add(onMessage);
  }

  // Método para desuscribirse
  void unsubscribe(void Function(dynamic) onMessage) {
    _subscribers.remove(onMessage);
  }

  // Notificar a todos los suscriptores cuando se recibe un mensaje
  void _notifySubscribers(dynamic message) {
    print("Hasta acá estamos.");
    for (var subscriber in _subscribers) {
      subscriber(message);
    }
  }

  // Método para enviar un ping cada 30 segundos
  void _startPing() {
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        sendMessage(["Ping", {}]); // Enviar mensaje de ping
      }
    });
  }

  // Método para enviar un mensaje WebSocket manualmente
  void sendMessage(dynamic message) {
    if (_isConnected && _channel != null) {
      final encodedMessage = json.encode(message);
      _channel?.sink.add(encodedMessage);
    } else {
      print("WebSocket no conectado, mensaje no enviado.");
    }
  }

  // Método privado para enviar mensajes (utilizado internamente)
  void _sendMessage(dynamic message) {
    if (_isConnected && _channel != null) {
      final encodedMessage = json.encode(message);
      _channel?.sink.add(encodedMessage);
    }
  }

  // Cerrar la conexión WebSocket
  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }
}
