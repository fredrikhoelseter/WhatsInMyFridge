import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 24.0,
        ),
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }
}
