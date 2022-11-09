import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/widgets/google_signin_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final double height;

  const CustomAppBar({
    Key? key, required this.title,
    this.height = kToolbarHeight,
  }) : super(key: key);



  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>
      [
        AppBar(
          title: title,
        ),
        Row(
          children: <Widget>
          [
            ElevatedButton(
              child: Text("Fridge"),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text("Freezer"),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text("Other"),
              onPressed: () {},
            )
          ],
        )
      ],
    );
  }
}