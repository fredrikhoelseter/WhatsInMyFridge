import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import '../widgets/appbar_buttons.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/floating_addButton.dart';
import 'cabinet_page.dart';
import 'fridge_page.dart';

class FreezerPage extends StatefulWidget {
  static String routeName = '/freezerPage';

  @override
  State<FreezerPage> createState() => _FreezerPageState();
// TODO: implement createState
}

class _FreezerPageState extends State<FreezerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Contents inside freezer'),
      ),


      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniCenterDocked,
    );
  }
}