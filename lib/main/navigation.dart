import 'package:flutter/material.dart';

class Navigation {
  final String title;
  final IconData icon;

  const Navigation(this.title, this.icon);

}
const List<Navigation> allNavigation = <Navigation> [
  Navigation('Home', Icons.home),
  Navigation('Course', Icons.menu_book)
];