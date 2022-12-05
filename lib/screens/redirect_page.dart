import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whats_in_my_fridge/main.dart';
import 'package:whats_in_my_fridge/responsive/mobile_screen_layout.dart';
import 'package:whats_in_my_fridge/screens/home_page.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';
import 'package:whats_in_my_fridge/screens/login_page.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/utilities/validator.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';

class RedirectPage extends StatefulWidget {
  @override
  _RedirectPageState createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  late User currentUser;

  ///Gets the user from Firebase and sets currentUser to it
  void setCurrentUser() {
    User? loginUser = FirebaseAuth.instance.currentUser;
    currentUser = loginUser!;
  }

  ///Initialize Firebase app
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    setCurrentUser();

    if (currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MobileScreenLayout(user: currentUser),
        ),
      );
    }

    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
              future: _initializeFirebase(),
              builder: (context, snapshot) {
                return StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      ///Checks the state of the stream snapshot
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          ///if waiting shows loading
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        ///If it has data will set the user and log them in
                        setCurrentUser();
                        return MobileScreenLayout(user: currentUser);
                      } else {
                        ///Will show the login page
                        return const LoginPage();
                      }
                    });
              })),
    );
  }
}
