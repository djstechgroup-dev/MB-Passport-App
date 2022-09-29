import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/main_screen.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/model/weather.dart';
import 'package:passportapp/onboard_screen.dart';
import 'package:passportapp/services/auth_service.dart';
import 'package:passportapp/services/location_service.dart';
import 'package:passportapp/services/weather_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  WeatherService weatherService = WeatherService();
  Weather weather = const Weather();

  @override
  void initState() {
    super.initState();
    checkIfUserAvailable();
  }

  Future<void> getAttributesUser() async {
    setState(() {
    //   UserAttributes.favoriteBusiness = snap['favoriteBusiness'];
    //   UserAttributes.savedDeals = snap['savedDeals'];
    //   UserAttributes.offersRedeemed = snap['offersRedeemed'];
    //   UserAttributes.savingsEarned = snap['savingsEarned'];
      UserAttributes.profilePicURL = FirebaseAuth.instance.currentUser?.photoURL;
    });
    _navigateNext(const MainScreen());
  }

  Future<void> getWeather() async {
    weather = await weatherService.getData("33.699966477945296,-78.89252252946339");
    setState(() {
      Attributes.currentTemp = weather.temperature;
      Attributes.currentUV = weather.uvi;
      Attributes.currentPrecipitation = weather.rain * 10;
    });
    //Then get attribute user
    getAttributesUser();
  }

  void getCurrentLocationAndWeather() async {
    LocationService().getLatLong().then((value) {
      setState(() {
        Attributes.locationData = value!;
      });
      //Get weather after lat long
      getWeather();
    });
  }

  void checkIfUserAvailable() {
    AuthService().checkUserAvailable().then((value) async {
      if(value == true) {
        //Get current loc and weather first
        getCurrentLocationAndWeather();
      } else {
        //Directly to onboarding
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
