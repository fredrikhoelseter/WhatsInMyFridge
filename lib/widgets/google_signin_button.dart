// import 'package:flutter/material.dart';

// class GoogleSignInButton extends StatelessWidget {

//   const GoogleSignInButton({Key? key, this.callback})
//       : super(key: key);

//   final VoidCallback? callback;
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         onPressed: callback,
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.white),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(4.0),
//               side: const BorderSide(color: Colors.green),
//             )
//           )
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Image.asset("images/icons8-google-48.png"),
//             const Text("Sign in with Google"),
//             Opacity(
//               opacity: 0.0,
//               child: Image.asset("images/icons8-google-48.png"),
//             )
//           ],
//         )
//     );
//   }
  
// }