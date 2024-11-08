// To parse this JSON data, do
//
//     final country = countryFromMap(jsonString);

import 'dart:convert';


Power powerFromMap(String str) => Power.fromMap(json.decode(str));

String powerToMap(Power data) => json.encode(data.toMap());

class Power {
  Power({
    required this.power,
    required this.status,
  });

  String power;
  String status;


  factory Power.fromMap(Map<String, dynamic> json) => Power(
        power: json["power"],
        status: json["status"],
      );
  Map<String, dynamic> toMap() => {
        "power": power,
        "status": status,
      };
}

List<Power> powerList = [];

parsePowers() {
  for (var power in powerJson) {
    powerList.add(Power.fromMap(power));
  }
  return powerList;
}

List<Map<String, String>> powerJson = [
  {
	"power": "7kw",
	"status": "false",
},
{
	"power": "22kw",
	"status": "false",
},
{
	"power": "50kw",
	"status": "false",
},
{
	"power": "100kw",
	"status": "false",
},
{
	"power": "150kw",
	"status": "false",
},
{
	"power": "Más",
	"status": "false",
},
];