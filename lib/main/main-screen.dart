import 'package:flutter/material.dart';
import 'package:refactory_test/main/feature/course/course-screen.dart';
import 'package:refactory_test/main/feature/home/home-screen.dart';
import 'package:refactory_test/main/navigation.dart';

class MainScreen extends StatefulWidget {
  final Navigation navigation;
  const MainScreen({Key key, this.navigation}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: allNavigation.length,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomeScreen(),
            CourseScreen(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: allNavigation.map<Widget>((navigation) {
            return Tab(
              icon: Icon(navigation.icon),
              text: "${navigation.title}",
            );
          }).toList(),
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
