import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/home_trips.dart';
import 'package:flutter_application_2/profile_trips.dart';
import 'package:flutter_application_2/search_trips.dart';

class PlaztiTripsCupertino extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.indigo),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.indigo),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.indigo),
              label: "",
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (BuildContext context) => HomeTrips(),
              );
            case 1:
              return CupertinoTabView(
                builder: (BuildContext context) => SearchTrips(),
              );
            case 2:
              return CupertinoTabView(
                builder: (BuildContext context) => ProfileTrips(),
              );
            default:
              return CupertinoTabView(
                builder: (BuildContext context) => HomeTrips(),
              );
          }
        },
      ),
    );
  }
}
