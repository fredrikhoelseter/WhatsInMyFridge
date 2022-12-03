import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/utilities/global_variable.dart';

class SortSelector extends StatefulWidget {


  static const List<String> sortBy = ['Expiration Date', 'Product Name', 'Product Category'];

  final Function() notifyParent;

  const SortSelector({Key? key, required this.notifyParent}) : super(key: key);


  @override
  State<SortSelector> createState() => _SortSelectorState();
}



class _SortSelectorState extends State<SortSelector> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('Sort by',
          style:
          TextStyle(
            color: Colors.white,
            fontSize: 20,
          )
      ),
      underline: Container(),
      icon: const Icon(Icons.sort, color: Colors.white),
      items: SortSelector.sortBy.map((sort) =>
          DropdownMenuItem(value: sort, child: Text(sort))).toList(),
      onChanged: (sort) => _sortSelected(sort),
    );
  }


  void _sortSelected(String? sort) {
    print("I get here when you press me");

    if (CurrentStringSortSelected == sort) {
      print("Sort is the same");

      if (CurrentSortSelectedIsDescending == false) {
        CurrentSortSelectedIsDescending = true;
        widget.notifyParent();
      }
      else {
        CurrentSortSelectedIsDescending = false;
        widget.notifyParent();
      }
    }
    else {
      print("Sort is not the same");

      CurrentStringSortSelected = sort!;
      widget.notifyParent();
    }
  }
}