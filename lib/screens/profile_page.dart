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

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  getAvatarFromList() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text('Profile Page'),
            SizedBox(
              width: 220,
            ),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 21,
                backgroundColor: Colors.lightGreen,
                backgroundImage: AssetImage('assets/images/boy.png'),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
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
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/boy.png'),
                      ),
                    ),
                  ),
                ),
                const Padding(
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
                const Padding(
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
                const Padding(
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
          Padding(
            padding: const EdgeInsets.only(top: 400.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text(
                    "Logged in as: ${_currentUser.displayName}",
                    style: TextStyle(fontSize: 28),
                  ),
                  Text(
                    "Email: ${_currentUser.email}",
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(
                    "Member since: ${_currentUser.metadata.creationTime}",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
