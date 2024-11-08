// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weveapp/helper/helper.dart';
import 'package:weveapp/models/driver_vehicle_model.dart';
import 'package:weveapp/models/get_by_id_model.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/models/favorites_model.dart' as favorite_model;
import 'package:weveapp/providers/switches_provider.dart';
import 'package:weveapp/services/app_constants.dart';
import 'package:weveapp/services/auth_service.dart';
import 'package:weveapp/widgets/station_bottom_sheet/station_bottom_sheet.dart';
import 'package:weveapp/widgets/widgets.dart';
import '../theme/app_theme.dart';

String? appEnv = dotenv.env['APP_ENV'];
String authority =
    appEnv == "test" ? dotenv.env["TEST_URL"]! : dotenv.env["PROD_URL"]!;
String mediaAuthority = appEnv == "test"
    ? dotenv.env["TEST_MEDIA_URL"]!
    : dotenv.env["PROD_MEDIA_URL"]!;
String staticMediaAuthority = appEnv == "test"
    ? dotenv.env["TEST_STATIC_MEDIA_URL"]!
    : dotenv.env["PROD_STATIC_MEDIA_URL"]!;

Future<String?> _getToken(BuildContext screenContext) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  if (token != null) {
    return token;
  } else {
    await AuthService().signOut(screenContext);
    return null;
  }
}

Future<Uri> _getUrl(String endpoint, [Map<String, String>? params]) async {
  Uri url = Uri();
  if (appEnv == "test") {
    url = Uri.https(authority, endpoint, params);
  } else {
    url = Uri.https(authority, endpoint, params);
  }
  return url;
}

String _getMediaUrl(String connectorTypeId) {
  String url = "";
  if (appEnv == "test") {
    url = "http://${mediaAuthority}${connectorTypeId}.png";
  } else {
    url = "https://${mediaAuthority}${connectorTypeId}.png";
  }
  return url;
}

class MarkersProvider with ChangeNotifier {
  List<Marker> markers = [];
  List<Marker> baseMarkers = [];
  bool markersReady = false;
  List<ChargingStation> stations = [];
  List<ChargingStation> baseStations = [];
  final List<int> values = [200, 100, 50, 22, 11, 3];
  final List<String> chargingTypes = [
    "SUPER RÁPIDA",
    "RÁPIDA",
    "SEMI RÁPIDA",
    "LENTA",
  ];
  int selectedIndex = 5;

  void filterStations(AppData appData, Map<String, dynamic> activeFilters) {
    Helper helper = Helper();
    Map<String, dynamic> filtersRequestBody = activeFilters;
    List<String> keys = filtersRequestBody.keys.toList();
    stations = baseStations;
    for (String key in keys) {
      switch (key) {
        case "connectorId":
          List<String> connectorIds = filtersRequestBody[key] as List<String>;
          for (String connectorId in connectorIds) {
            stations = helper.filterByConnectorType(stations, connectorId);
          }
          break;
        case "power":
          int power = filtersRequestBody[key] as int;
          stations = helper.filterByPower(stations, power);
          break;
        case "hideInvisibleChargers":
          stations = helper.filterByVisiblility(stations);
          break;
        case "hidePaidChargers":
          stations = helper.filterByPaymentMethod(stations);
          break;
        case "onlyAllDay":
          stations = helper.filterByAvailability(stations);
          break;
        case "services":
          List<String> servicesId = filtersRequestBody[key] as List<String>;
          for (String serviceId in servicesId) {
            stations = helper.filterByNearServices(stations, serviceId);
          }
          break;
        case "isFreeWay":
          stations = helper.filterByOtherServices(stations, "highWay");
          break;
      }
    }

    appData.setTotalFilters();
    appData.filtering = true;
    markers = [];
    markersReady = false;
  }

  void getMarkers(AppData appData, BuildContext context) {
    getChargingStationMarkers(context);
  }

  void getChargingStationMarkers(BuildContext screenContext) async {
    final appData = Provider.of<AppData>(screenContext, listen: false);

    String? token = await _getToken(screenContext);
    if (!markersReady) {
      if (appData.filtering) {
        for (ChargingStation station in stations) {
          Marker newMarker = _createMarker(screenContext, station);
          print("New marker: $newMarker");
          markers.add(newMarker);
        }
      } else {
        stations = await getChargingStations(token!);
        for (ChargingStation station in stations) {
          Marker newMarker = _createMarker(screenContext, station);
          print("New marker: $newMarker");
          markers.add(newMarker);
        }
      }
    }
    if (baseMarkers.isEmpty) {
      baseMarkers = markers;
    }
    print("Markers: $markers");
    notifyListeners();
    markersReady = true;
  }

  void getFilteredChargingStationMarkers(
      BuildContext screenContext, AppData appData) async {
    String? token = await _getToken(screenContext);
    if (!markersReady) {
      stations =
          await getFilteredChargingStations(token!, appData.filtersRequestBody);
      for (ChargingStation station in stations) {
        Marker newMarker = _createMarker(screenContext, station);
        markers.add(newMarker);
      }
    }
    notifyListeners();
    markersReady = true;
  }

  Future<List<Charger>> getChargers(String token) async {
    final Uri url = await _getUrl("/Business/Charger/GetAllCharger");
    print(url);
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      final parsedResponse = jsonDecode(response.body);
      print(token);
      final resultsArray = parsedResponse as List;
      final chargers = resultsArray
          .map((chargerData) => Charger.fromMap(chargerData))
          .toList();
      print(chargers);
      return chargers;
    } catch (err) {
      print("erroraso : $err");
      return [];
    }
  }

  Future<List<ChargingStation>> getChargingStations(String token) async {
    final Uri url = await _getUrl("/DriverUser/GetAllChargingStation");
    print("getStationsUrl: $url");
    print(token);
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      final parsedResponse = jsonDecode(response.body);
      final list = parsedResponse as List;
      final stations =
          list.map((station) => ChargingStation.fromMap(station)).toList();
      baseStations = stations;
      return stations;
    } catch (err) {
      print("Error obteniendo estaciones: $err");
      return List.empty();
    }
  }

  Future<List<ChargingStation>> getFilteredChargingStations(
      String token, Map<String, dynamic> request) async {
    print("Acá : $request");
    final Uri url = await _getUrl("/DriverUser/Station/GetFiltered");
    print("URL filter: $url");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            "connectorId": request["connectorId"],
            "power": request["power"],
            "hideInvisibleChargers": request["hideInvisibleChargers"],
            "hideHomeChargers": request["hideHomeChargers"],
            "hidePaidChargers": request["hidePaidChargers"],
            "onlyAllDay": request["onlyAllDay"],
            "isFreeWay": request["isFreeWay"],
            "services": request["services"]
          },
        ),
      );
      final parsedResponse = jsonDecode(response.body);
      final list = parsedResponse as List;
      final stations =
          list.map((station) => ChargingStation.fromMap(station)).toList();
      return stations;
    } catch (err) {
      print("Error filter: $err");
      return List.empty();
    }
  }

  Future<int> getNearbyStationsCount(
      LatLng point, BuildContext screenContext) async {
    // Crear una lista de estaciones cercanas
    List<ChargingStation> nearbyStations = [];
    Map<String, String> distances = <String, String>{};

    if (stations.isEmpty) {
      String? token = await _getToken(screenContext);
      List<ChargingStation> chargingStations =
          await getChargingStations(token!);
      for (ChargingStation station in chargingStations) {
        double distance = getDistance(
          double.parse(station.latitude),
          double.parse(station.longitude),
          point.latitude,
          point.longitude,
        );

        if (distance <= 15) {
          nearbyStations.add(station);
          distances[station.id] = distance.toStringAsFixed(2);
        }
      }
    }

    for (ChargingStation station in stations) {
      double distance = getDistance(
        double.parse(station.latitude),
        double.parse(station.longitude),
        point.latitude,
        point.longitude,
      );

      if (distance <= 15) {
        nearbyStations.add(station);
        distances[station.id] = distance.toStringAsFixed(2);
      }
    }

    return nearbyStations.length;
  }

  Future<(List<ChargingStation>, Map<String, String>)> getNearbyStations(
      LatLng userLocation, BuildContext screenContext) async {
    // Crear una lista de estaciones cercanas
    List<ChargingStation> nearbyStations = [];
    Map<String, String> distances = <String, String>{};

    if (stations.isEmpty) {
      String? token = await _getToken(screenContext);
      List<ChargingStation> chargingStations =
          await getChargingStations(token!);
      for (ChargingStation station in chargingStations) {
        double distance = getDistance(
            double.parse(station.latitude),
            double.parse(station.longitude),
            userLocation.latitude,
            userLocation.longitude);

        if (distance <= 15) {
          nearbyStations.add(station);
          distances[station.id] = distance.toStringAsFixed(2);
        }
      }
    }

    for (ChargingStation station in stations) {
      double distance = getDistance(
          double.parse(station.latitude),
          double.parse(station.longitude),
          userLocation.latitude,
          userLocation.longitude);

      if (distance <= 15) {
        nearbyStations.add(station);
        distances[station.id] = distance.toStringAsFixed(2);
      }
    }

    return (nearbyStations, distances);
  }

  double getDistance(double lat1, double lng1, double lat2, double lng2) {
    double dLat = (lat2 - lat1) * pi / 180;
    double dLng = (lng2 - lng1) * pi / 180;

    // Este valor se basa en la elipsoide WGS 84, que es un modelo matemático de la forma de la Tierra
    double distance = 6371.01 * sqrt(dLat * dLat + dLng * dLng);

    return distance;
  }

  Marker _createMarker(BuildContext screenContext, ChargingStation station) {
    return Marker(
      rotate: true,
      height: 50,
      width: 50,
      point: LatLng(
          double.parse(station.latitude), double.parse(station.longitude)),
      builder: ((screenContext) => InkWell(
            onTap: () {
              print("Ya tu sae");
              HttpRequestServices().onStationTapped(screenContext, station);
            },
            child: const Image(
              image: AssetImage("assets/images/lbwevemarker.png"),
            ),
          )),
    );
  }
}

class HttpRequestServices {
  String getFillerImageUrl(String image) {
    String url = "";
    if (appEnv == "test") {
      url = "http://${staticMediaAuthority}${image}.png";
    } else {
      url = "https://${staticMediaAuthority}${image}.png";
    }
    return url;
  }

  Future<GoogleMapsPlaceDetail> getPlaceDetails(
      double latitude, double longitude) async {
    final Uri url = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '${latitude.toString()},${longitude.toString()}',
      'key': AppConstants.googleMapsApiKey,
    });
    final response = await http.get(url);
    var parsedResponse = jsonDecode(response.body);
    final GoogleMapsPlaceDetail placedetail =
        GoogleMapsPlaceDetail.fromMap(parsedResponse);
    return placedetail;
  }

  Future<GetById?> getPricing(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final Uri url = await _getUrl("/Business/Pricing/Pricing/GetById/$id");
    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var parsedPricing = jsonDecode(response.body);
      return GetById.fromMap(parsedPricing);
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List<VehicleBrand>?> getCarBrands() async {
    final Uri url = await _getUrl("/Driver/VehicleBrand");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final parsedResponse = jsonDecode(response.body);

      if (parsedResponse is List) {
        List<VehicleBrand> brandsList = [];

        for (var brandMap in parsedResponse) {
          brandsList.add(VehicleBrand.fromMap(brandMap));
        }

        return brandsList;
      } else {
        print("Invalid response format");
        return null;
      }
    } catch (err) {
      print("GetCarBrandsError: $err");
      return null;
    }
  }

  Future<List<VehicleModel>?> getCarModels(String brandId) async {
    final Uri url = await _getUrl("/Driver/VehicleModel/GetByBrandId");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            "id": brandId,
          },
        ),
      );

      final parsedResponse = jsonDecode(response.body);

      if (parsedResponse is List) {
        List<VehicleModel> vehicleModels = [];

        for (var modelMap in parsedResponse) {
          vehicleModels.add(VehicleModel.fromMap(modelMap));
        }

        return vehicleModels;
      } else {
        print("Invalid response format");
        return null;
      }
    } catch (err) {
      print("GetVehicleModels: $err");
      return null;
    }
  }

  Future<GetById?> getConnectorType(String id) async {
    final Uri url = await _getUrl("/Driver/ConnectorType/GetById/$id");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var parsedConnector = jsonDecode(response.body);
      return GetById.fromMap(parsedConnector);
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<GetById?> getChargingPower(String id) async {
    final Uri url = await _getUrl("/Business/CharginPowerById/$id");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var parsedPower = jsonDecode(response.body);
      return GetById.fromMap(parsedPower);
    } catch (err) {
      return null;
    }
  }

  Future<List<SearchHistory>?> getUserSearchHistory() async {
    final Uri url = await _getUrl("/DriverUser/SearchHistory");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var searchHistory = jsonDecode(response.body);
      List<SearchHistory> searchHistoryList = [];
      for (var searchHistoryElement in searchHistory) {
        SearchHistory element = SearchHistory.fromMap(searchHistoryElement);
        searchHistoryList.add(element);
      }
      return searchHistoryList;
    } catch (err) {
      return null;
    }
  }

  Future<List<ChargerConnectorType>> getChargerTypes(
      BuildContext context) async {
    final filtersStatus = Provider.of<AppData>(context, listen: false);
    final Uri url = await _getUrl("/Driver/ConnectorType");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (filtersStatus.chargerConnectorTypeList.isNotEmpty) {
      return filtersStatus.chargerConnectorTypeList;
    }
    if (filtersStatus.chargerConnectorTypeList.isEmpty) {
      try {
        final response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
        print("response ${response.statusCode}");
        var chargerTypes = jsonDecode(response.body);
        List<ChargerConnectorType> chargerTypesList = [];
        for (var charger in chargerTypes) {
          ChargerConnectorType chargerType =
              ChargerConnectorType.fromMap(charger);
          chargerTypesList.add(chargerType);
        }

        if (filtersStatus.chargerConnectorTypeList.isEmpty) {
          filtersStatus.chargerConnectorTypeList = chargerTypesList;
        }
        inspect(filtersStatus.chargerConnectorTypeList);
        return chargerTypesList;
      } catch (err) {
        List<ChargerConnectorType> emptyList = [];
        return emptyList;
      }
    } else {
      List<ChargerConnectorType> emptyList = [];
      return emptyList;
    }
  }

  Future<List<ChargingPower>> getChargingPowers(BuildContext context) async {
    final filtersStatus = Provider.of<AppData>(context, listen: false);
    final Uri url = await _getUrl("/Driver/CharginPower");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (filtersStatus.chargingPowerList.isEmpty) {
      try {
        final response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
        var chargingPowers = jsonDecode(response.body);
        List<ChargingPower> chargingPowersList = [];
        for (var power in chargingPowers) {
          ChargingPower chargingPower = ChargingPower.fromMap(power);
          chargingPowersList.add(chargingPower);
        }
        if (filtersStatus.chargingPowerList.isEmpty) {
          filtersStatus.chargingPowerList = chargingPowersList;
        }
        return chargingPowersList;
      } catch (err) {
        List<ChargingPower> emptyList = [];
        return emptyList;
      }
    } else {
      List<ChargingPower> emptyList = [];
      return emptyList;
    }
  }

  Future<void> addNewFavorite(String stationId, BuildContext context) async {
    final Uri url = await _getUrl("/Favorite");
    print("url: $url");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            "stationId": stationId,
          },
        ),
      );
      print(stationId);
      inspect(response);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Añadido a favoritos."),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.wevePrimaryBlue,
        duration: Duration(seconds: 1),
        dismissDirection: DismissDirection.down,
      ));
      print(response.body);
    } catch (err) {
      print(err);
    }
  }

  Future<List<FilterService>?> getServicesList(BuildContext context) async {
    final appData = Provider.of<AppData>(context, listen: false);
    if (appData.servicesList.isNotEmpty) return appData.servicesList;
    final Uri url = await _getUrl("/Driver/Service");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      List<dynamic> responseJson = json.decode(response.body);
      List<FilterService> reponseServicesList =
          responseJson.map((e) => FilterService.fromMap(e)).toList();
      print("opaxx");
      for (var service in reponseServicesList) {
        appData.filterSwitches[service.id] = false;
      }
      appData.servicesList = reponseServicesList;
      return reponseServicesList;
    } catch (err) {
      print("error recuperando lista de servicios: $err");
      return null;
    }
  }

  Future<void> addUserVehicle(BuildContext context, String vehicleBrandId,
      String vehicleModelId) async {
    final Uri url = await _getUrl("/Driver/Vehicle");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            "vehicleBrandId": vehicleBrandId,
            "vehicleModelId": vehicleModelId,
            "vehicleTypeId": "f7019a10-164b-42a0-b264-2f8ce8ce9dcb",
            "vehicleConnectorTypeId": "4bae5aa3-5962-4975-9fbc-e55b17d593ae"
          },
        ),
      );
    } catch (err) {
      print("error creando vehículo: $err");
    }
  }

  Future<List<favorite_model.Result>?> getUserFavorites() async {
    final Uri url =
        await _getUrl("/Favorite/GetPage", {"page": "1", "limit": "100"});
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("urlFavo $url");
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            "propertyToSortBy": "string",
            "sortOrder": 0,
          },
        ),
      );
      print("complex: ${response.statusCode}");
      final parsedResponse = jsonDecode(response.body);
      final results = parsedResponse['results'] as List<dynamic>;
      final favoriteList = results
          .map((result) => favorite_model.Result.fromMap(result))
          .toList();
      return favoriteList;
    } catch (err) {
      print("se complicó $err");
      return null;
    }
  }

  Future<bool> checkFavorite(String id) async {
    final Uri url = await _getUrl("/Favorite/GetFavorites", {"stationId": id});
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("estáfavo? ${response.body}");
      return jsonDecode(response.body);
    } catch (err) {
      print("se complicó $err");
      return false;
    }
  }

  Future<void> deleteFavoriteByStationId(String id) async {
    final Uri url = await _getUrl("/Favorite/DeleteByStationId/$id");
    print("elId $id");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (err) {
      print(err);
    }
  }

  Future<void> deleteFavoriteById(String id) async {
    final Uri url = await _getUrl("/Favorite/DeleteById/$id");
    print("elId $id");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (err) {
      print(err);
    }
  }

  Future<void> deleteUserVehicle(String id) async {
    final Uri url = await _getUrl("/Driver/Vehicle/$id");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("deletiando ${response.body}");
    } catch (err) {
      print(err);
    }
  }

  Future<void> updateDriverUser(Map<String, String?> body) async {
    final Uri url = await _getUrl("/DriverUser/UpdateData");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      print("elbody $body");
      print("Actualizando driverUser ${response.body}");
    } catch (err) {
      print(err);
    }
  }

  Future<(String, String)> getPlaceInfo(LatLng placePoint) async {
    final String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${placePoint.latitude},${placePoint.longitude}&key=${AppConstants.googleMapsApiKey}";
    final Uri apiUri = Uri.parse(apiUrl);

    try {
      final response = await http.get(apiUri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          // Obtener el nombre de la provincia
          String provinceName = "";
          List<dynamic> addressComponents =
              data['results'][0]['address_components'];
          for (var component in addressComponents) {
            List<dynamic> types = component['types'];
            if (types.contains("administrative_area_level_1")) {
              provinceName = component['long_name'];
              break;
            }
          }
          String streetName = "";
          String streetNumber = "";
          for (var component in addressComponents) {
            List<dynamic> types = component['types'];
            if (types.contains("route")) {
              streetName = component['long_name'];
            } else if (types.contains("street_number")) {
              streetNumber = component['long_name'];
            }
          }
          print("Punto tappeado google: $streetName, Provincia: $provinceName");

          return (
            "$streetName $streetNumber",
            provinceName,
          );
        } else {
          print('Error en la solicitud de geocodificación');
          return ("Error", "Error");
        }
      } else {
        print("Error al conectarse a la API de Google Maps");
        return ("Error", "Error");
      }
    } catch (e) {
      print('Error: $e');
      return ("Error", "Error");
    }
  }

  Future<double?> getDrivingTime(
      double startLat, double startLng, double endLat, double endLng) async {
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&mode=driving&key=${AppConstants.googleMapsApiKey}';

    final response = await http.get(Uri.parse(apiUrl));

    print("DrivingTime response: ${response.body}");

    if (startLat == 0 && startLng == 0) {
      return null;
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] != "ZERO_RESULTS") {
        final duration =
            data['routes'][0]['legs'][0]['duration']['value'] as int;
        return duration / 60.0;
      } else {
        return 0;
      }
    } else {
      throw Exception('Failed to load driving time');
    }
  }

  Future<List<DriverVehicle>?> getDriverVehicles() async {
    final Uri url =
        await _getUrl("/Driver/Vehicle/getpage", {"page": "1", "limit": "100"});
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("urlFavo $url");
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            "propertyToSortBy": "string",
            "sortOrder": 0,
          },
        ),
      );
      Map<String, dynamic> responseJson = json.decode(response.body);
      List<dynamic> resultsJson = responseJson["results"];
      List<DriverVehicle> driverVehicles = resultsJson
          .map((resultJson) => DriverVehicle.fromMap(resultJson))
          .toList();
      return driverVehicles;
    } catch (err) {
      print("se complicó $err");
      return null;
    }
  }

  Future<bool> addToSearchHistory(Prediction prediction, String title,
      double latitude, double longitude) async {
    print("tariamos entonces");
    final Uri url = await _getUrl("/DriverUser/AddToSearchHistory");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final body = jsonEncode(
      {
        "title": title,
        "latitude": latitude,
        "longitude": longitude,
        "prediction": prediction,
      },
    );
    print("addBody : $body");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      print("el body de historial ${response.body}");
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<List<String>> getSearchHistory() async {
    final Uri url = await _getUrl("/DriverUser/SearchHistory");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print("historial : ${response.body}");
      final parsedReponse = jsonDecode(response.body);
      List<String> searchHistory = [];
      for (String element in parsedReponse) {
        searchHistory.add(element);
      }
      return searchHistory;
    } catch (err) {
      print("Error trayendo el historial: ${err}");
      return [];
    }
  }

  Future<bool> registerTap(String stationId) async {
    print("tariamos entonces");
    final Uri url = await _getUrl("/Activity/$stationId");
    print(url);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("el body del tap ${response.statusCode}");
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> registerChargerPointing(String stationId) async {
    print("tariamos entonces pointing");
    final Uri url = await _getUrl("/DriverUser/ChargerPoint");
    print(url);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"stationId": stationId}),
      );
      print("el body del pointing ${response.statusCode}");
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  void onStationTapped(BuildContext context, ChargingStation station) async {
    double desiredHeight = station.imagesLink.isNotEmpty ? 520 : 320;
    double screenHeight = MediaQuery.of(context).size.height;
    double multiplier = desiredHeight / screenHeight;
    await registerTap(station.id);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StationBottomSheet(
          station: station,
          multiplier: multiplier,
        );
      },
    );
  }
}

ScrollController sc = ScrollController();

List<AvailabilityOnTheDay> orderList(List<AvailabilityOnTheDay> list) {
  List<String> daysOrder = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];
  list.sort(
      (a, b) => daysOrder.indexOf(a.day).compareTo(daysOrder.indexOf(b.day)));
  list = list.where((e) => e.active == true).toList();
  return list;
}
