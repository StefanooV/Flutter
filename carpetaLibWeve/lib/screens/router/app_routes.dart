import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/screens/home_screen/home_screen_2.dart';
import 'package:weveapp/screens/screens.dart';

class AppRoutes {
  static final menuOptions = <MenuOption>[];

  static final routerConfig = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          print("se vino para acá");
          return FirebaseAuth.instance.currentUser == null
              ? const LoginScreen()
              : const NewHomeScreen();
        },
      ),
      // Ruta para "QR"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;

          return QrScannerScreen(
            station: extra["station"],
            selectedConnector: extra["selectedConnector"],
          );
        },
        path: '/qr',
      ),
      // Ruta para "Transaction"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;

          return TransactionScreen(
            station: extra["station"],
            selectedConnector: extra["selectedConnector"],
            chargerSerialNumber: extra["chargerSerialNumber"],
          );
        },
        path: '/transaction',
      ),
      // Ruta para "filters"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) =>
            const SelectFilters(),
        path: '/filters',
      ),
      // Ruta para "login"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
        path: '/login',
      ),

      // Ruta para "driverRegister"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const DriverRegisterScreen();
        },
        path: '/driverRegister',
      ),

      // Ruta para "selectCar"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const DriverCarSelectionScreen();
        },
        path: '/selectCar',
      ),

      // Ruta para "registerFinish"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return DriverRegisterFinishScreen(
              displayName: state.uri.queryParameters["displayName"]!);
        },
        path: '/registerFinish',
      ),

      // Ruta para "driverMyAccount"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const DriverMyAccountScreen();
        },
        path: '/driverMyAccount',
      ),

      // Ruta para "driverPersonalInformation"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const DriverPersonalInformation();
        },
        path: '/driverPersonalInformation',
      ),

      // Ruta para "home"
      GoRoute(
        path: '/station',
        name: 'station',
        builder: (BuildContext context, GoRouterState state) {
          final double lat = double.parse(state.uri.queryParameters['lat']!);
          final double long = double.parse(state.uri.queryParameters['long']!);
          if (FirebaseAuth.instance.currentUser != null) {
            print("Entró acá igual");
            return HomeScreen(
              latitude: lat,
              longitude: long,
            );
          } else {
            print("Fuapp");
            return LoginScreen(
              deepLinkAccess: true,
              latitude: lat,
              longitude: long,
            );
          }
        },
      ),

      // Ruta para "filters"

      // Ruta para "driverChargeHistory"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const DriverChargeHistory();
        },
        path: '/driverChargeHistory',
      ),

      // Ruta para "driverMyVehicles"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const DriverMyVehiclesScreen();
        },
        path: '/driverMyVehicles',
      ),

      // Ruta para "search"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const SearchScreen();
        },
        path: '/search',
      ),

      // Ruta para "driverMyFavorites"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const DriverMyFavoritesScreen();
        },
        path: '/driverMyFavorites',
      ),

      // Ruta para "chargersInfo"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const ChargerInfoScreen();
        },
        path: '/chargersInfo',
      ),

      // Ruta para "searchHistory"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const SearchHistoryScreen();
        },
        path: '/searchHistory',
      ),

      // Ruta para "notificationsScreen"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsScreen();
        },
        path: '/notificationsScreen',
      ),

      // Ruta para "selectCountry"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return CountrySelectScreen();
        },
        path: '/selectCountry',
      ),

      // Ruta para "passwordRecovery"
      GoRoute(
        builder: (BuildContext context, GoRouterState state) {
          return PasswordRecoveryScreen();
        },
        path: '/passwordRecovery',
      ),
    ],
  );

  void clearNavigationStack(BuildContext context, String path) {
    while (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }

    GoRouter.of(context).pushReplacement(path);
  }

  static Map<String, Widget Function(BuildContext)> routes = {
    "login": (BuildContext context) => const LoginScreen(),
    "driverRegister": (BuildContext context) => DriverRegisterScreen(),
    "selectCar": (BuildContext context) => const DriverCarSelectionScreen(),
    "driverMyAccount": (BuildContext context) => const DriverMyAccountScreen(),
    "driverPersonalInformation": (BuildContext context) =>
        const DriverPersonalInformation(),
    "home": (BuildContext context) => const HomeScreen(),
    "filters": (BuildContext context) => const SelectFilters(),
    "driverChargeHistory": (BuildContext context) =>
        const DriverChargeHistory(),
    "driverMyVehicles": (BuildContext context) =>
        const DriverMyVehiclesScreen(),
    "search": (BuildContext context) => const SearchScreen(),
    "driverMyFavorites": (BuildContext context) =>
        const DriverMyFavoritesScreen(),
    "chargersInfo": (BuildContext context) => const ChargerInfoScreen(),
    "searchHistory": (BuildContext context) => const SearchHistoryScreen(),
    "notificationsScreen": (BuildContext context) =>
        const NotificationsScreen(),
    "selectCountry": (BuildContext context) => CountrySelectScreen(),
    "passwordRecovery": (BuildContext context) => PasswordRecoveryScreen()
  };
}
