import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weveapp/models/models.dart';
import 'package:weveapp/providers/providers.dart';
import 'package:http/http.dart' as http;
import '../models/driver_user_model.dart';
import '../models/get_list_model.dart';

Future<Uri> _getUrl(String endpoint, [Map<String, String>? params]) async {
  Uri url = Uri();
  if (appEnv == "test") {
    url = Uri.https(authority, endpoint, params);
  } else {
    url = Uri.https(authority, endpoint, params);
  }
  return url;
}

class AppData extends ChangeNotifier {
  int totalFilters = 0;
  Map<String, bool> filterSwitches = {};
  bool sheetExpanded = false;
  Map<String, dynamic> baseFiltersBody = {
    "connectorId": null,
    "power": null,
    "hideInvisibleChargers": null,
    "hideHomeChargers": null,
    "hidePaidChargers": null,
    "onlyAllDay": null,
    "isFreeWay": null,
    "services": null
  };
  Map<String, dynamic> filtersRequestBody = {
    "connectorId": null,
    "power": null,
    "hideInvisibleChargers": null,
    "hideHomeChargers": null,
    "hidePaidChargers": null,
    "onlyAllDay": null,
    "isFreeWay": null,
    "services": null
  };
  Map startNavigationData = {"name": "", "latitude": 0, "longitude": 0};
  Map destinationNavigationData = {"name": "", "latitude": 0, "longitude": 0};
  Map<String, String?> driverUserData = {
    "userName": null,
    "name": "",
    "lastName": "",
    "email": "",
    "phoneNumber": "",
    "city": "",
    "country": "",
    "bornDate": ""
  };
  Map<String, String?> driverUserUpdateBody = {
    "userName": null,
    "name": null,
    "lastName": null,
    "email": null,
    "phoneNumber": null,
    "city": null,
    "country": null,
    "bornDate": null
  };
  List<ChargingPower> chargingPowerList = [];
  List<ChargerConnectorType> chargerConnectorTypeList = [];
  List<FilterService> servicesList = [];
  List<Marker> stationMarkers = [];
  List<GetList> brandsList = [];
  List<Car> carModelsList = [];
  DriverUser? driverUser;
  bool filtering = false;
  String selectedBrand = "";
  String selectedBrandId = "";
  String selectedModel = "";
  String selectedModelId = "";
  bool brandSelected = false;
  bool modelSelected = false;
  bool brandsReady = false;
  bool modelsReady = false;
  bool isFavorite = false;
  bool filtersSelected = false;
  bool servicesReady = false;
  bool searching = false;
  BuildContext? searchSheetContext;
  List<ChargerConnectorType> connectors = [];

  void setTotalFilters() {
    List<String> keys = filtersRequestBody.keys.toList();
    totalFilters = 0;
    for (String key in keys) {
      if (filtersRequestBody[key] != null) {
        totalFilters++;
      }
    }
    notifyListeners();
  }

  setSheetExpansionState(bool state) {
    sheetExpanded = state;
    // notifyListeners();
  }

  void setSwitchStatus(String field, bool status) {
    filterSwitches[field] = status;
  }

  getSwitchStatus(String field) {
    return filterSwitches[field];
  }

  void setPointData(String point, String? name, LatLng latLng) {
    if (point == "start") {
      if (name != null) startNavigationData["name"] = name;
      startNavigationData["latitude"] = latLng.latitude;
      startNavigationData["longitude"] = latLng.longitude;
      print("Lugarcito $startNavigationData");
    }
    if (point == "destination") {
      if (name != null) destinationNavigationData["name"] = name;
      destinationNavigationData["latitude"] = latLng.latitude;
      destinationNavigationData["longitude"] = latLng.longitude;
      print("Lugarcito $destinationNavigationData");
    }
  }

  getPointData(String point) {
    if (point == "start") {
      return startNavigationData[point];
    }
    if (point == "destination") {
      destinationNavigationData[point];
    }
  }

  Future<void> getCarBrands() async {
    final Uri url = await _getUrl("/Driver/VehicleBrand");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("acá tamo");
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
      var parsedList = parsedResponse as List;
      List<GetList> brands = [];
      for (var brand in parsedList) {
        brands.add(GetList.fromMap(brand));
      }
      brandsList = brands;
      brandsReady = true;
      if (selectedBrand == "" && selectedBrandId == "") {
        selectedBrand = brandsList.first.description;
        selectedBrandId = brandsList.first.id;
      }
      getBrandModels(selectedBrandId);
      print("marcaelegida: $selectedBrandId");
      brandSelected = true;

      notifyListeners();
    } catch (err) {
      print("Error de las marcas $err");
    }
  }

  Future<void> getBrandModels(String id) async {
    modelsReady = false;
    carModelsList.clear();
    final Uri url = await _getUrl("/Driver/VehicleModel/GetByBrandId");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("acá tamo modelos $id");
    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"id": id}));
      final parsedResponse = jsonDecode(response.body);
      var parsedList = parsedResponse as List;
      List<Car> carModels = [];
      for (var car in parsedList) {
        carModels.add(Car.fromMap(car));
      }
      carModelsList = carModels;
      print("carmodels $carModelsList");
      modelsReady = true;
      selectedModel = carModelsList.first.description;
      selectedModelId = carModelsList.first.id;
      print("modelsReady? $modelsReady");
      notifyListeners();
    } catch (err) {
      print("negrasou $err");
    }
  }

  Future<void> checkFavorite(String id) async {
    final Uri url = await _getUrl("/Favorite/GetFavorites", {"chargerId": id});
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
      isFavorite = jsonDecode(response.body);
      notifyListeners();
    } catch (err) {
      print("se complicó $err");
    }
  }

  Future<void> getDriverUserById() async {
    final Uri url = await _getUrl("/DriverUser/GetById");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("tokensito $token");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      driverUser = DriverUser.fromMap(jsonDecode(response.body));
      print("driver ${driverUser?.phoneNumber}");
      notifyListeners();
    } catch (err) {
      print("error driveruser $err");
      driverUser = null;
      notifyListeners();
    }
  }
}
