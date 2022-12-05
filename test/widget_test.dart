import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whats_in_my_fridge/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/responsive/mobile_screen_layout.dart';
import 'package:whats_in_my_fridge/screens/storage_page.dart';
import 'package:whats_in_my_fridge/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whats_in_my_fridge/screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import 'package:whats_in_my_fridge/widgets/search_bar.dart';

///Widget-test for whats in my fridge application.
void main() {

  /// Testing CustomAppBar widget
  testWidgets('Test for CustomAppBar Widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CustomAppBar(title: Text("Whats in my fridge"), height: 20,)));
    final textFinder = find.text("Whats in my fridge");
    expect(textFinder, findsOneWidget);
  });
}

