import 'dart:io';

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/redirect_page.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';

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

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    sendingVerificationEmailText = "";
    resettingPasswordText = "";
    userRefreshedText = "";
    checkEmailVerfied();
  }

  /// This checks whether or not the email of the current user is verified or not.
  /// Sets the text of the settingsitem to reflect the state of verification.
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

  /// If the user email verification gets sent, this updates the subtitle of the settingsitem.
  void sendingEmailVerification() {
    sendingVerificationEmailText = ("Link sent to your connected email!");
  }

  /// If the user gets refreshed, this sets the subtitle to the settingsitem.
  void userRefreshed() {
    userRefreshedText = ("Refreshed user!");
  }

  /// Gets the state of the users email, if it is verified or not
  bool getIfEmailIsVerified() {
    return verified;
  }

  /// Updates the subtitle of the settingsitem if the user presses the reset password button.
  void resettingPassword() {
    resettingPasswordText = "Link sent to your connected email!";
  }

  /// Show warning pop up dialog when user tries to delete accout.
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
            builder: (context) => RedirectPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Logged in as: ${_currentUser.displayName}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Align(
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
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 63,
                          backgroundImage: AssetImage(imageFile),
                        ),
                      ),
                    ),
                  ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Text("Tap to change Avatar", style: TextStyle(fontSize: 12),))),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Email: ${_currentUser.email}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Member since: ${_currentUser.metadata.creationTime?.toString().substring(0, 16)}",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                //A group for the settings items.
                SettingsGroup(
                  settingsGroupTitle: "Settings",
                  settingsGroupTitleStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
                            builder: (context) => RedirectPage(),
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
    return LayoutBuilder(
        builder: (BuildContext, BoxConstraints) {
          double radius = 30;
          if (BoxConstraints.maxWidth < 400) {
            radius = 24;
          }

          return Container(
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              children: <Widget>[
                const Text(
                  "Choose Avatar",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: Colors.black,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            imageFile = 'assets/images/boy.png';
                          });
                        },
                        child: CircleAvatar(
                          radius: radius-2,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/boy.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          imageFile = 'assets/images/boytwo.png';
                        });
                      },
                      child: CircleAvatar(
                        radius: radius,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: radius-2,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/boytwo.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          imageFile = 'assets/images/girl.png';
                        });
                      },
                      child: CircleAvatar(
                        radius: radius,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: radius-2,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/girl.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          imageFile = 'assets/images/girltwo.png';
                        });
                      },
                      child: CircleAvatar(
                        radius: radius,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: radius-2,
                          backgroundColor: Colors.lightGreen,
                          backgroundImage: AssetImage('assets/images/girltwo.png'),
                        ),
                      ),
                    ),
                  ),
                ])
              ],
            ),
          );
        }
    );
  }
}
