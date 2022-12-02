
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';

class ProfilePage extends StatefulWidget {
  final User user;


  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;

  Image avatar1 = Image.asset('assets/images/boy.png');
  Image avatar2 = Image.asset('assets/images/boytwo.png');
  Image avatar3 = Image.asset('assets/images/girl.png');
  Image avatar4 = Image.asset('assets/images/girltwo.png');


  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  getAvatarFromList() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Profile Page'),
    ),
      body:
         Stack(
          children: <Widget> [
            Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CircleAvatar(
                radius: 85,
                backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 83,
                    backgroundColor: Colors.lightGreen,
                    backgroundImage: AssetImage('assets/images/boy.png'),
                  ),
              ),
            ),
          ),
            Align(
              alignment: Alignment.center,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(21),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: GestureDetector(
                          onTap: () {

                          },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/boy.png'),
                        ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(21),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/boytwo.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(21),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/girl.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(21),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/girltwo.png'),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
        ],
        ),
    );
  }
}