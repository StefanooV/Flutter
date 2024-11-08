// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weveapp/services/auth_service.dart';
import 'package:weveapp/theme/app_theme.dart';
import 'package:weveapp/widgets/widgets.dart';

class WeveDrawer extends StatefulWidget {
  const WeveDrawer({
    super.key,
    required this.scaffoldKey,
    required this.homeContext,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext homeContext;

  @override
  State<WeveDrawer> createState() => _WeveDrawerState();
}

class _WeveDrawerState extends State<WeveDrawer> {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    scaffoldKey = widget.scaffoldKey;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Platform.isIOS ? 180 : 160,
            width: MediaQuery.of(context).size.width,
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.wevePrimaryBlue,
                image: DecorationImage(
                  image: AssetImage("assets/images/wevetrims.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: UserIdentity(),
            ),
          ),
          Expanded(
            child: ListView(
                padding: const EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    leading: const Icon(Icons.map_outlined),
                    title: const Text("Ver mapa"),
                    onTap: () => scaffoldKey.currentState?.closeDrawer(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: const Text("Ver filtros"),
                    onTap: () {
                      scaffoldKey.currentState?.closeDrawer();

                      widget.homeContext.push("/filters");
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.route,
                      size: 18,
                    ),
                    title: const Text("Trazar una ruta"),
                    onTap: () async {
                      context.push("/search");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_border),
                    title: const Text("Favoritos"),
                    onTap: () {
                      context.push("/driverMyFavorites");
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        "Cuenta",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600),
                      )),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text("Mi cuenta"),
                    onTap: () {
                      context.push("/driverMyAccount");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.power_outlined),
                    title: const Text("Mis cargas"),
                    onTap: () {
                      context.push("/driverChargeHistory");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_car_outlined),
                    title: const Text("Mis vehículos"),
                    onTap: () {
                      context.push("/driverMyVehicles");
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        "Otros",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600),
                      )),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.power_settings_new_outlined),
                    title: const Text("Cerrar sesión"),
                    onTap: () async {
                      Navigator.pop(context);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool("logedIn?", false);
                      AuthService().signOut(context);
                    },
                  ),
                ]),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text("2024 • Weve ® • versión 3.4.0 - Test"),
            ),
          )
        ],
      ),
    );
  }
}
