import 'package:flutter/material.dart';

class AccountPreferences extends StatefulWidget {
  const AccountPreferences({Key? key}) : super(key: key);

  @override
  State<AccountPreferences> createState() => _AccountPreferencesState();
}

class _AccountPreferencesState extends State<AccountPreferences> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: screenWidth / 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }
}
