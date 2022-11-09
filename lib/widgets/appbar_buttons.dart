import 'package:flutter/material.dart';

import '../screens/cabinet_page.dart';
import '../screens/freezer_page.dart';
import '../screens/fridge_page.dart';

class AppbarButtons extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 75, 0, 15),
      child: Row(

      children: [
        Spacer(),
        ElevatedButton(onPressed: () {Navigator.pushNamed(context, FridgePage.routeName);
        },
          child: Text('Fridge'),
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 2.0, color: Colors.white),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),

              ),

          ),
        ),

        Spacer(),
        ElevatedButton(onPressed: () {Navigator.pushNamed(context, FreezerPage.routeName);
        },
          child: Text('Freezer'),
          style: ElevatedButton.styleFrom(
              side: BorderSide(width: 2.0, color: Colors.white),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )
          ),
        ),

        Spacer(),
        ElevatedButton(onPressed: () {Navigator.pushNamed(context, CabinetPage.routeName);
        },
          child: Text('Others'),
          style: ElevatedButton.styleFrom(
              side: BorderSide(width: 2.0, color: Colors.white),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )
          ),
        ),

        Spacer(),
      ],
    ),
    );
  }
}