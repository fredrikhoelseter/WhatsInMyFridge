import 'package:cloud_firestore/cloud_firestore.dart';

String SearchStringItemPage = "";

String CurrentStringSortSelected = "Expiration Date";

bool CurrentSortSelectedIsDescending = false;

CollectionReference foodItems =
    FirebaseFirestore.instance.collection('foodItems');

String imageFile = 'assets/images/account.png';
