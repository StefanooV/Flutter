import 'dart:convert';

class ChargingStation {
  String id;
  String name;
  DateTime createdOn;
  String locationName;
  String internalLocation;
  String placeId;
  String locationAddress;
  String latitude;
  String longitude;
  Schedule schedule;
  bool visible;
  bool isAllDay;
  bool isFreeway;
  bool isFree;
  dynamic additionalInformation;
  List<String> imagesLink;
  List<Charger> chargers;
  List<Service> service;

  ChargingStation({
    required this.id,
    required this.name,
    required this.createdOn,
    required this.locationName,
    required this.internalLocation,
    required this.placeId,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.schedule,
    required this.visible,
    required this.isAllDay,
    required this.isFreeway,
    required this.isFree,
    required this.additionalInformation,
    required this.imagesLink,
    required this.chargers,
    required this.service,
  });

  factory ChargingStation.fromJson(String str) =>
      ChargingStation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChargingStation.fromMap(Map<String, dynamic> json) => ChargingStation(
        id: json["id"],
        name: json["name"],
        createdOn: DateTime.parse(json["createdOn"]),
        locationName: json["locationName"],
        internalLocation: json["internalLocation"],
        placeId: json["placeId"],
        locationAddress: json["locationAddress"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        schedule: Schedule.fromMap(json["schedule"]),
        visible: json["visible"],
        isAllDay: json["isAllDay"],
        isFreeway: json["isFreeway"],
        isFree: json["isFree"],
        additionalInformation: json["additionalInformation"],
        imagesLink: List<String>.from(json["imagesLink"].map((x) => x)),
        chargers:
            List<Charger>.from(json["chargers"].map((x) => Charger.fromMap(x))),
        service:
            List<Service>.from(json["service"].map((x) => Service.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "createdOn": createdOn.toIso8601String(),
        "locationName": locationName,
        "internalLocation": internalLocation,
        "placeId": placeId,
        "locationAddress": locationAddress,
        "latitude": latitude,
        "longitude": longitude,
        "schedule": schedule.toMap(),
        "visible": visible,
        "isAllDay": isAllDay,
        "isFreeway": isFreeway,
        "isFree": isFree,
        "additionalInformation": additionalInformation,
        "imagesLink": List<dynamic>.from(imagesLink.map((x) => x)),
        "chargers": List<dynamic>.from(chargers.map((x) => x.toMap())),
        "service": List<dynamic>.from(service.map((x) => x)),
      };

  List<StationConnector> getConnectorsSummary() {
    Map<String, StationConnector> connectorMap = {};

    for (Charger charger in chargers) {
      for (Connector connector in charger.connector) {
        if (connectorMap.containsKey(connector.connectorTypeId)) {
          if (connector.power >
              connectorMap[connector.connectorTypeId]!.power) {
            connectorMap[connector.connectorTypeId]!.power = connector.power;
          }
          connectorMap[connector.connectorTypeId]!.total++;
          connectorMap[connector.connectorTypeId]!.connectors.add(connector);
        } else {
          List<Connector> connectorsList = [connector];
          connectorMap[connector.connectorTypeId] = StationConnector(
            id: connector.connectorTypeId,
            description: connector.description,
            total: 1,
            power: connector.power,
            ocppConnectorId: connector.identifiedName,
            connectors: connectorsList,
          );
        }
      }
    }

    return connectorMap.values.toList();
  }
}

class Charger {
  String id;
  String name;
  String serialNumber;
  DateTime heartBeat;
  String chargerBrandId;
  String chargerBrandDescription;
  List<Connector> connector;
  String stationName;
  String stationId;

  Charger({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.heartBeat,
    required this.chargerBrandId,
    required this.chargerBrandDescription,
    required this.connector,
    required this.stationName,
    required this.stationId,
  });

  factory Charger.fromJson(String str) => Charger.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Charger.fromMap(Map<String, dynamic> json) => Charger(
        id: json["id"],
        name: json["name"],
        serialNumber: json["serialNumber"],
        heartBeat: DateTime.parse(json["heartBeat"]),
        chargerBrandId: json["chargerBrandId"],
        chargerBrandDescription: json["chargerBrandDescription"],
        connector: List<Connector>.from(json["connector"].map((x) =>
            Connector.fromMap(
                x, json["serialNumber"]))), // Ahora pasamos serialNumber
        stationName: json["stationName"],
        stationId: json["stationId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "serialNumber": serialNumber,
        "heartBeat": heartBeat.toIso8601String(),
        "chargerBrandId": chargerBrandId,
        "chargerBrandDescription": chargerBrandDescription,
        "connector": List<dynamic>.from(connector.map((x) => x.toMap())),
        "stationName": stationName,
        "stationId": stationId,
      };
}

class Connector {
  String connectorTypeId;
  String description;
  int identifiedName;
  List<dynamic> fees;
  num power;
  bool selected;
  String chargerSerialNumber; // Cambiamos de chargerId a serialNumber
  bool? available;

  Connector({
    required this.connectorTypeId,
    required this.description,
    required this.identifiedName,
    required this.fees,
    required this.power,
    this.selected = false,
    required this.chargerSerialNumber, // Hacemos serialNumber obligatorio
    this.available,
  });

  factory Connector.fromJson(String str, String chargerSerialNumber) =>
      Connector.fromMap(json.decode(str), chargerSerialNumber);

  String toJson() => json.encode(toMap());

  factory Connector.fromMap(
          Map<String, dynamic> json, String chargerSerialNumber) =>
      Connector(
        connectorTypeId: json["connectorTypeId"],
        description: json["description"],
        identifiedName: json["identifiedName"],
        fees: List<dynamic>.from(json["fees"].map((x) => x)),
        power: json["power"],
        chargerSerialNumber: chargerSerialNumber,
      );

  Map<String, dynamic> toMap() => {
        "connectorTypeId": connectorTypeId,
        "description": description,
        "identifiedName": identifiedName,
        "fees": List<dynamic>.from(fees.map((x) => x)),
        "power": power,
        "selected": selected,
        "chargerSerialNumber":
            chargerSerialNumber, // Incluimos serialNumber en el toMap
      };
}

class Schedule {
  List<AvailabilityOnTheDay> availabilityOnTheDay;

  Schedule({
    required this.availabilityOnTheDay,
  });

  factory Schedule.fromJson(String str) => Schedule.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Schedule.fromMap(Map<String, dynamic> json) => Schedule(
        availabilityOnTheDay: List<AvailabilityOnTheDay>.from(
            json["availabilityOnTheDay"]
                .map((x) => AvailabilityOnTheDay.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "availabilityOnTheDay":
            List<dynamic>.from(availabilityOnTheDay.map((x) => x.toMap())),
      };
}

class AvailabilityOnTheDay {
  String day;
  bool active;
  bool allDay;
  List<dynamic> availabilityHours;

  AvailabilityOnTheDay({
    required this.day,
    required this.active,
    required this.allDay,
    required this.availabilityHours,
  });

  factory AvailabilityOnTheDay.fromJson(String str) =>
      AvailabilityOnTheDay.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AvailabilityOnTheDay.fromMap(Map<String, dynamic> json) =>
      AvailabilityOnTheDay(
        day: json["day"],
        active: json["active"],
        allDay: json["allDay"],
        availabilityHours:
            List<dynamic>.from(json["availabilityHours"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "day": day,
        "active": active,
        "allDay": allDay,
        "availabilityHours":
            List<dynamic>.from(availabilityHours.map((x) => x)),
      };
}

class Service {
  final String id;
  final String description;

  Service({
    required this.id,
    required this.description,
  });

  factory Service.fromJson(String str) => Service.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Service.fromMap(Map<String, dynamic> json) => Service(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
      };
}

class StationConnector {
  String id;
  String description;
  int total;
  num power;
  int ocppConnectorId;
  bool selected;
  bool expanded;
  List<Connector> connectors;

  StationConnector({
    required this.id,
    required this.description,
    required this.total,
    required this.power,
    required this.ocppConnectorId,
    required this.connectors,
    this.selected = false,
    this.expanded = false,
  });

  factory StationConnector.fromJson(String str) =>
      StationConnector.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StationConnector.fromMap(Map<String, dynamic> json) =>
      StationConnector(
        id: json["id"],
        description: json["description"],
        total: json["total"],
        power: json["power"],
        ocppConnectorId: json["identifiedName"],
        connectors: json["connectors"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "total": total,
        "power": power,
        "ocppConnectorId": ocppConnectorId,
        "connectors": connectors,
      };
}
