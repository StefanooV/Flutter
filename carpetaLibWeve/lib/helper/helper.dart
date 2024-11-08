import 'package:weveapp/models/models.dart';

class Helper {
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String handleFirebaseExMessage(String message) {
    String errorMessage = "";
    switch (message) {
      case "email-already-in-use":
        errorMessage = "El e-mail ingresado ya se encuentra en uso";
        break;
      case "invalid-email":
        errorMessage = "Firebase no puede validar tu email\nRevisa el formato";
        break;
      case "user-disabled":
        errorMessage = "El usuario se encuentra deshabilitado";
        break;
      case "user-not-found":
        errorMessage = "No se encontró el usuario. Revisa tu e-mail";
        break;
      case "wrong-password":
        errorMessage = "Contraseña incorrecta!";
        break;
      case "too-many-requests":
        errorMessage =
            "Se realizaron demasiados intentos fallidos\nVuelve a intentarlo más tarde";
        break;
      case "INVALID_LOGIN_CREDENTIALS":
        errorMessage = "Contraseña incorrecta!";
        break;
    }
    return errorMessage;
  }

  List<ChargingStation> filterByPower(
      List<ChargingStation> stations, int power) {
    return stations
        .where((ChargingStation station) => station.chargers.any(
            (Charger charger) => charger.connector
                .any((Connector connector) => connector.power >= power)))
        .toList();
  }

  List<ChargingStation> filterByConnectorType(
      List<ChargingStation> stations, String connectorTypeId) {
    return stations
        .where((ChargingStation station) => station.chargers.any(
            (Charger charger) => charger.connector.any((Connector connector) =>
                connector.connectorTypeId == connectorTypeId)))
        .toList();
  }

  List<ChargingStation> filterByAvailability(List<ChargingStation> stations) {
    return stations
        .where((ChargingStation station) => station.isAllDay == true)
        .toList();
  }

  List<ChargingStation> filterByNearServices(
      List<ChargingStation> stations, String serviceId) {
    return stations
        .where((ChargingStation station) =>
            station.service.any((Service service) => service.id == serviceId))
        .toList();
  }

  List<ChargingStation> filterByOtherServices(
      List<ChargingStation> stations, String filter) {
    List<ChargingStation> filteredStations = stations;
    switch (filter) {
      case "onlyFree":
        filteredStations = filteredStations
            .where((ChargingStation station) => station.isFree == true)
            .toList();
        break;
      case "highWay":
        filteredStations = filteredStations
            .where((ChargingStation station) => station.isFreeway == true)
            .toList();
        break;
    }
    return filteredStations;
  }

  List<ChargingStation> filterByVisiblility(List<ChargingStation> stations) {
    return stations
        .where((ChargingStation station) => station.visible == true)
        .toList();
  }

  List<ChargingStation> filterByPaymentMethod(List<ChargingStation> stations) {
    return stations
        .where((ChargingStation station) => station.isFree == true)
        .toList();
  }
}
