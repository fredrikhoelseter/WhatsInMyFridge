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

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    checkEmailVerfied();
  }

  void checkEmailVerfied() async {
    if (_currentUser.emailVerified) {
      emailVerified = ("Email already verified");
    } else {
      emailVerified = ("Send authentication link");
    }
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
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about WIMFA",
                ),
              ],
            ),

            //Button that calls the sign out function.
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () {
                    checkEmailVerfied();
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: emailVerified,
                ),
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

























// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:whats_in_my_fridge/screens/login_page.dart';
// import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
// import 'package:whats_in_my_fridge/widgets/bottom_navbar.dart';


// class SettingsPage extends StatefulWidget {
//   final User user;

//   const SettingsPage({required this.user});

//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   bool _isSendingVerification = false;
//   bool _isSigningOut = false;
//   bool _isDeletingUser = false;
//   bool _isResettingPassword = false;

//   late User _currentUser;

//   @override
//   void initState() {
//     _currentUser = widget.user;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 16.0),
//             Text(
//               'NAME: ${_currentUser.displayName}',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             Text(
//               'EMAIL: ${_currentUser.email}',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             SizedBox(height: 16.0),
//             _currentUser.emailVerified
//                 ? Text(
//                     'Email verified',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText1!
//                         .copyWith(color: Colors.green),
//                   )
//                 : Text(
//                     'Email not verified',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText1!
//                         .copyWith(color: Colors.red),
//                   ),
//             SizedBox(height: 16.0),
//             _isSendingVerification
//                 ? CircularProgressIndicator()
//                 : Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           setState(() {
//                             _isSendingVerification = true;
//                           });
//                           await _currentUser.sendEmailVerification();
//                           setState(() {
//                             _isSendingVerification = false;
//                           });
//                         },
//                         child: Text('Verify email'),
//                         style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
//                       ),
//                       SizedBox(width: 8.0),
//                       IconButton(
//                         icon: Icon(Icons.refresh),
//                         onPressed: () async {
//                           User? user = await FireAuth.refreshUser(_currentUser);

//                           if (user != null) {
//                             setState(() {
//                               _currentUser = user;
//                             });
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//             SizedBox(height: 16.0),
//             _isSigningOut
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: () async {
//                       setState(() {
//                         _isSigningOut = true;
//                       });
//                       await FirebaseAuth.instance.signOut();
//                       setState(() {
//                         _isSigningOut = false;
//                       });
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(
//                           builder: (context) => LoginPage(),
//                         ),
//                       );
//                     },
//                     child: Text('Sign out'),
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//             SizedBox(height: 16.0),
//             _isDeletingUser
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: () async {
//                       setState(() {
//                         _isDeletingUser = true;
//                       });
//                       await FireAuth.deleteUser(context);

//                       setState(() {
//                         _isDeletingUser = false;
//                       });
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(
//                           builder: (context) => LoginPage(),
//                         ),
//                       );
//                     },
//                     child: Text('Delete User'),
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//             SizedBox(height: 16.0),
//             _isResettingPassword
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: () async {
//                       setState(() {
//                         _isResettingPassword = true;
//                       });
//                       await FireAuth.resetPassword(
//                           email: '${_currentUser.email}');

//                       setState(() {
//                         _isResettingPassword = false;
//                       });
//                     },
//                     child: Text('Reset password'),
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//             SizedBox(height: 16.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
