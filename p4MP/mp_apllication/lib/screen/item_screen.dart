import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mp_apllication/screen/pago_screen.dart';

class ItemScreen extends StatelessWidget {
  static const String routename = 'ItemScreen';
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 175, 156),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Remera Oversize',
                    style: TextStyle(fontSize: 40, color: Colors.white)),
                SizedBox(
                  child: Image.asset('assets/remera.jpg'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        Response<Map> response;
                        response = await dio
                            .post('http://192.168.56.1:3000/create_preference');
                        var res = response.data;
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => PagoScreen(
                                        url: res?['url'],
                                      )));
                        }
                      } catch (err) {
                        print(err);
                      }
                    },
                    child: const Text('Pagar con MP')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
