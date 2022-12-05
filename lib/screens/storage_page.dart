import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/widgets/food_item_form.dart';
import 'package:whats_in_my_fridge/widgets/search_bar.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';
import 'package:whats_in_my_fridge/widgets/sort_selector.dart';
import 'package:whats_in_my_fridge/utilities/food_logic.dart';
import 'package:whats_in_my_fridge/widgets/expiration_date_message.dart';

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

  /// Shows the modal create food item form page.
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    user = await FireAuth.getCurrentUser();
    _containerInput.text = containerString;
    await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext ctx) {
              return FoodItemForm(
                productNameController: _productNameController,
                productCategoryController: _productCategoryController,
                manufacturerController: _manufacturerController,
                dateInput: _dateinput,
                containerInput: _containerInput,
                child: ElevatedButton(
                  child: const Text('Add product'),
                  onPressed: () async {
                    final String productName = _productNameController.text;
                    final String productCategory =
                        _productCategoryController.text;
                    final String manufacturer = _manufacturerController.text;
                    final String container = _containerInput.text;
                    final String expDate = _dateinput.text;

                    /// If food item form fields are valid, create a new product
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
            })
        .whenComplete(() =>
            {resetTextFields()}); // When closing the modal, reset the fields
  }

  /// Shows the update food item form page.
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
                productNameController: _productNameController,
                productCategoryController: _productCategoryController,
                manufacturerController: _manufacturerController,
                dateInput: _dateinput,
                containerInput: _containerInput,
                child: ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String productName = _productNameController.text;
                    final String productCategory =
                        _productCategoryController.text;
                    final String manufacturer = _manufacturerController.text;
                    final String container = _containerInput.text;
                    final String date = _dateinput.text;

                    /// If food item form fields are valid, update the product.
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
            })
        .whenComplete(() =>
            resetTextFields()); // When closing the modal, reset the fields
  }

  /// Show the delete item modal page.
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

    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('You have successfully deleted a product')));
  }

  Future<String?> getID() async {
    String? userID = await FireAuth.getCurrentUserID();
    return userID;
  }

  String id = "";

  void getIDAsString() async {
    id = (await getID())!;
  }

  /// Resets the text fields for the product modal page.
  void resetTextFields() {
    _productNameController.text = '';
    _productCategoryController.text = '';
    _manufacturerController.text = '';
    _containerInput.text = "";
    _dateinput.text = "";
  }

  /// Sets the containerString and hides the search bar and then
  /// calls refresh. This changes the product content on the page.
  void setContainer(String string) {
    containerString = string;
    hideSearchBar();
    refresh();
  }

  /// Hides the searchBar. Needs a setState call to update in the UI.
  void hideSearchBar() {
    _search = false;
    _searchBarController.text = "";
  }

  Widget _buildContainerButton(String containerName, double textSize) {
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
          fontSize: textSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SearchBar searchBar = SearchBar(
        searchBarController: _searchBarController, notifyParent: refresh);
    return LayoutBuilder(
      builder: (buildContext, boxConstraints) {
        double expTextSize = 13.0;
        double containerButtonTextSize = 24.0;
        double iconSize = 35.0;

        if (boxConstraints.maxWidth < 400) {
          expTextSize = 10.0;
          containerButtonTextSize = 16.0;
          iconSize = 25.0;
        }

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
                              _search = true;
                              refresh();
                            }),
                      ]
                    : [
                        IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => {
                                  hideSearchBar(),
                                  refresh(),
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
                        child: _buildContainerButton(
                            "Fridge", containerButtonTextSize),
                      ),
                      Expanded(
                        child: _buildContainerButton(
                            "Freezer", containerButtonTextSize),
                      ),
                      Expanded(
                        child: _buildContainerButton(
                            "Other", containerButtonTextSize),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 75),
                  child: StreamBuilder(
                    stream: foodItems
                        .orderBy(CurrentStringSortSelected,

                            /// Order the collection
                            descending: CurrentSortSelectedIsDescending)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      getIDAsString(); // Make sure the id is set
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            /// Shows the product or an empty SizedBox
                            return FoodLogic.shouldProductShow(documentSnapshot,
                                    _search, containerString, id)
                                ? Card(
                                    margin: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onLongPress: () =>
                                          _update(documentSnapshot),
                                      child: ListTile(
                                        title: Text(
                                            documentSnapshot['Product Name']),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(documentSnapshot[
                                                'Product Category']),
                                            ExpirationDateMessage(
                                              documentSnapshot:
                                                  documentSnapshot,
                                              fontSize: expTextSize,
                                            ),
                                          ],
                                        ),
                                        trailing: SizedBox(
                                          width: 100,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.edit_note,
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    size: iconSize,
                                                  ),
                                                  onPressed: () => _update(
                                                      documentSnapshot)),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: iconSize,
                                                  ),
                                                  onPressed: () => _delete(
                                                      documentSnapshot.id)),
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
            floatingActionButton: boxConstraints.maxWidth >= 400
                ? FloatingActionButton.large(
                    onPressed: () => _create(),
                    child: const Icon(Icons.add),
                  )
                : FloatingActionButton(
                    onPressed: () => _create(),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat);
      },
    );
  }
}
