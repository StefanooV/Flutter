import 'package:flutter/material.dart';
import 'package:weveapp/screens/router/app_routes.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class DriverRegisterFinishScreen extends StatelessWidget {
  final String displayName;
  const DriverRegisterFinishScreen({
    super.key,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          color: const Color.fromARGB(255, 61, 255, 255),
        ),
        title: const Text("Registro exitoso"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(140),
                  bottomRight: Radius.circular(140),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromARGB(255, 61, 255, 255),
                    Color.fromARGB(255, 61, 189, 255),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.task_alt,
                    color: Colors.white,
                    size: 148,
                  ),
                  Text(
                    "¡Bienvenido/a $displayName!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 52),
            const Text(
              "¿Cómo quieres seguir?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      const ButtonStyle(elevation: MaterialStatePropertyAll(0)),
                  onPressed: () {
                    double desiredHeight = 400;
                    double screenHeight = MediaQuery.of(context).size.height;
                    double multiplier = desiredHeight / screenHeight;
                    showModalBottomSheet(
                      isDismissible: true,
                      isScrollControlled: true,
                      enableDrag: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      context: context,
                      builder: (sheetContext) => AddCarBottomSheet(
                        multiplier: multiplier,
                        sheetContext: sheetContext,
                        isRegistering: true,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Text(
                      "Añadir tu vehículo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => AppRoutes().clearNavigationStack(context, "/"),
              child: const Text(
                "Comenzar a usar Weve",
                style: TextStyle(
                  color: AppTheme.weveSkyBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
