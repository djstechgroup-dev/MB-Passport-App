import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class HomeScreen extends StatefulWidget {
  final ValueSetter setStateAppBar;
  const HomeScreen({Key? key, required this.setStateAppBar}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 70,),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 35,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: screenHeight / 4.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today in Myrtle Beach",
                            style: TextStyle(
                              fontFamily: "Actor",
                              fontSize: screenHeight / 45,
                              color: Attributes.blue,
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/weather_sunny.png",
                                width: screenWidth / 8,
                              ),
                              Text(
                                "70°F°C\nPrecipitation: 2%\nSun Index 5.5",
                                style: TextStyle(
                                  fontFamily: "Actor",
                                  fontSize: screenHeight / 45,
                                  color: Attributes.blue,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8,),
                          _stats(0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: SizedBox(
                      height: screenHeight / 4.8,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good\nMorning!",
                                style: TextStyle(
                                  fontFamily: "Actor",
                                  fontSize: screenHeight / 45,
                                ),
                              ),
                              Text(
                                Attributes.username,
                                style: TextStyle(
                                  fontFamily: "Actor",
                                  fontSize: screenHeight / 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _stats(2),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, 10),
                            child: SizedBox(
                              height: screenWidth / 4,
                              width: screenWidth / 4,
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/profilePic.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 20,
                vertical: screenHeight / 35,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shortcuts("Dining"),
                  _shortcuts("Category"),
                  _shortcuts("Near Me"),
                  _shortcuts("Most Popular"),
                ],
              ),
            ),
            _heading("Offers Near Me"),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 50,
                bottom: screenHeight / 50,
                left: screenWidth / 20,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _offer(
                      "img_alabama",
                      "Alabama Theatre",
                      "Entertainment",
                      "3-5 miles",
                      23,
                      2,
                      "\$5 OFF the price of admission",
                    ),
                    const SizedBox(width: 16,),
                    _offer(
                      "img_jurassic",
                      "Jurassic Mini Golf",
                      "Attraction",
                      "3-5 miles",
                      56,
                      5,
                      "Free Drinks with purchase of a round",
                    ),
                    const SizedBox(width: 16,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Favorite Business",
                    style: TextStyle(
                      fontFamily: "Actor",
                      fontSize: screenHeight / 35,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  _underlineText("See All"),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 50,
                bottom: screenHeight / 50,
                left: screenWidth / 20,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _imageClip("pizza2"),
                    const SizedBox(width: 16,),
                    _imageClip("pizza1"),
                    const SizedBox(width: 16,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heading(String text) {
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

  Widget _offer(String image, String title, String label1, String label2, int used, int remaining, String bonus) {
    return Column(
      children: [
        _imageClip(image),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 40,
            ),
          ),
        ),
        Row(
          children: [
            _labelOffers(0, label1),
            const SizedBox(width: 8,),
            _labelOffers(1, label2),
          ],
        ),
        Container(
            height: screenHeight / 35,
            margin: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            padding: const EdgeInsets.only(
              top: 2,
              left: 15,
              right: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Attributes.lightBlue,
            ),
            child: RichText(
              text: TextSpan(
                  text: "Used $used times today, ",
                  children: [
                    TextSpan(
                      text: "$remaining remaining",
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    fontFamily: "Actor",
                    color: Attributes.blue,
                  )
              ),
            )
        ),
        DottedBorder(
          dashPattern: const [6, 3, 6, 3],
          child: Container(
            height: screenHeight / 16,
            width: screenWidth / 1.6,
            decoration: BoxDecoration(
              color: Attributes.yellow,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                bonus,
                style: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 50,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageClip(String image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          "assets/images/$image.png",
          fit: BoxFit.fitHeight,
          width: screenWidth / 1.6,
        ),
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

  Widget _labelOffers(int options, String text) {
    return Container(
      height: screenHeight / 35,
      padding: EdgeInsets.only(
        top: options == 0 ? 2 : 0,
        bottom: options == 0 ? 4 : 0,
        left: 15,
        right: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: options == 0 ? const Color(0xFFE1EAFC) : Colors.white,
        border: Border.all(color: options != 0 ? Colors.black54 : const Color(0xFFE1EAFC)),
      ),
      child: Center(
        child: options == 0 ? Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            color: Attributes.blue,
          ),
        ) : Row(
          children: [
            Image.asset(
              "assets/images/pinLocation.png",
              height: 14,
            ),
            Transform.translate(
              offset: const Offset(8, -1),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: "Actor",
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _shortcuts(String text) {
    return Container(
      height: screenHeight / 22,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 25,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color(0xFFEFEFEF),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 55,
          ),
        ),
      ),
    );
  }

  Widget _stats(int options) {
    return Container(
      height: screenHeight / 13,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: options == 0 ? Attributes.lightBlue : Attributes.yellow,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, options == 0 ? -8 : -2),
                child: Text(
                  options == 0 ? Attributes.offersRedeemed.toString()
                      : "\$${Attributes.earnedSavings}",
                  style: TextStyle(
                    fontFamily: "Actor",
                    fontSize: options == 0 ? screenHeight / 15 : screenHeight / 20,
                    color: options == 0 ? Attributes.blue : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(options == 0 ? -5 : 10, options == 0 ? 0 : 5),
                child: Text(
                  options == 0 ? (Attributes.offersRedeemed > 1 ? "Offers\nRedeemed" : "Offer\nRedeemed")
                      : (Attributes.earnedSavings > 1 ? "Savings\nEarned" : "Saving\nEarned"),
                  style: TextStyle(
                    fontFamily: "Actor",
                    fontSize: options == 0 ? screenHeight / 45 : screenHeight / 55,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
