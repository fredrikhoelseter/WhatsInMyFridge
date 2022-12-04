import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:intl/intl.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';
import 'package:whats_in_my_fridge/widgets/food_item_form.dart';
import 'package:whats_in_my_fridge/widgets/search_bar.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';
import 'package:whats_in_my_fridge/widgets/sort_selector.dart';

class StoragePage extends StatefulWidget {
  static String routeName = '/storagePage';
  const StoragePage({Key? key}) : super(key: key);

  @override
  _storagePageState createState() => _storagePageState();
}

class _storagePageState extends State<StoragePage> {
  User? user;
// text fields' controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCategoryController =
      TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _dateinput = TextEditingController();
  final TextEditingController _containerInput = TextEditingController();
  final TextEditingController _searchBarController = TextEditingController();

  // Needs to be initialized in firebase
  // Example categories
  var foodCategories = ['Beverage', 'Dairy', 'Meats', 'Dry', 'Other'];

  var foodContainers = ['Fridge', 'Freezer', 'Other'];

  String containerString = "Fridge";

  void refresh() {
    setState(() {});
  }

  bool _search = false;

  @override
  void initState() {
    _dateinput.text = "";
    super.initState();
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    user = await FireAuth.getCurrentUser();
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return FoodItemForm(
            foodItems: foodItems,
            user: user,
            productNameController: _productNameController,
            productCategoryController: _productCategoryController,
            manufacturerController: _manufacturerController,
            dateInput: _dateinput,
            containerInput: _containerInput,
            child: ElevatedButton(
              child: const Text('Add product'),
              onPressed: () async {
                final String productName = _productNameController.text;
                final String productCategory = _productCategoryController.text;
                final String manufacturer = _manufacturerController.text;
                final String container = _containerInput.text;
                final String expDate = _dateinput.text;

                if (FoodItemForm.ProductFormKey.currentState!.validate()) {
                  await foodItems.add({
                    "User ID": user?.uid,
                    "Product Name": productName,
                    "Product Category": productCategory,
                    "Manufacturer": manufacturer,
                    "Container": container,
                    "Expiration Date": expDate
                  });

                  resetTextFields();

                  Navigator.of(context).pop();
                }
              },
            ),
          );
        }).whenComplete(() => {resetTextFields()});
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _productNameController.text = documentSnapshot['Product Name'];
      _productCategoryController.text = documentSnapshot['Product Category'];
      _manufacturerController.text = documentSnapshot['Manufacturer'];
      _containerInput.text = documentSnapshot['Container'];
      _dateinput.text = documentSnapshot['Expiration Date'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return FoodItemForm(
            foodItems: foodItems,
            user: user,
            productNameController: _productNameController,
            productCategoryController: _productCategoryController,
            manufacturerController: _manufacturerController,
            dateInput: _dateinput,
            containerInput: _containerInput,
            child: ElevatedButton(
              child: const Text('Update'),
              onPressed: () async {
                final String productName = _productNameController.text;
                final String productCategory = _productCategoryController.text;
                final String manufacturer = _manufacturerController.text;
                final String container = _containerInput.text;
                final String date = _dateinput.text;
                if (FoodItemForm.ProductFormKey.currentState!.validate()) {
                  await foodItems.doc(documentSnapshot!.id).update({
                    "Product Name": productName,
                    "Product Category": productCategory,
                    "Manufacturer": manufacturer,
                    "Container": container,
                    "Expiration Date": date,
                  });

                  resetTextFields();

                  Navigator.of(context).pop();
                }
              },
            ),
          );
        }).whenComplete(() => resetTextFields());
  }

  Future<void> _delete(String productId) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).size.height * 0.15),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to delete this item?",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      foodItems.doc(productId).delete();
                      Navigator.of(context).pop();
                    },
                    child: Text("Delete"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                  )
                ]),
          );
        });

    //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //    content: Text('You have successfully deleted a product')));
  }

  Future<String?> getID() async {
    String? userID = await FireAuth.getCurrentUserID();
    return userID;
  }

  String id = "";

  void getIDAsString() async {
    id = (await getID())!;
  }

  void resetTextFields() {
    _productNameController.text = '';
    _productCategoryController.text = '';
    _manufacturerController.text = '';
    _containerInput.text = "";
    _dateinput.text = "";
  }

  /// Sets the containerString and hides the search bar and then
  /// calls set state. This changes the product content on the page.
  void setContainer(String string) {
    containerString = string;
    hideSearchBar();
    setState(() {});
  }

  /// Hides the searchBar. Needs a setState call to update in the UI.
  void hideSearchBar() {
    _search = false;
    _searchBarController.text = "";
  }

  Widget _buildContainerButton(String containerName) {
    return ElevatedButton(
      onPressed: () => setContainer(containerName),
      style: ElevatedButton.styleFrom(
          side: BorderSide(
              width: 2.0,
              color: containerString == containerName
                  ? Colors.green
                  : Colors.white),
          padding: const EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:
              containerString == containerName ? Colors.white : Colors.green),
      child: Text(
        containerName,
        style: TextStyle(
          fontFamily: GoogleFonts.openSans().fontFamily,
          color: containerString == containerName ? Colors.green : Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SearchBar searchBar = SearchBar(
        searchBarController: _searchBarController, notifyParent: refresh);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: _search
                ? searchBar
                : Text(
                    "Storage",
                    style: GoogleFonts.openSans(),
                  ),
            actions: !_search
                ? [
                    SortSelector(
                      notifyParent: refresh,
                    ),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _search = true;
                          });
                        }),
                  ]
                : [
                    IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => {
                              hideSearchBar(),
                              setState(() {}),
                            })
                  ]),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildContainerButton("Fridge"),
                  ),
                  Expanded(
                    child: _buildContainerButton("Freezer"),
                  ),
                  Expanded(
                    child: _buildContainerButton("Other"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75),
              child: StreamBuilder(
                stream: foodItems
                    .orderBy(CurrentStringSortSelected,
                        descending: CurrentSortSelectedIsDescending)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  getIDAsString();
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];

                        return shouldProductShow(documentSnapshot)
                            ? Card(
                                margin: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onLongPress: () => _update(documentSnapshot),
                                  child: ListTile(
                                    title:
                                        Text(documentSnapshot['Product Name']),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(documentSnapshot[
                                            'Product Category']),
                                        _buildExpirationMessage(
                                            documentSnapshot),
                                      ],
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: const Icon(
                                                Icons.edit_note,
                                                color: Colors.lightBlueAccent,
                                                size: 35,
                                              ),
                                              onPressed: () =>
                                                  _update(documentSnapshot)),
                                          IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 35,
                                              ),
                                              onPressed: () =>
                                                  _delete(documentSnapshot.id)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox();
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ]),
        ),
// Add new product
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget _buildExpirationMessage(DocumentSnapshot documentSnapshot) {
    int secondsDifference = expirationDifferenceInSeconds(documentSnapshot);
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
        color: expiredOrSoon ? Colors.red : Colors.grey,
      ),
    );
  }

  /// Parses the documentSnapshot of the expiration date to a DateTime
  /// and returns the difference from the current time in seconds.
  /// Prone to error if the documentSnapshot has an invalid date format,
  int expirationDifferenceInSeconds(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot["Expiration Date"].toString().isEmpty) {
      return 1000000;
    }

    try {
      final DateTime currentTime = DateTime.now();
      DateTime expirationDate =
          DateTime.parse(documentSnapshot["Expiration Date"]);
      expirationDate = DateTime(
          expirationDate.year, expirationDate.month, expirationDate.day + 1);

      Duration difference = expirationDate.difference(currentTime);

      return difference.inSeconds;
    } catch (e) {
      print("The expiration date was in an invalid format. " + e.toString());
      return 1000000;
    }
  }

  /// Checks whether a product in the document snapshot should be shown on the page.
  /// The document snapshot needs to have fields with these exact names 'User ID',
  /// 'Container', 'Product Name', 'Manufacturer'
  bool shouldProductShow(DocumentSnapshot documentSnapshot) {
    /// If the product UID does not match the user UID, returns false
    if (documentSnapshot['User ID'] != id) {
      return false;
    }

    /// If the user is not searching and the containerString matches
    /// the product container name, return true
    if (documentSnapshot['Container'] == containerString && !_search) {
      return true;
    }

    /// If the user is not searching, returns false.
    if (!_search) {
      return false;
    }

    /// Split the search up into keywords based on spacing.
    final List<String> searchKeywords = SearchStringItemPage.split(" ");
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
}
