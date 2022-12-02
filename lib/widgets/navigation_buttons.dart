// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:whats_in_my_fridge/screens/databasetest_page.dart';
// import 'package:whats_in_my_fridge/screens/profile_page.dart';
// import 'package:whats_in_my_fridge/screens/settings_page.dart';
//
// class NavigationButtons extends StatelessWidget {
//   const NavigationButtons({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.all(25.0),
//         child: Stack(
//           children: <Widget>[
//             Padding(padding: EdgeInsets.all(50)),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: FloatingActionButton(
//                 heroTag: "navBtn1",
//                 onPressed: () {
//                   Navigator.pushNamed(context, DataBaseTestPage.routeName);
//                   },
//                 child: const Icon(Icons.storage, ),
//               ),
//             ),
//
//             Align(
//               alignment: Alignment.bottomRight,
//               child: FloatingActionButton(
//                 heroTag: "navBtn3",
//                 onPressed: () {
//                   //Navigator.pushNamed(context, SettingsPage.routeName);
//                   },
//                 child: const Icon(Icons.settings, ),
//               ),
//             )
//           ],
//         )
//     );
//   }
// }