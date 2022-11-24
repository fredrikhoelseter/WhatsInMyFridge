import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/widgets/appbar_buttons.dart';
import 'package:whats_in_my_fridge/widgets/google_signin_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final double height;

  const CustomAppBar({
    Key? key, required this.title,
    this.height = kToolbarHeight*3,
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
          centerTitle: true,
          //flexibleSpace: AppbarButtons(),
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.account_circle),
            ),)
          ],
        ),

      ],
    );
  }
}