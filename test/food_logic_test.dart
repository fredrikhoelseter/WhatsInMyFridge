import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/utilities/food_logic.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  test("Test expiration difference", () {
    var currentTime = DateTime.now();
    var expirationDateNow = currentTime.add(Duration(seconds: 1000));
    print(expirationDateNow.toString());
    expect(FoodLogic.expirationDifferenceInSeconds(expirationDateNow.toString()), 60*60*24-1+1000);
  });
}