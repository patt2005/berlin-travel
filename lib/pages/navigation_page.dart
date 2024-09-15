import 'package:berlin_travel_app/pages/main_page.dart';
import 'package:berlin_travel_app/pages/settings_page.dart';
import 'package:berlin_travel_app/pages/special_places_page.dart';
import 'package:berlin_travel_app/pages/trips_page.dart';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: secondaryColor,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star_circle_fill),
            label: 'Special',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.briefcase_fill),
            label: 'My travels',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_solid),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const MainPage();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const SpecialPlacesPage();
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const TripsPage();
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const SettingsPage();
              },
            );
          default:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const MainPage();
              },
            );
        }
      },
    );
  }
}
