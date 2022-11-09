import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import '../widgets/appbar_buttons.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/floating_addButton.dart';
import 'freezer_page.dart';
import 'fridge_page.dart';

class CabinetPage extends StatefulWidget {
  static String routeName = '/cabinetPage';

  @override
  State<CabinetPage> createState() => _CabinetPageState();
// TODO: implement createState
}

class _CabinetPageState extends State<CabinetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other storages contains'),
      ),

      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: AppbarButtons(),
        ),
      ),

      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniCenterDocked,
    );
  }
}