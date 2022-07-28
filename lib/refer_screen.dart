import 'package:flutter/material.dart';

class ReferScreen extends StatelessWidget {
  final ValueSetter setStateMain;
  const ReferScreen({Key? key, required this.setStateMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Refer a Friend"),
      ),
    );
  }
}
