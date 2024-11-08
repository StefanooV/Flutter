void main() async {
  print('Inicio del programa');

  try {
    final value = await httpGet('https://example.com');
    print('exito:  $value');
  } on Exception catch (err) {
    print('Tenemos una excepcion: $err');
  } catch (err) {
    print('OPP! Tenemos un error: $err');
  } finally {
    print('Fin del try y catch');
  }

  print('Fin del programa');
}

Future<String> httpGet(String url) async {
  await Future.delayed(const Duration(seconds: 1));
  throw Exception('No hay parámetros en el URL');
  // throw 'Error en la peticion';
  // return 'Respuesta de la peticion http';
}
