import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/storage_page.dart';
import '../screens/home_page.dart';
import '../screens/settings_page.dart';

///MobileScreenLayout class represents how the bottom navigation bar looks
///We planned to include more layouts, therfor we wanted to seperate them in different classes
///Used to navigate to the different pages on the navbar.
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

  ///Disposed controller when no longer needed. This will ensure we discard any resources used by the object.
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  ///Sets the current navigation bar page to be highlighted.
  ///If excluded, the navbar will not update and stay on homescreen (first item).
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  ///Changes the page showed in the Pageview
  ///If excluded, the page will not be showed when pressing on the navbar items.
  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  ///List of pages to route the nav buttons to
  List<Widget> _buildHomeScreenItems() {
    return [
      HomePage(
        user: widget.user,
      ),
      const StoragePage(),
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

          ///UI for nav buttons
          items: const <BottomNavigationBarItem>[
            ///Sets the home page icon in the navbar.
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home',
            ),

            ///Sets the storage page icon in the navbar.
            BottomNavigationBarItem(
              icon: Icon(
                Icons.storage,
                size: 30,
              ),
              label: 'Storage',
            ),

            ///Sets the settings page icon in the navbar.
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
