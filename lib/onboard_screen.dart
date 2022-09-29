import 'package:passportapp/model/weather.dart';
import 'package:passportapp/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/main_screen.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/services/auth_service.dart';
import 'package:passportapp/services/dialog_service.dart';
import 'package:passportapp/services/location_service.dart';
import 'package:passportapp/services/snackbar_service.dart';
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<UserData> userData = [];
  late SharedPreferences prefs;
  double screenWidth = 0;
  double screenHeight = 0;
  int screenState = 0;
  late BuildContext dialogContext;

  WeatherService weatherService = WeatherService();
  Weather weather = const Weather();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getAttributesUser() async {
    // DocumentSnapshot snap = await FirebaseFirestore.instance
    //     .collection("Users")
    //     .doc(FirebaseAuth.instance.currentUser?.uid)
    //     .get();
    //
    setState(() {
      //   UserAttributes.favoriteBusiness = snap['favoriteBusiness'];
      //   UserAttributes.savedDeals = snap['savedDeals'];
      //   UserAttributes.offersRedeemed = snap['offersRedeemed'];
      //   UserAttributes.savingsEarned = snap['savingsEarned'];
      UserAttributes.profilePicURL = FirebaseAuth.instance.currentUser?.photoURL;
    });
    goToMain();
  }

  void goToMain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    late Widget body;

    switch(screenState) {
      case 0:
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bigImage("logo.png", screenWidth / 1.5),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                try {
                  User? user;
                  AuthService().googleSignIn().then((value) async {
                    user = value;

                    var userToken = await user?.getIdTokenResult();
                    AuthService().getUserToken(user?.email, userToken?.token);

                    AuthService().saveUserData(user, userToken?.token);

                    setState(() {
                      screenState = 1;
                    });

                    showDialog(
                      context: context,
                      builder: (BuildContext dialog) {
                        dialogContext = dialog;
                        return CustomDialog(
                          title: "Congratulations",
                          description: "Log in success! You are now a customer!",
                          buttonText: "Continue",
                          tapFunction: () {
                            Feedback.forTap(context);
                            Navigator.pop(dialogContext);
                          },
                        );
                      },
                    );
                  });
                } catch(e) {
                  ShowCustomSnackBar().show(context, "Failed.");
                }
              },
              child: _button("googleIcon.png", "Continue with Google"),
            ),
            SizedBox(height: screenHeight / 20,),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                setState(() {
                  screenState = 1;
                });
              },
              child: _button("appleIcon.png", "Continue with Apple"),
            ),
            SizedBox(height: screenHeight / 30,),
            _text3("Please use one of the available options to create an account"),
          ],
        );
        break;
      case 1:
        body = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _text1("Location Services"),
            _text2("Myrtle Beach Passport is designed to use your location to enhance your experience.",),
            _bigImage("locationOnBoard.png", screenWidth / 2.3),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                try {
                  getCurrentLocationAndWeather();
                } catch(e) {
                  ShowCustomSnackBar().show(context, "Something is wrong!");
                }
              },
              child: _button("n", "Enable Location"),
            ),
            SizedBox(height: screenHeight / 23,),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                getWeather();
              },
              child: _underlineText("Skip this step"),
            ),
            SizedBox(height: screenHeight / 23,),
            _text3("Location settings can always be modified within the app"),
          ],
        );
        break;
      default:
        body = Container();
        break;
    }
    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        child: body,
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
        ),
      ),
    );
  }

  Widget _bigImage(String asset, double width) {
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight / 12,
        bottom: screenHeight / 20,
      ),
      child: Image.asset(
        "assets/images/$asset",
        width: width,
      ),
    );
  }

  Widget _text1(String text) {
    return Container(
      width: screenWidth / 1.5,
      margin: EdgeInsets.only(top: screenHeight / 12),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontWeight: FontWeight.w400,
          fontSize: screenHeight / 22,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _text2(String text) {
    return Container(
      width: screenWidth / 1.5,
      margin: EdgeInsets.only(top: screenHeight / 30),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontWeight: FontWeight.w400,
          color: Colors.black54,
          fontSize: screenHeight / 45,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _text3(String text) {
    return Container(
      width: screenWidth / 1.5,
      margin: EdgeInsets.only(bottom: screenHeight / 22),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Actor",
          fontWeight: FontWeight.w400,
          color: Colors.black54,
          fontSize: screenHeight / 49.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _underlineText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontWeight: FontWeight.w400,
        fontSize: screenHeight / 49.5,
        decoration: TextDecoration.underline,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _button(String asset, String text) {
    return Container(
      height: 70,
      width: screenWidth / 1.5,
      decoration: BoxDecoration(
        color: Attributes.blue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 1,
          ),
        ],
      ),
      child: asset != "n" ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth / 5.9,
            child: Center(
              child: Image.asset("assets/images/$asset"),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: "Actor",
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: screenHeight / 49.5,
            ),
          ),
        ],
      ) : Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: screenHeight / 45,
          ),
        ),
      ),
    );
  }
}
