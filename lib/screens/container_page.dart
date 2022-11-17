import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/freezer_page.dart';
import 'package:whats_in_my_fridge/screens/fridge_page.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import 'package:whats_in_my_fridge/widgets/appbar_buttons.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/floating_addButton.dart';
import 'cabinet_page.dart';

class ContainerPage extends StatefulWidget {
  static String routeName = '/containerPage';

  @override
  State<ContainerPage> createState() => _ContainerPageState();
  // TODO: implement createState
}

class _ContainerPageState extends State<ContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Containers'),
      ),
      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: FloatingAddButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
