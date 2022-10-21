import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passportapp/attributes.dart';
import 'package:passportapp/model/deal.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/services/deal_service.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  final ValueSetter setStateMain;
  final ValueSetter setImageURL;
  final ValueSetter setBusinessName;
  const ProfileScreen({Key? key, required this.setStateMain, required this.setImageURL, required this.setBusinessName}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  int dealState = 0;
  int redeemed = 0;
  int savings = 0;
  double trX = 0;

  // //DEAL OF THE DAY
  // String idDeal = "";
  // String imageURL = "";
  // String tagline = "";
  // String category = "";
  // String businessName = "";
  String distance = "<1 Miles";

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      redeemed = UserAttributes.offersRedeemed;
      savings = UserAttributes.savingsEarned;
    });
  }

  Future<DealData> getDealOfTheDay() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    String dealOfTheDayID = await DealApi().getDealOfTheDay(token?.token);
    DealData deal = await DealApi().getDealById(token?.token, dealOfTheDayID);

    return deal;
    // setState(() {
    //   category = deal.category!;
    //   businessName = deal.businessName!;
    //   distance = "<1 Miles";
    //
    //   // (calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344)
    //   //     < 99 ? "${(calculateDistance(Attributes.locationData?.latitude, Attributes.locationData?.longitude, lat, long) * 1000 / 1609.344).toStringAsFixed(0)} miles"
    //   //     : "99+ miles";
    // });
  }

  double calculateDistance(lat1, long1, lat2, long2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((long2 - long1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    List<String> accounts = ["Live Chat", "Preferences", "Deals History", "Account\nInformation", "Notifications",];
    List<String> accountsIcon = ["chat", "preferences", "deals", "info", "notifications",];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: screenWidth / 20,
          right: screenWidth / 20,
          top: screenHeight / 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _stats(0),
                      SizedBox(height: screenHeight / 45,),
                      _smallerWidget(
                        0,
                        "idea",
                        "Learn How To Use\nMyrtle Beach\nPassport",
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    children: [
                      _stats(1),
                      SizedBox(height: screenHeight / 80,),
                      _smallerWidget(
                        1,
                        "goldPot",
                        "Refer a Friend,\nGet Rewarded",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight / 50,),
                      _headings("Account"),
                      for(int i = 0; i < accounts.length; i++)...<Widget>[
                        _accountItem(i, "account_${accountsIcon[i]}", accounts[i]),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Stack(
                    children: [
                      DottedBorder(
                        dashPattern: const [6, 3, 6, 3],
                        child: Container(
                          height: screenHeight / 2.33,
                          color: Attributes.yellow,
                          child: _dealToReveal(),
                        ),
                      ),
                      dealState == 0 ? SizedBox(
                        height: screenHeight / 2.3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: Attributes.blue,
                                child: Center(
                                  child: Text(
                                    "Swipe Up\nto Reveal Your\nDeal of the Day",
                                    style: TextStyle(
                                      fontFamily: "Actor",
                                      fontSize: screenHeight / 25,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onVerticalDragEnd: (v) {
                                  setState(() {
                                    dealState = 1;
                                  });
                                },
                                child: Container(
                                  color: Attributes.yellow,
                                  child: Center(
                                    child: Text(
                                      "Swipe Up",
                                      style: TextStyle(
                                        fontFamily: "Actor",
                                        fontSize: screenHeight / 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dealToReveal() {
    return FutureBuilder(
      future: getDealOfTheDay(),
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenWidth / 2.5,
                width: screenWidth / 2,
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    snapshot.data.imageURL ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _label(0, snapshot.data.category),
                  _label(1, distance),
                ],
              ),
              const SizedBox(height: 4,),
              Text(
                snapshot.data.tagline,
                style: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        widget.setImageURL(snapshot.data.imageURL ?? "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg");
                        widget.setBusinessName(snapshot.data.businessName);
                        widget.setStateMain(6);
                      },
                      child: _dealsButton("saveIcon", "Save"),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        Share.share("Check out deals of the day!");
                      },
                      child: _dealsButton("shareIcon", "Share"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
            ],
          );
        } else {
          return const SizedBox();
        }
      }
    );
  }

  Widget _dealsButton(String image, String text) {
    return Column(
      children: [
        SizedBox(
          height: screenWidth / 15,
          child: Image.asset(
            "assets/images/$image.png",
            width: screenWidth / 15,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: "Actor",
            fontSize: screenHeight / 70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _label(int options, String text) {
    return Container(
      height: screenHeight / 35,
      padding: EdgeInsets.only(
        top: options == 0 ? 2 : 0,
        bottom: options == 0 ? 4 : 0,
        left: 10,
        right: 10,
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
              fontSize: screenHeight / 70,
            ),
          ) : Row(
            children: [
              Image.asset(
                "assets/images/pinLocation.png",
                height: 14,
              ),
              Transform.translate(
                offset: const Offset(4, -1),
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: "Actor",
                    color: Colors.black54,
                    fontSize: screenHeight / 70,
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _accountItem(int i, String image, String text) {
    return GestureDetector(
      onTap: () {
        switch(i) {
          case 0:
            Feedback.forTap(context);
            widget.setStateMain(10);
            break;
          case 1:
            Feedback.forTap(context);
            widget.setStateMain(11);
            break;
          case 2:
            Feedback.forTap(context);
            widget.setStateMain(12);
            break;
          case 3:
            Feedback.forTap(context);
            widget.setStateMain(13);
            break;
          case 4:
            Feedback.forTap(context);
            widget.setStateMain(14);
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 4,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Attributes.blue),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: i != 0 ? const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ) : const EdgeInsets.all(0),
              child: Image.asset("assets/images/$image.png",),
            ),
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headings(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Actor",
        fontSize: screenHeight / 25,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _smallerWidget(int options, String image, String text) {
    return GestureDetector(
      onTap: () {
        if(options == 0) {
          Feedback.forTap(context);
          widget.setStateMain(8);
        } else {
          Feedback.forTap(context);
          widget.setStateMain(9);
        }
      },
      child: Stack(
        children: [
          Container(
            height: screenHeight / 7.5,
            width: screenWidth,
            margin: EdgeInsets.only(
                top: screenHeight / 30
            ),
            padding: const EdgeInsets.only(
              bottom: 8,
              right: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: options == 0 ? const Color(0xFFFFF5E7) : Attributes.blue,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: "Actor",
                  fontSize: screenHeight / 49.5,
                  color: options == 0 ? Colors.black : Colors.white,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Image.asset(
            "assets/images/$image.png",
            width: options == 0 ? screenWidth / 7.8 : screenWidth / 5.5,
          ),
        ],
      ),
    );
  }

  Widget _stats(int options) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 12,
        bottom: 12,
      ),
      height: screenHeight / 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: options == 0 ? Attributes.lightBlue : Attributes.yellow,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              options == 0 ? redeemed.toString()
                  : "\$$savings",
              style: TextStyle(
                fontFamily: "Actor",
                fontSize: screenHeight / 12,
                color: options == 0 ? Attributes.blue : Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              options == 0 ? "Offers\nRedeemed" : "You have\nSaved",
              style: TextStyle(
                fontFamily: "Actor",
                fontSize: screenHeight / 35,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

}
