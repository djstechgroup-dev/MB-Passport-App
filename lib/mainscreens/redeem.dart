import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class RedeemScreen extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;

  const RedeemScreen({Key? key,
    required this.setStateMain, required this.setImageURL, required this.setBusinessName,
  }) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    late Widget body;

    if(Attributes.savedDeals.isEmpty) {
      body = Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 15,
          ),
          child: Text(
            "You have not save any deals yet.",
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            _headings("Recently Saved"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth / 20),
                child: Row(
                  children: [

                  ],
                ),
              ),
            ),
            _headings("All Saved Deals"),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }

  Widget _headings(String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth / 20,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontSize: screenHeight / 25,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

}
