import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:intl/intl.dart';
import 'package:whats_in_my_fridge/widgets/custom_appbar.dart';

class DataBaseTestPage extends StatefulWidget {
  static String routeName = '/databasetestpage';
  const DataBaseTestPage({Key? key}) : super(key: key);

  @override
  _DataBaseTestPageState createState() => _DataBaseTestPageState();
}

class _DataBaseTestPageState extends State<DataBaseTestPage> {
  User? user;
// text fields' controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _dateinput = TextEditingController();
  final TextEditingController _containerInput = TextEditingController();
  final TextEditingController _searchBarController = TextEditingController();

  final CollectionReference _foodItems =
      FirebaseFirestore.instance.collection('foodItems');

  // Needs to be initialized in firebase
  // Example categories
  var foodCategories = ['Beverage', 'Dairy', 'Meats', 'Dry', 'Other'];

  var foodContainers = ['Fridge', 'Freezer', 'Other'];

  var sortBy = ['Expiration Date', 'Product Name', 'Product Category'];

  String currentSort = "Expiration Date";

  bool isDescending = false;

  String containerString = "Fridge";
  String searchString = "";
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
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 30,
                bottom: MediaQuery.of(ctx).size.height * 0.15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                    ),
                    hintText: 'Search',
                    prefixIcon: Container(
                      padding: EdgeInsets.all(10),
                      child: const Icon(Icons.search),
                    )
                  ),
                ),
                const SizedBox(
                    height: 10,
                ),

                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: 'Product Name', icon: Icon(Icons.calendar_today),),
                ),

                TextField(
                  controller: _manufacturerController,
                  decoration: const InputDecoration(labelText: 'Manufacturer', icon: Icon(Icons.business_center_rounded),),
                ),

                TextField(
                  controller: _productCategoryController,
                  readOnly: true,
                  decoration:
                       InputDecoration(
                        labelText: 'Product Category',
                        icon: Icon(Icons.category_rounded),
                        suffixIcon: PopupMenuButton<String>(
                          icon:  Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            _productCategoryController.text = value;
                          },
                          itemBuilder: (BuildContext context) {
                            return foodCategories
                                .map<PopupMenuItem<String>>((String value) {
                                  return new PopupMenuItem(child: new Text(value), value: value);
                            }).toList();
                          },
                        ),
                      ),
                ),

                TextField(
                  controller: _containerInput,
                  decoration:
                  InputDecoration(
                    labelText: 'Choose storage location',
                    icon: Icon(Icons.storage_rounded),
                    suffixIcon: PopupMenuButton<String>(
                      icon:  Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        _containerInput.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return foodContainers
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  ),
                  readOnly: true,
                ),

                TextField(
                  controller: _dateinput,
                  decoration: InputDecoration(
                    labelText: "Expiration Date",
                    icon: Icon(Icons.alarm,),

                ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101)
                    );

                    if(pickedDate != null) {
                      print(pickedDate);
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);

                      setState(() {
                        _dateinput.text = formattedDate;
                      });
                    } else{
                      print("Date is not selected");
                    }
                  },
                ),

                const SizedBox(
                  height: 50,
                ),

                Container(
                  child: Align(alignment: Alignment.center,
                    child:
                    ElevatedButton(
                      child: const Text('Add product'),
                      onPressed: () async {
                        final String productName = _productNameController.text;
                        final String productCategory =
                            _productCategoryController.text;
                        final String manufacturer = _manufacturerController.text;
                        final String container = _containerInput.text;
                        final String expDate = _dateinput.text;

                        if (productName != null) {
                          await _foodItems.add({
                            "User ID": user?.uid,
                            "Product Name": productName,
                            "Product Category": productCategory,
                            "Manufacturer": manufacturer,
                            "Container": container,
                            "Expiration Date": expDate
                          });

                          _productNameController.text = '';
                          _productCategoryController.text = '';
                          _manufacturerController.text = '';
                          _containerInput.text = "";
                          _dateinput.text = "";

                          Navigator.of(context).pop();
                        }
                        },
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
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
          return Padding(
            padding: EdgeInsets.only(
                top: 0,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: _productCategoryController,
                  decoration:
                      const InputDecoration(labelText: 'Product Category'),
                ),
                TextField(
                  controller: _manufacturerController,
                  decoration: const InputDecoration(labelText: 'Manufacturer'),
                ),
                TextField(
                  controller: _containerInput,
                  decoration: const InputDecoration(labelText: 'Container'),
                ),
                TextField(
                  controller: _dateinput,
                  decoration: InputDecoration(
                    labelText: "Expiration Date",
                    icon: Icon(Icons.alarm,),

                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101)
                    );

                    if(pickedDate != null) {
                      print(pickedDate);
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);

                      setState(() {
                        _dateinput.text = formattedDate;
                      });
                    } else{
                      print("Date is not selected");
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String productName = _productNameController.text;
                    final String productCategory =
                        _productCategoryController.text;
                    final String manufacturer = _manufacturerController.text;
                    final String container = _containerInput.text;

                    if (productName != null) {
                      await _foodItems.doc(documentSnapshot!.id).update({
                        "Product Name": productName,
                        "Product Category": productCategory,
                        "Manufacturer": manufacturer,
                        "Container": container,
                      });

                      _productNameController.text = '';
                      _productCategoryController.text = '';
                      _manufacturerController.text = '';
                      _containerInput.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _foodItems.doc(productId).delete();


    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  Future<String?> getID() async {
    String? userID = await FireAuth.getCurrentUserID();
    return userID;
  }

  String id = "";

  void getIDAsString() async {

    id = (await getID())!;

  }

  /// Sets the containerString and hides the search bar and then
  /// calls set state. This changes the product content on the page.
  void setContainer(String string)
  {
    containerString = string;
    hideSearchBar();
    setState(() {

    });
  }

  /// Hides the searchBar. Needs a setState call to update in the UI.
  void hideSearchBar() {
    _search = false;
    _searchBarController.text = "";
  }
  
  Widget _buildSortDropDown() {
    return DropdownButton<String>(
      hint: Container(
        child:
        const Text('Sort by',
            style:
            TextStyle(
              color: Colors.white,
              fontSize: 20,
            )
        ),
      ),
      underline: Container(),
      icon: Icon(Icons.sort,color: Colors.white),
      items: sortBy.map((sort) => DropdownMenuItem(value: sort, child: Text(sort))).toList(),
      onChanged: (sort) => _sortSelected(sort),
    );
  }

  void _sortSelected(String? sort){

    if(currentSort == sort)
    {
      if (isDescending == false)
      {
        isDescending = true;
      }
      else
      {
        isDescending = false;
      }
    }
    else
    {
      currentSort = sort!;
    }

    setState(() {});
  }

  Widget _searchBar() { //add
    return TextField(
      controller: _searchBarController,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
      onChanged: (String s) {
        setState(() {
          searchString = s.toLowerCase();
        });
      },
    );
  }

  Widget _buildContainerButton(String containerName) {
    return ElevatedButton(onPressed: () => setContainer(containerName),
      style: ElevatedButton.styleFrom(
          side: BorderSide(width: 2.0, color: containerString == containerName ? Colors.green : Colors.white),
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),

          ),
          backgroundColor: containerString == containerName ? Colors.white : Colors.green
      ),
      child: Text(containerName,
        style: TextStyle(
          color: containerString == containerName ? Colors.green : Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: _search ? _searchBar() : Text("Storage"),
            actions: !_search
                ? [
              _buildSortDropDown(),
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
                    setState(() {

                    }),
                  }
              )
            ]
        ),

        body:
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Stack(
            children: <Widget> [
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
                stream: _foodItems.orderBy(currentSort, descending: isDescending).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  getIDAsString();
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                        return shouldProductShow(documentSnapshot) ? Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(documentSnapshot['Product Name']),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(documentSnapshot['Product Category']),

                                _buildExpirationMessage(documentSnapshot),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _update(documentSnapshot)),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _delete(documentSnapshot.id)),
                                ],
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
              ),]
          ),
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
    int day = 60*60*24;
    if (documentSnapshot["Expiration Date"].toString().isEmpty) {
      expirationMessage = "";
    } else if (secondsDifference < 0) {
      expirationMessage = "Expired: " + documentSnapshot["Expiration Date"];
    } else if (secondsDifference >= 0 && secondsDifference < day) {
      expirationMessage = "Expires today";
    } else if (secondsDifference >= day && secondsDifference < 2*day) {
      expirationMessage = "Expires tomorrow";
    } else if (secondsDifference >= 2*day && secondsDifference < 7*day) {
      expirationMessage = "Expires in " + (secondsDifference/day).round().toString() + " days";
    } else if (secondsDifference >= 7*day && secondsDifference < 14*day) {
      expirationMessage = "Expires in 1 week";
    } else if (secondsDifference >= 14*day && secondsDifference < 21*day) {
      expirationMessage = "Expires in 2 weeks";
    } else if (secondsDifference >= 21*day && secondsDifference < 28*day) {
      expirationMessage = "Expires in 3 weeks";
    } else {
      expirationMessage = "Expires in 1 month+";
    }

    if (secondsDifference <= 2*day) {
      expiredOrSoon = true;
    }

    return Text(
      expirationMessage,
      style: TextStyle(
        color: expiredOrSoon ? Colors.red : Colors.grey,
      ),
    );
  }


  int expirationDifferenceInSeconds(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot["Expiration Date"].toString().isEmpty) {
      return -1000000;
    }


    final DateTime currentTime = DateTime.now();
    DateTime expirationDate = DateTime.parse(documentSnapshot["Expiration Date"]);
    expirationDate = DateTime(
      expirationDate.year,
      expirationDate.month,
      expirationDate.day+1
    );

    Duration difference = expirationDate.difference(currentTime);

    return difference.inSeconds;
  }

  /// Checks whether a product in the document snapshot should be shown o the page.
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
    final List<String> searchKeywords = searchString.split(" ");
    final String productName = documentSnapshot['Product Name'].toString().toLowerCase();
    final String manufacturerName = documentSnapshot['Manufacturer'].toString().toLowerCase();
    int keywordMatchCount = 0;

    /// Iterates over all the keywords and increments a counter based on if the
    /// keyword matches the product name or manufacturer name.
    for (int i = 0; i < searchKeywords.length; i++) {
      if (productName.contains(searchKeywords[i]) || manufacturerName.contains(searchKeywords[i])) {
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
