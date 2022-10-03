import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  final ValueSetter setStateMain;
  const LearnScreen({Key? key, required this.setStateMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Learn How To Use Myrtle Beach Passport"),
      ),
    );
  }
}
