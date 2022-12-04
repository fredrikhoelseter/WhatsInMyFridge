import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:whats_in_my_fridge/utilities/validator.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';

class SearchBar extends StatefulWidget {
  TextEditingController searchBarController;
  final Function() notifyParent;

  SearchBar(
      {Key? key, required this.searchBarController, required this.notifyParent})
      : super(key: key);

  @override
  _searchBarState createState() => _searchBarState();
}

class _searchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchBarController,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
      onChanged: (String s) {
        SearchStringItemPage = s;
        widget.notifyParent();
      },
    );
  }
}
