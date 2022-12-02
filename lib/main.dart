import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/responsive/mobile_screen_layout.dart';
import 'package:whats_in_my_fridge/screens/databasetest_page.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';

import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => FireAuth(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Authentication',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 24.0,
                ),
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              ),
            ),
            textTheme: TextTheme(
              headline1: TextStyle(
                fontSize: 46.0,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
              bodyText1: TextStyle(fontSize: 18.0),
            ),
          ),
          home: AuthWrapper(),
          routes: {
            DataBaseTestPage.routeName: (context) => DataBaseTestPage(),
          },
        ));
  }
}

class AuthWrapper extends StatelessWidget {
   const AuthWrapper({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     final firebaseUser = context.watch<User?>();

     if (firebaseUser != null) {
       return MobileScreenLayout(user: firebaseUser);
     } else {
       return LoginPage();
     }
   }
}
