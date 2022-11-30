import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import 'package:whats_in_my_fridge/widgets/appbar_buttons.dart';
import 'package:intl/intl.dart';

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

  final CollectionReference _foodItems =
      FirebaseFirestore.instance.collection('foodItems');

  // Needs to be initialized in firebase
  // Example categories
  var foodCategories = ['Beverage', 'Dairy', 'Meats', 'Dry', 'Other'];

  var foodContainers = ['Fridge', 'Freezer', 'Other'];

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
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
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
                    height: 25,
                ),

                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: 'Product Name', icon: Icon(Icons.calendar_today),),
                ),
                TextField(
                  controller: _productCategoryController,
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
                  controller: _manufacturerController,
                  decoration: const InputDecoration(labelText: 'Manufacturer', icon: Icon(Icons.business_center_rounded),),
                ),
                TextField(
                  controller: _dateinput,
                  decoration: InputDecoration(
                    labelText: "Enter expiration date",
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
                ),


                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String productName = _productNameController.text;
                    final String productCategory =
                        _productCategoryController.text;
                    final String manufacturer = _manufacturerController.text;

                    if (productName != null) {
                      await _foodItems.add({
                        "User ID": user?.uid,
                        "Product Name": productName,
                        "Product Category": productCategory,
                        "Manufacturer": manufacturer
                      });

                      _productNameController.text = '';
                      _productCategoryController.text = '';
                      _manufacturerController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
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
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
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

                    if (productName != null) {
                      await _foodItems.doc(documentSnapshot!.id).update({
                        "Product Name": productName,
                        "Product Category": productCategory,
                        "Manufacturer": manufacturer
                      });
                      _productNameController.text = '';
                      _productCategoryController.text = '';
                      _manufacturerController.text = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Database Test Page')),
        ),
        body: StreamBuilder(
          stream: _foodItems.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            getIDAsString();
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  return (documentSnapshot['User ID'] == id) ? Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['Product Name']),
                      subtitle: Text(documentSnapshot['Product Category']),
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
// Add new product
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
