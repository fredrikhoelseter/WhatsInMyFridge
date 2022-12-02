import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/login_page.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/widgets/bottom_navbar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            //A group for the settings items.
            SettingsGroup(
              settingsGroupTitle: "Account",
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
                  onTap: () async {
                    setState(() {
                      _isDeletingUser = true;
                    });
                    await FireAuth.deleteUser(context);

                    setState(() {
                      _isDeletingUser = false;
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
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
    );
  }
}
