import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import '../widgets/appbar_buttons.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_appbar.dart';
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
      appBar: const CustomAppBar(
        title: Text('Other storages contains'),
      ),

      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniCenterDocked,
    );
  }
}