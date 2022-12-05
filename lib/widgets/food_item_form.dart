import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:whats_in_my_fridge/utilities/validator.dart';

class FoodItemForm extends StatefulWidget {
  User? user;
  CollectionReference foodItems;
  Widget? child;

  TextEditingController productNameController;
  TextEditingController productCategoryController;
  TextEditingController manufacturerController;
  TextEditingController dateInput;
  TextEditingController containerInput;
  static final ProductFormKey = GlobalKey<FormState>();

  FoodItemForm(
      {Key? key,
      this.child,
      this.user,
      required this.foodItems,
      required this.productNameController,
      required this.productCategoryController,
      required this.manufacturerController,
      required this.dateInput,
      required this.containerInput})
      : super(key: key);

  @override
  _foodItemFormState createState() => _foodItemFormState();
}

class _foodItemFormState extends State<FoodItemForm> {
  var foodCategories = ['Beverage', 'Dairy', 'Meats', 'Dry', 'Other'];

  var foodContainers = ['Fridge', 'Freezer', 'Other'];

  String searchString = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 30,
            bottom: MediaQuery.of(context).size.height * 0),
        child: Form(
          key: FoodItemForm.ProductFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: widget.productNameController,
                validator: (value) =>
                    Validator.validateProductField(field: value),
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  icon: Icon(Icons.calendar_today),
                ),
              ),
              TextFormField(
                controller: widget.manufacturerController,
                decoration: const InputDecoration(
                  labelText: 'Manufacturer',
                  icon: Icon(Icons.business_center_rounded),
                ),
              ),
              TextFormField(
                controller: widget.productCategoryController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Product Category',
                  icon: Icon(Icons.category_rounded),
                  suffixIcon: PopupMenuButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      widget.productCategoryController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return foodCategories
                          .map<PopupMenuItem<String>>((String value) {
                        return new PopupMenuItem(
                            child: new Text(value), value: value);
                      }).toList();
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: widget.containerInput,
                validator: (value) =>
                    Validator.validateContainer(container: value),
                decoration: InputDecoration(
                  labelText: 'Choose storage location',
                  icon: Icon(Icons.storage_rounded),
                  suffixIcon: PopupMenuButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      widget.containerInput.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return foodContainers
                          .map<PopupMenuItem<String>>((String value) {
                        return new PopupMenuItem(
                            child: new Text(value), value: value);
                      }).toList();
                    },
                  ),
                ),
                readOnly: true,
              ),
              TextFormField(
                controller: widget.dateInput,
                decoration: InputDecoration(
                  labelText: "Expiration Date",
                  icon: Icon(
                    Icons.alarm,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    print(pickedDate);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(formattedDate);

                    setState(() {
                      widget.dateInput.text = formattedDate;
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                child: Align(alignment: Alignment.center, child: widget.child),
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}
