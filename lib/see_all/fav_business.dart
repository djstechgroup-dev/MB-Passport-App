import 'package:flutter/material.dart';

class SeeAllFavBusiness extends StatefulWidget {
  const SeeAllFavBusiness({Key? key}) : super(key: key);

  @override
  State<SeeAllFavBusiness> createState() => _SeeAllFavBusinessState();
}

class _SeeAllFavBusinessState extends State<SeeAllFavBusiness> {
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
            _headingText("Favorite Businesses"),
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
