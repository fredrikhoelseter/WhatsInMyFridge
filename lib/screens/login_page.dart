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
import 'package:whats_in_my_fridge/screens/true_login_page.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/utilities/validator.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import 'package:whats_in_my_fridge/widgets/google_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    sendToMobileLayout(user!);
    return firebaseApp;
  }

  void sendToMobileLayout(User user) {
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MobileScreenLayout(user: user),
        ),
      );
    }
  }

  late User currentUser;

  void setCurrentUser() {
    User? loginUser = FirebaseAuth.instance.currentUser;
    currentUser = loginUser!;
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        setCurrentUser();
                        return MobileScreenLayout(user: currentUser);
                      } else {
                        return TrueLoginPage();
                      }
                    });
              })),
    );
  }
}
