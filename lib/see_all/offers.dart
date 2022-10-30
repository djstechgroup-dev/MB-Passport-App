import 'package:flutter/material.dart';

class SeeAllOffers extends StatefulWidget {
  const SeeAllOffers({Key? key}) : super(key: key);

  @override
  State<SeeAllOffers> createState() => _SeeAllOffersState();
}

class _SeeAllOffersState extends State<SeeAllOffers> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Column(
          children: [
            _headingText("Offers Near Me"),
          ],
        ),
      ),
    );
  }

  Widget _headingText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 20,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontSize: screenHeight / 35,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
