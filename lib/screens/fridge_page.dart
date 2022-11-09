import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import '../widgets/appbar_buttons.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/floating_addButton.dart';
import 'cabinet_page.dart';
import 'freezer_page.dart';

class FridgePage extends StatefulWidget {
  static String routeName = '/fridgePage';

  @override
  State<FridgePage> createState() => _FridgePageState();
// TODO: implement createState
}

class _FridgePageState extends State<FridgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Contents inside fridge'),
      ),


      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniCenterDocked,
    );
  }
}