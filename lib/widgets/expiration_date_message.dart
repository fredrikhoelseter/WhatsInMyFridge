import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';
import 'package:whats_in_my_fridge/utilities/food_logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ExpirationDateMessage extends StatelessWidget {

  DocumentSnapshot documentSnapshot;
  double fontSize;
  ExpirationDateMessage({Key? key, required this.documentSnapshot,
    required this.fontSize}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    int secondsDifference = FoodLogic.expirationDifferenceInSeconds(documentSnapshot);
    String expirationMessage = "";
    bool expiredOrSoon = false;
    int day = 60 * 60 * 24;
    if (documentSnapshot["Expiration Date"].toString().isEmpty) {
      expirationMessage = "";
    } else if (secondsDifference < 0) {
      expirationMessage = "Expired: " + documentSnapshot["Expiration Date"];
    } else if (secondsDifference >= 0 && secondsDifference < day) {
      expirationMessage = "Expires today";
    } else if (secondsDifference >= day && secondsDifference < 2 * day) {
      expirationMessage = "Expires tomorrow";
    } else if (secondsDifference >= 2 * day && secondsDifference < 7 * day) {
      expirationMessage = "Expires in " +
          (secondsDifference / day).round().toString() +
          " days";
    } else if (secondsDifference >= 7 * day && secondsDifference < 14 * day) {
      expirationMessage = "Expires in 1 week";
    } else if (secondsDifference >= 14 * day && secondsDifference < 21 * day) {
      expirationMessage = "Expires in 2 weeks";
    } else if (secondsDifference >= 21 * day && secondsDifference < 28 * day) {
      expirationMessage = "Expires in 3 weeks";
    } else {
      expirationMessage = "Expires in 1 month+";
    }

    if (secondsDifference <= 2 * day) {
      expiredOrSoon = true;
    }
    return Text(
      expirationMessage,
      style: TextStyle(
        fontSize: fontSize,
        color: expiredOrSoon ? Colors.red : Colors.grey,
      ),
    );
  }
}
