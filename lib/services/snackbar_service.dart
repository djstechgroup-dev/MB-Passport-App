import 'package:flutter/material.dart';

class ShowCustomSnackBar {
  Future<void> show(BuildContext context, String text) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}