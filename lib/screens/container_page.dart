import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/floating_addButton.dart';

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
      appBar: AppBar(
        title: Text('Your Containers'),
      ),

      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
        child: Container(margin: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0), child: Row(

          children: [
            Spacer(),
            ElevatedButton(onPressed: () {},
                child: Text('Fridge'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
                ),
            ),

            Spacer(),
            ElevatedButton(onPressed: () {},
              child: Text('Freezer'),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
              ),
            ),

            Spacer(),
            ElevatedButton(onPressed: () {},
              child: Text('Others'),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
              ),
            ),

            Spacer(),
          ],
        ),
        ),
      ),
      ),

      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniCenterDocked,
    );
  }
}