import 'dart:io';

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/login_page.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/widgets/bottom_navbar.dart';
import 'package:image_picker/image_picker.dart';

//Using babstrap_settings_screen 0.1.3 dependency to create this settings page, code has been added/modified to meet our demands.

class SettingsPage extends StatefulWidget {
  final User user;

  const SettingsPage({required this.user});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  bool _isDeletingUser = false;
  bool _isResettingPassword = false;
  late String emailVerified;
  late bool verified;
  late String sendingVerificationEmailText;
  late String userRefreshedText;
  late String resettingPasswordText;

  late User _currentUser;
  final ImagePicker _picker = ImagePicker();
  late PickedFile _imageFile;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    sendingVerificationEmailText = "";
    resettingPasswordText = "";
    userRefreshedText = "";
    checkEmailVerfied();
  }

  //This checks wheter or not the email of the current user is verified or not.
  //Sets the text of the settingsitem to reflect the state of verification.
  void checkEmailVerfied() async {
    if (_currentUser.emailVerified) {
      emailVerified = ("Email already verified");
      verified = true;
      setState(() {});
    } else {
      emailVerified = ("Send authentication link");
      verified = false;
      setState(() {});
    }
  }

  //If the user email verification gets sent, this updates the subtitle of the settingsitem.
  void sendingEmailVerification() {
    sendingVerificationEmailText = ("Link sent to your connect email!");
  }

  //If the user gets refreshed, this sets the subtitle to the settingsitem.
  void userRefreshed() {
    userRefreshedText = ("Refreshed user!");
  }

  //Gets the state of the users email, if it is verified or not
  bool getIfEmailIsVerified() {
    return verified;
  }

  //Updates the subtitle of the settingsitem if the user presses the reset password button.
  void resettingPassword() {
    resettingPasswordText = "Link sent to your connect email!";
  }

  //Show warning pop up dialog when user tries to delete accout.
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        await FireAuth.deleteUser(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Dialog"),
      content:
          Text("Are you sure you want to permanently delete your account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source,);
    setState(() {
      _imageFile = pickedFile as PickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 63,
                    // backgroundImage: _imageFile == null
                    //     ? AssetImage("assets/images/boy.png")
                    //     : FileImage(_imageFile!.path) as ImageProvider,
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 150),child: Align(alignment: Alignment.topCenter, child: Text("Tap on image to change"))),
          Padding(
          padding: const EdgeInsets.fromLTRB(15, 220, 15, 15),
          child: ListView(
            children: [
              //A group for the settings items.
              SettingsGroup(
                settingsGroupTitle: "Account: ${_currentUser.email}",
                settingsGroupTitleStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                items: [
                  //Send a link to the current users email
                  //User can verify email
                  SettingsItem(
                    onTap: () {
                      if (!getIfEmailIsVerified()) {
                        _currentUser.sendEmailVerification();
                        sendingEmailVerification();
                        setState(() {});
                      }
                    },
                    icons: Icons.email_rounded,
                    title: emailVerified,
                    subtitle: sendingVerificationEmailText,
                  ),

                  //To refresh the user, this is needed after verifying the email.
                  SettingsItem(
                    onTap: () async {
                      User? user = await FireAuth.refreshUser(_currentUser);
                      if (user != null) {
                        setState(() {
                          _currentUser = user;
                          userRefreshed();
                          setState(() {});
                        });
                      }
                    },
                    icons: Icons.refresh_rounded,
                    title: "Refresh user",
                    subtitle: userRefreshedText,
                  ),

                  //Sends a link to the current users email
                  //User can change password on that link
                  SettingsItem(
                      onTap: () async {
                        await FireAuth.resetPassword(
                            email: '${_currentUser.email}');
                        resettingPassword();
                        setState(() {});
                      },
                      icons: CupertinoIcons.lock_fill,
                      title: "Reset passowrd",
                      subtitle: resettingPasswordText),

                  //Button to sign the user out of the app.
                  //Gets pushed back to the login page.
                  SettingsItem(
                    onTap: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    icons: Icons.exit_to_app_rounded,
                    title: "Sign Out",
                  ),

                  //Button that calls the delete user function.
                  //Gets pushed back to the login page.
                  SettingsItem(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
}
