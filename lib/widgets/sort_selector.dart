import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';

class SortSelector extends StatefulWidget {

  ///List of fields user can sort by.
  static const List<String> sortBy = [
    'Expiration Date',
    'Product Name',
    'Product Category'
  ];

  final Function() notifyParent;

  const SortSelector({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<SortSelector> createState() => _SortSelectorState();
}

class _SortSelectorState extends State<SortSelector> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(),
      icon: const Icon(Icons.sort, color: Colors.white),
      items: SortSelector.sortBy
          .map((sort) => DropdownMenuItem(value: sort, child: Text(sort)))
          .toList(),
      onChanged: (sort) => _sortSelected(sort), ///When selected sort is changed will call _sortSelected method
    );
  }

  ///Sets the Firestore field to sort after
  void _sortSelected(String? sort) {

    ///If the selected sort is the same as what it currently is set as,
    ///then will change if the sort is descending or ascending
    if (CurrentStringSortSelected == sort) {
      print("Sort is the same");

      ///Switches isDescending
      if (CurrentSortSelectedIsDescending == false) {
        CurrentSortSelectedIsDescending = true;
        widget.notifyParent();
      } else {
        CurrentSortSelectedIsDescending = false;
        widget.notifyParent();
      }
    } else {
      print("Sort is not the same");

      ///If selected sort is not the same as what it currently is set as,
      ///sets the sort to the selected sort and resets  isDescending to false
      CurrentSortSelectedIsDescending = false;
      CurrentStringSortSelected = sort!;
      widget.notifyParent();
    }
  }
}
