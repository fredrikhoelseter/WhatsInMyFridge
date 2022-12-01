import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/databasetest_page.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';

List<Widget> homeScreenItems = [
  const DataBaseTestPage(),
  ProfilePage(
    user: FirebaseAuth.instance.currentUser!,
  ),
];
