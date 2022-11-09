import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/cabinet_page.dart';
import 'package:whats_in_my_fridge/screens/container_page.dart';
import 'package:whats_in_my_fridge/screens/freezer_page.dart';
import 'package:whats_in_my_fridge/screens/fridge_page.dart';

import 'screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 46.0,
            color: Colors.green.shade700,
            fontWeight: FontWeight.w500,
          ),
          bodyText1: TextStyle(fontSize: 18.0),
        ),
      ),
      home: LoginPage(),

      routes: {
        ContainerPage.routeName: (context) => ContainerPage(),
        FridgePage.routeName: (context) => FridgePage(),
        FreezerPage.routeName: (context) => FreezerPage(),
        CabinetPage.routeName: (context) => CabinetPage(),
      },
    );
  }
}
