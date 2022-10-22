import 'package:flutter/material.dart';

class AccountDealsHistory extends StatefulWidget {
  const AccountDealsHistory({Key? key}) : super(key: key);

  @override
  State<AccountDealsHistory> createState() => _AccountDealsHistoryState();
}

class _AccountDealsHistoryState extends State<AccountDealsHistory> {
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
            _headingText("Deal History"),
          ],
        ),
      ),
    );
  }

  Widget _headingText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontSize: screenHeight / 35,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    );
  }
}
