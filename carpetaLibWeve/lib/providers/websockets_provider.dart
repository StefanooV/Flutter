import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketProvider extends ChangeNotifier {
  late WebSocketChannel _channel;
  bool _isConnected = false;

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
      print('Conectado a WebSocket en $url');
      _listenToMessages();
    } catch (e) {
      print('Error al conectar: $e');
      _isConnected = false;
      _reconnect();
    }
  }

  void _listenToMessages() {
    _channel.stream.listen(
      (message) {
        print('Mensaje recibido: $message');
        // Aquí podrías actualizar el estado y notificar a los widgets
        notifyListeners();
      },
      onError: (error) {
        print('Error en WebSocket: $error');
        _isConnected = false;
        _reconnect();
      },
      onDone: () {
        print('Conexión WebSocket cerrada');
        _isConnected = false;
        _reconnect();
      },
    );
  }

  void sendMessage(String message) {
    if (_isConnected) {
      _channel.sink.add(message);
      print('Mensaje enviado: $message');
    } else {
      print('No se puede enviar, WebSocket desconectado');
    }
  }

  Future<void> _reconnect() async {
    print('Reconectando en 5 segundos...');
    await Future.delayed(const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }
}
