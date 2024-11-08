import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:weveapp/services/auth_service.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class DriverMyAccountScreen extends StatefulWidget {
  const DriverMyAccountScreen({Key? key}) : super(key: key);

  @override
  State<DriverMyAccountScreen> createState() => _DriverMyAccountScreenState();
}

class _DriverMyAccountScreenState extends State<DriverMyAccountScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text("Mi Cuenta", style: TextStyle(fontFamily: "Montserrat")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Column(
          children: [
            FirebaseAuth.instance.currentUser!.photoURL != null
                ? Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            FirebaseAuth.instance.currentUser!.photoURL!),
                      ),
                    ),
                  )
                : Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppTheme.weveSkyBlue),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          FirebaseAuth.instance.currentUser!.displayName![0],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 48),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 12,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: const TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: const [DriverMyAccountCard()],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      "Cerrar sesión",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    AuthService().signOut(context);
                    print('cerramos sesión pai');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
