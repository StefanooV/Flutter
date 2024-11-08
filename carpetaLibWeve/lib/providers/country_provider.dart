import 'package:flutter/material.dart';
import 'package:weveapp/models/models.dart';

class CountryService extends ChangeNotifier {
  Map countryData = {
    "nombre": "Argentina",
    "name": "Argentina",
    "nom": "Argentine",
    "iso2": "AR",
    "iso3": "ARG",
    "phone_code": "54"
  };
  void setCountry(Country country) {
    countryData["nombre"] = country.nombre;
    countryData["name"] = country.name;
    countryData["nom"] = country.nom;
    countryData["iso2"] = country.iso2;
    countryData["iso3"] = country.iso3;
    countryData["phone_code"] = country.phoneCode;
  }
}
