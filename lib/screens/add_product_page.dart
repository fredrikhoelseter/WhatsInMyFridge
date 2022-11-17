import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import '../widgets/appbar_buttons.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/floating_addButton.dart';
import 'freezer_page.dart';
import 'fridge_page.dart';

class AddProductPage extends StatefulWidget {
  static String routeName = '/addProductPage';

  @override
  State<AddProductPage> createState() => _AddProductPageState();
// TODO: implement createState
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a product!'),
      ),
      body: Container(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
