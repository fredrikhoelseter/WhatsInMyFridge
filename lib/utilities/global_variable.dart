import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/screens/storage_page.dart';
import 'package:whats_in_my_fridge/screens/home_page.dart';
import 'package:whats_in_my_fridge/screens/settings_page.dart';

import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';


List<Widget> homeScreenItems = [];

String SearchStringItemPage = "";

String CurrentStringSortSelected = "Expiration Date";

bool CurrentSortSelectedIsDescending = false;

CollectionReference foodItems = FirebaseFirestore.instance.collection('foodItems');