import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passportapp/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future _navigateNext() async {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const OnBoardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: screenWidth / 2,
        ),
      ),
    );
  }
}
