import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passportapp/main_screen.dart';
import 'package:passportapp/onboard_screen.dart';
import 'package:passportapp/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIfUserAvailable();
  }

  void checkIfUserAvailable() {
    AuthService().checkUserAvailable().then((value) async {
      if(value == true) {
        _navigateNext(const MainScreen());
      } else {
        _navigateNext(const OnBoardingScreen());
      }
    });
  }

  Future _navigateNext(Widget child) async {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => child,
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
