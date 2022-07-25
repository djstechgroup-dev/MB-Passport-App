import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';

class HomeScreen extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setStateSearch;
  const HomeScreen({Key? key, required this.setStateMain, required this.setStateSearch}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    if(Attributes.offersRedeemed == -1) {
      getData();
    }
  }

  void getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user?.uid)
        .get();

    setState(() {
      Attributes.offersRedeemed = snap['redeemed'];
      Attributes.earnedSavings = snap['savings'];
      Attributes.favoriteBusiness = snap['favorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  _shortcuts("Dining", () {
                    Feedback.forTap(context);
                    widget.setStateMain(1);
                    widget.setStateSearch(1);
                  }),
                  _shortcuts("Category", () {
                    Feedback.forTap(context);
                    widget.setStateMain(1);
                    widget.setStateSearch(0);
                  }),
                  _shortcuts("Near Me", () {
                    Feedback.forTap(context);
                  }),
                  _shortcuts("Most Popular", () {
                    Feedback.forTap(context);
                  }),
                ],
              ),
            ),
            _heading("Offers Near Me"),
            Container(
              height: screenHeight / 2.3,
              margin: EdgeInsets.only(
                top: screenHeight / 50,
                bottom: screenHeight / 50,
                left: screenWidth / 20,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Deals").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: _deal(
                            snap[index]['imageURL'],
                            snap[index]['businessName'],
                            snap[index]['category'],
                            "3-5 miles",
                            snap[index]['dealUsed'],
                            snap[index]['dealTotal'] - snap[index]['dealUsed'],
                            snap[index]['tagline'],
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            _heading("Favorite Businesses"),
            Container(
              height: screenHeight / 4.35,
              margin: EdgeInsets.only(
                top: screenHeight / 50,
                bottom: screenHeight / 50,
                left: screenWidth / 20,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Deals").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        if(Attributes.favoriteBusiness.contains(snap[index]['businessName'])) {
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: _imageClip(snap[index]['imageURL']),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _heading(String text) {
    return Padding(
      padding: EdgeInsets.only(
        right: screenWidth / 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _headingText(text),
          _underlineText("See All"),
        ],
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

  Widget _deal(
      String image,
      String businessName,
      String category,
      String distance,
      int used,
      int remaining,
      String tagline,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imageClip(image),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Text(
            businessName,
            style: TextStyle(
              fontFamily: "Actor",
              fontSize: screenHeight / 40,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _labelOffers(0, category),
            const SizedBox(width: 8,),
            _labelOffers(1, distance),
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
              ),
            ),
          ),
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
                tagline,
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
        child: Image.network(
          image,
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

  Widget _shortcuts(String text, VoidCallback function) {
    return GestureDetector(
      onTap: function,
      child: Container(
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