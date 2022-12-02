import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/profile_page.dart';
import '../screens/storage_page.dart';
import '../screens/home_page.dart';
import '../screens/settings_page.dart';
import '../utilities/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  MobileScreenLayout({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  List<Widget> _buildHomeScreenItems() {
    return [
      HomePage(
        user: widget.user,
      ),
      const StoragePage(),
      ProfilePage(user: widget.user),
      SettingsPage(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _buildHomeScreenItems(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CupertinoTabBar(
          height: 50,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.storage,
                size: 30,
              ),
              label: 'Storage',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 30,
              ),
              label: 'Settings',
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
