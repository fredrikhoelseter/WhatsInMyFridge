import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/floating_addButton.dart';

class ContainerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Containers'),
      ),

      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );

  }
}