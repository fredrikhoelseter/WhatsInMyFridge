import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whats_in_my_fridge/screens/add_product_page.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddProductPage()),
        );
      },
    );
  }
}
