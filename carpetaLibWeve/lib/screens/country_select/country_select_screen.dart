import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weveapp/models/country_model.dart';
import 'package:weveapp/providers/country_provider.dart';

class CountrySelectScreen extends StatefulWidget {
  @override
  State<CountrySelectScreen> createState() => _CountrySelectScreenState();
}

class _CountrySelectScreenState extends State<CountrySelectScreen> {
  List<Country> countryList = [];
  @override
  void initState() {
    super.initState();
    final countriesService =
        Provider.of<CountryService>(context, listen: false);
    if (mounted) countryList = parseCountries();
  }

  @override
  Widget build(BuildContext context) {
    final countriesService =
        Provider.of<CountryService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Seleccioná tu país",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                fontSize: 22),
          ),
        ),
        body: ListView.builder(
            itemCount: countryList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset(
                  'assets/flags/${countryList[index].iso2.toLowerCase()}.png',
                  width: 35,
                ),
                title: Text(
                    "${countryList[index].nombre} • (+${countryList[index].phoneCode})"),
                onTap: () {
                  countriesService.setCountry(countryList[index]);
                  Navigator.pop(context);
                },
              );
            }));
  }
}
