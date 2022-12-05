import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';


/// Static functions for food items/ products.
class FoodLogic {

  /// Checks whether a product in the document snapshot should be shown on the page.
  /// The document snapshot needs to have fields with these exact names 'User ID',
  /// 'Container', 'Product Name', 'Manufacturer'
  static bool shouldProductShow(DocumentSnapshot documentSnapshot, bool search,
      String containerString, String id) {
    /// If the product UID does not match the user UID, returns false
    if (documentSnapshot['User ID'] != id) {
      return false;
    }

    /// If the user is not searching and the containerString matches
    /// the product container name, return true
    if (documentSnapshot['Container'] == containerString && !search) {
      return true;
    }

    /// If the user is not searching, returns false.
    if (!search) {
      return false;
    }

    /// Split the search up into keywords based on spacing.
    final List<String> searchKeywords = SearchStringItemPage.toLowerCase().split(" ");
    final String productName =
    documentSnapshot['Product Name'].toString().toLowerCase();
    final String manufacturerName =
    documentSnapshot['Manufacturer'].toString().toLowerCase();
    int keywordMatchCount = 0;

    /// Iterates over all the keywords and increments a counter based on if the
    /// keyword matches the product name or manufacturer name.
    for (int i = 0; i < searchKeywords.length; i++) {
      if (productName.contains(searchKeywords[i]) ||
          manufacturerName.contains(searchKeywords[i])) {
        keywordMatchCount++;
      }
    }

    /// If the keywordMatchCount matches (or is greater than) the length of the
    /// keywords, returns true.
    if (keywordMatchCount >= searchKeywords.length) {
      return true;
    }

    return false;
  }

  /// Parses the expirationDateString to a DateTime
  /// and returns the difference from the current time in seconds.
  /// Prone to error if the expirationDateString has an invalid date format,
  static int expirationDifferenceInSeconds(String expirationDateString) {
    if (expirationDateString.isEmpty) {
      return 0;
    }

    try {
      final DateTime currentTime = DateTime.now();
      DateTime expirationDate =
      DateTime.parse(expirationDateString);
      expirationDate = DateTime(
          expirationDate.year, expirationDate.month, expirationDate.day + 1,
      expirationDate.hour, expirationDate.minute, expirationDate.second);

      Duration difference = expirationDate.difference(currentTime);

      return difference.inSeconds;
    } catch (e) {
      print("The expiration date was in an invalid format. " + e.toString());
      return 0;
    }
  }
}